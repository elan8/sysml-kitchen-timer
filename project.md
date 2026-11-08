# Kitchen timer model baseline

This project follows MBSE methodology 0.5.0: one context, stakeholder needs, a
shared library, and flat systems. Recursive composition is by part usage.
`Root.sysml` aliases the selected occurrence `KitchenTimerSystem::kitchenTimer`
as `systemOfInterest`.

Validation uses the Spec42 **0.59.2** release binary
(`https://github.com/elan8/spec42/releases/tag/v0.59.2`). That release bundles
the SysML v2 standard library **2026-04** and Elan8 domain libraries **0.5.0**.
No extra library path is required. Do not also point Spec42 at a second copy of
the domain libraries.

```powershell
spec42 check model --workspace-root .
```

The selected baseline is a segmented-LCD timer on a CR2032 cell, with no
regulator. The reference day is two countdowns, each with 20 s of setting, 8
min of running and 8 s of alarm. Mode currents are whole-timer exclusive modes.
Readability means legible at 0.5 m under about 100 lux without a backlight.
Alarm loudness is specified at 0.3 m. On that baseline Spec42 evaluates about
47844 h of life (176 mAh at 0.00368 mA), 37.2 g and EUR 3.86, and the
selected-design checks pass. Display alternatives and behavioral simulation
are not part of this baseline.

The customer requirements specification (KT-CRS-001), system requirements
specification (KT-SRS-001), system design specification (KT-SDS-001) and
verification and validation plan (KT-VVP-001) are views in
`model/80_documents`. From the repository root:

```powershell
.\scripts\generate-documents.ps1
```

That script runs Doc42. PDFs go to `generated/` and are not committed. A debug
build of Doc42 at `../doc42/target/debug/doc42.exe` is the default executable;
set `DOC42` to override it. When `ELAN8_LICENSE` is unset, the script mints a
seven-day development license. A release build needs a real license. Doc42 is
given `../sysml-domain-libraries/model` so the document metadata resolves.
Spec42 keeps using the copy bundled in the 0.59.2 release.

`spec42 check` reports `view_type_non_standard` for the Elan8 context,
specification, architecture and integration views. Those views resolve; the
warning says their definitions are not in the standard view table.
