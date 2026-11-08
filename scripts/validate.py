# SPDX-FileCopyrightText: 2026 Elan8
# SPDX-License-Identifier: MIT
"""Validate the model with Spec42.

Runs `spec42 check model --workspace-root .` and fails on any error, and on any
warning other than the accepted ones below. Spec42 is taken from $SPEC42_EXE,
otherwise from PATH.
"""
import json
import os
import subprocess
import sys
from pathlib import Path

# Spec42 reports custom views that specialise a standard view definition
# (ContextView, SpecificationView, ArchitectureView, ...) as non-standard.
# They are valid SysML; the finding is a Spec42 limitation.
ACCEPTED_WARNINGS = {"view_type_non_standard"}

ROOT = Path(__file__).resolve().parent.parent


def main():
    spec42 = os.environ.get("SPEC42_EXE", "spec42")
    result = subprocess.run(
        [spec42, "check", "model", "--workspace-root", ".", "--format", "json"],
        cwd=ROOT, capture_output=True, text=True,
    )
    try:
        report = json.loads(result.stdout)
    except json.JSONDecodeError:
        sys.stderr.write(result.stderr)
        raise SystemExit(f"spec42 check did not report JSON (exit {result.returncode})")

    failures, accepted = [], 0
    for document in report["documents"]:
        path = document["uri"].removeprefix("file://")
        for diagnostic in document["diagnostics"]:
            line = diagnostic["range"]["start"]["line"] + 1
            severity = {1: "error", 2: "warning"}.get(diagnostic.get("severity"), "info")
            text = f"{os.path.relpath(path, ROOT)}:{line}: {severity}[{diagnostic.get('code')}] {diagnostic['message']}"
            if severity == "error" or (
                severity == "warning" and diagnostic.get("code") not in ACCEPTED_WARNINGS
            ):
                failures.append(text)
            elif severity == "warning":
                accepted += 1
    for failure in failures:
        print(failure)
    print(f"{len(report['documents'])} source files: {len(failures)} finding(s), "
          f"{accepted} accepted warning(s) ({', '.join(sorted(ACCEPTED_WARNINGS))})")
    if failures or result.returncode != 0:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
