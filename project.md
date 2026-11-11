# Kitchen timer model baseline

This project follows MBSE methodology 0.5.0: one context, stakeholder needs, a
shared library, and flat systems. Recursive composition is by part usage.
`Root.sysml` aliases the selected occurrence `KitchenTimerSystem::kitchenTimer`
as `systemOfInterest`.

Validation uses the Spec42 **0.60.2** release binary
(`https://github.com/elan8/spec42/releases/tag/v0.60.2`). That release bundles
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
47844 h of life (176 mAh at 0.00368 mA), 37.2 g and EUR 3.97, and the
selected-design checks pass. Display alternatives and behavioral simulation
are not part of this baseline.

The customer requirements specification (KT-CRS-001), system requirements
specification (KT-SRS-001), system design specification (KT-SDS-001) and
verification and validation plan (KT-VVP-001) are views in
`model/80_documents`. From the repository root:

```powershell
.\scripts\generate-documents.ps1
```

That script runs Doc42 **0.7.0**. PDFs, the document manifest and check report go
to `generated/` and are not committed. Install Doc42 on PATH or set `DOC42` to
its executable. Set `ELAN8_TOKEN` or use `doc42 login` for local builds. Use
`-CheckOnly` to validate documents without authentication. The library path
defaults to `../sysml-domain-libraries/model`; override it with `-LibraryPath`.
CI pins that vocabulary to `146fe5ca70e76d8692e96f4a666e974592c40abc`, the
revision used for the Doc42 release samples. Spec42 uses its bundled libraries.

`spec42 check` reports no errors or warnings with the pinned release. The
custom Elan8 views resolve through their specialization of standard views.
