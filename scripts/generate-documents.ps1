# SPDX-FileCopyrightText: 2026 Elan8
# SPDX-License-Identifier: MIT
#Requires -Version 5.1
<#
.SYNOPSIS
    Generate the kitchen-timer CRS, SRS, SDS and VVP with Doc42.

.DESCRIPTION
    Runs from anywhere. Writes PDFs under generated/ at the repository root.
    Those PDFs are gitignored.

    Doc42 is resolved from $env:DOC42, otherwise from ..\doc42\target\debug\doc42.exe.
    Building the documents needs ELAN8_LICENSE. When it is unset, a debug build
    can mint a seven-day throwaway license with the dev-license example.
    Release builds ignore that license and need a real Elan8 license.
#>
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$doc42 = $env:DOC42
if (-not $doc42) {
    $doc42 = Join-Path $root "..\doc42\target\debug\doc42.exe"
}
if (-not (Test-Path -LiteralPath $doc42)) {
    throw "Doc42 was not found at '$doc42'. Build it from the doc42 repository, or set DOC42 to the executable."
}

$library = Join-Path $root "..\sysml-domain-libraries\model"
if (-not (Test-Path -LiteralPath $library)) {
    throw "Domain libraries were not found at '$library'."
}

if (-not $env:ELAN8_LICENSE) {
    $example = Join-Path (Split-Path -Parent $doc42) "examples\dev-license.exe"
    if (-not (Test-Path -LiteralPath $example)) {
        throw "ELAN8_LICENSE is not set, and the dev-license example was not found at '$example'."
    }
    $licenseDir = Join-Path $env:TEMP "doc42-kitchen-timer-license"
    $lines = & $example $licenseDir
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    foreach ($line in $lines) {
        if ($line -match '^export\s+([A-Za-z0-9_]+)=(.*)$') {
            Set-Item -Path "Env:$($Matches[1])" -Value $Matches[2]
        }
    }
    if (-not $env:ELAN8_LICENSE) {
        throw "The dev-license example did not print an ELAN8_LICENSE value."
    }
}

$out = Join-Path $root "generated"
New-Item -ItemType Directory -Force -Path $out | Out-Null

& $doc42 check model --workspace-root $root --library-path $library
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

foreach ($name in @("crs", "srs", "sds", "vvp")) {
    & $doc42 build model --workspace-root $root --library-path $library --doc "KitchenTimerDocuments::$name" --out $out
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Write-Host "Wrote the kitchen-timer documents under $out"
