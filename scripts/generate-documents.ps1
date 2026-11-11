# SPDX-FileCopyrightText: 2026 Elan8
# SPDX-License-Identifier: MIT
#Requires -Version 5.1
<#
.SYNOPSIS
    Check or build the kitchen-timer CRS, SRS, SDS and VVP with Doc42 0.7.0.

.DESCRIPTION
    Runs from anywhere. Uses DOC42, doc42 on PATH, or the sibling debug build.
    Supply the pinned domain-library model folder with -LibraryPath. Builds use
    ELAN8_TOKEN or a token saved by doc42 login. Reports and PDFs go to generated/.
#>
param(
    [string]$LibraryPath = (Join-Path $PSScriptRoot '../../sysml-domain-libraries/model'),
    [switch]$CheckOnly
)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$doc42 = $env:DOC42
if (-not $doc42) {
    $installed = Get-Command doc42 -ErrorAction SilentlyContinue
    if ($installed) {
        $doc42 = $installed.Source
    } else {
        $doc42 = Join-Path $root '../doc42/target/debug/doc42.exe'
    }
}
if (-not (Test-Path -LiteralPath $doc42)) {
    throw 'Install Doc42 0.7.0 on PATH or set DOC42 to its executable.'
}

if (-not (Test-Path -LiteralPath $LibraryPath)) {
    throw "Domain libraries were not found at '$LibraryPath'. Pass their model folder with -LibraryPath."
}
$library = (Resolve-Path -LiteralPath $LibraryPath).Path

$out = Join-Path $root "generated"
New-Item -ItemType Directory -Force -Path $out | Out-Null

& $doc42 check model --workspace-root $root --library-path $library --json |
    Set-Content -LiteralPath (Join-Path $out 'doc42-check.json') -Encoding UTF8
if ($LASTEXITCODE -ne 0) {
    $checkExit = $LASTEXITCODE
    if (Test-Path -LiteralPath (Join-Path $out 'doc42-check.json')) {
        Get-Content -LiteralPath (Join-Path $out 'doc42-check.json')
    }
    exit $checkExit
}
if ($CheckOnly) {
    Write-Host 'All document definitions passed Doc42 validation.'
    return
}

& $doc42 build model --workspace-root $root --library-path $library --all --out $out --json |
    Set-Content -LiteralPath (Join-Path $out 'documents.json') -Encoding UTF8
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
foreach ($number in @('KT-CRS-001', 'KT-SRS-001', 'KT-SDS-001', 'KT-VVP-001')) {
    $pdf = Join-Path $out "$number.pdf"
    if (-not (Test-Path -LiteralPath $pdf) -or (Get-Item -LiteralPath $pdf).Length -eq 0) {
        throw "Doc42 did not produce the expected document '$number.pdf'."
    }
}

Write-Host "Wrote all four kitchen-timer documents under $out"
