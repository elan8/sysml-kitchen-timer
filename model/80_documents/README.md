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

The script looks for Doc42 at `DOC42`, or at `../doc42/target/debug/doc42.exe`. It passes `../sysml-domain-libraries/model` as the library path. PDFs are named from the document number and written to `generated/`, which is gitignored.

A debug build of Doc42 can mint a seven-day development license when `ELAN8_LICENSE` is unset. A release build needs a real license. Spec42 still checks the model on its own, with the libraries bundled in the 0.59.2 release. Do not point that check at a second copy of the domain libraries.
