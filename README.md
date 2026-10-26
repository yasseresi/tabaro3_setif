# برنامج إدارة المتبرعين بالدم – المركز الولائي لحقن الدم سطيف

**Gestion des donneurs de sang — Centre de Wilaya de Transfusion Sanguine (CWTS) Sétif**

Offline-first **Windows desktop app** (Flutter) for managing blood donors, eligibility
reminders (3 months for men / 4 months for women), Excel import/export, printable
donor cards and the official **CSW « Fiche Donneur de Sang »** form (ANS/COL/FIC02/V01/22).

Bilingual: **Arabic (RTL, default)** & **French (LTR)** with instant direction switching.

---

## Features

| Area | What it does |
| :--- | :--- |
| **Login** | Single local admin (`admin` / `admin`), salted SHA-256 hash, editable in Settings. |
| **Dashboard** | KPIs (total / eligible now / eligible this week), blood-group chart, recent donors. |
| **Donors** | Search, filter by group & status, paginated table (10/page), edit / delete. |
| **Donor form** | Full identity (name, maiden name, birth date, home & work addresses, e-mails, phones), photo (resized JPEG on disk, never Base64 in DB), live eligibility preview, donation history. |
| **Alerts** | Donors `due` or `soon`, most overdue first; call helper (copies phone + big display) and one-click **"Mark Donated Today"** (records history in one SQLite transaction). |
| **Import / Export** | Smart-merge Excel import (match by phone, else name+group; never duplicates), 2-sheet export (`Donneurs` + `Historique`), empty template, **full `.zip` backup/restore** (DB + photos, `VACUUM INTO` snapshot). |
| **Printing** | Bilingual donor card PDF + the official **CSW Fiche Donneur de Sang** (identity block, donation table: Date / N° / TA / Poids / Type de don / Bilan / Contre-indications, ABO-Rhésus-Phénotype block), blank or pre-filled. |
| **Safety** | Automatic timestamped `.zip` backup before every destructive action (bulk import, restore, reset) + password gate + rolling prune (keep 10). |

### Eligibility rule (locked)

- Reference date = `max(lastDonation, lastTest)`.
- Next eligible = reference + **3 calendar months (M)** / **4 calendar months (F)**,
  with end-of-month clamping (`Nov 30 + 3m → Feb 28`).
- Statuses: `due` (eligible), `soon` (≤ 7 days), `wait`, `none`.

---

## Data storage (never in `Program Files`)

All mutable data lives in the OS Application Support directory:

- **Windows**: `%APPDATA%\CWTS_Setif\tabaro3_setif\{tabaro3_setif.sqlite, photos\, backups\}`
- **macOS (dev)**: `~/Library/Application Support/com.cwtssetif.tabaro3Setif/CWTS_Setif/tabaro3_setif/`

SQLite with **WAL mode + foreign keys ON**; donor photos stored as resized files
(`photos/<id>.jpg`, ≤ 600px), only the filename in the DB.

## Releases (beta & stable channels)

| Channel | Branch | Artifact | Data folder |
| :--- | :--- | :--- | :--- |
| Beta (Pre-release) | `beta` | `Tabaro3_Setif_Beta_Setup_vX.Y.Z-beta.N.exe` | `tabaro3_setif_beta` |
| Stable (Latest) | `main` | `Tabaro3_Setif_Setup_vX.Y.Z.exe` | `tabaro3_setif` |

Pushing to `beta` or `main` triggers **GitHub Actions**: analyze → test →
`flutter build windows --release` → bundle VC++ runtime DLLs → Inno Setup `.exe` →
GitHub Release. Beta and stable install side-by-side and never share data.

## Development

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after editing Drift tables
flutter run -d macos        # develop on macOS
flutter analyze && flutter test
flutter build windows --release
```

Docs: [`docs/`](docs/) — spec (`UI_AND_DOMAIN_SPEC.md`), stack, architecture,
best practices, guardrails, release/versioning.

License: see [LICENSE](LICENSE).
