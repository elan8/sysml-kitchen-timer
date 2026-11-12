# Engineering documents

`Documents.sysml` selects the four documents from the model with `Elan8::Documents`. `prose/` holds the longer Markdown sections. `template/` is the Elan8 house template shared by every document: the cover subtitle is the document kind.

| View | Number | Document |
| --- | --- | --- |
| `crs` | KT-CRS-001 | Customer Requirements Specification |
| `srs` | KT-SRS-001 | System Requirements Specification |
| `sds` | KT-SDS-001 | System Design Specification |
| `vvp` | KT-VVP-001 | Verification and Validation Plan |

From the repository root:

```powershell
.\scripts\generate-documents.ps1
```

The script uses Doc42 **0.8.0** from `DOC42`, PATH, or `../doc42/target/debug/doc42.exe`. It defaults to `../sysml-domain-libraries/model`; use `-LibraryPath` for another checkout. CI pins the vocabulary to `4c73195b2f64176696b2e0f4d72606bfd044dcef`. PDFs are named from the document number and written to `generated/`, which is gitignored, alongside `doc42-check.json` and `documents.json`.

Run `doc42 login` locally, or set `ELAN8_TOKEN`, to build PDFs. `-CheckOnly` checks every document definition without a token. CI uses the existing `ELAN8_TOKEN` secret for trusted runs and uploads the four PDFs plus manifest as `kitchen-timer-documents`; fork and Dependabot pull requests validate without generation. Spec42 checks the model separately with the libraries bundled in **0.60.2**. Do not point that check at a second copy of the domain libraries.
