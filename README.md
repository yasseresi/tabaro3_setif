# Tabaro3 Sétif — Blood Donor Management (CWTS Sétif)

> **برنامج إدارة المتبرعين بالدم — المركز الولائي لحقن الدم سطيف**  
> **Gestion des donneurs de sang — Centre de Wilaya de Transfusion Sanguine, Sétif**

An offline-first desktop application for managing blood donors at the CWTS Sétif transfusion centre. Built for real clinic reception desks: no internet required, no server, no cloud — just a local database and a printable donor card.

---

## Status

**Design & specification phase.** The application is being specified before implementation. This repository will hold the Flutter desktop application, its Windows installer pipeline, and the release artifacts.

---

## Planned Features

| Area | Scope |
| :--- | :--- |
| **Donor records** | Create, edit, search and filter donors (name, gender, blood group, phone, address, birth date, notes, photo). |
| **Eligibility tracking** | Next-eligible date computed from the most recent donation or blood test, using the medical rule of **3 months for men** and **4 months for women**, with end-of-month clamping. |
| **Donation history** | Every donation and blood test is logged as an event instead of overwriting the last date, so a donor's full history is preserved. |
| **Reminders** | A worklist of donors who are eligible now or become eligible within 7 days, with a one-click "donated today" action and desktop notifications. |
| **Printing** | Printable A4/A5 donor card generated as a PDF, with correct Arabic text shaping, printable directly or saved as a PDF file. |
| **Excel import / export** | Two-sheet `.xlsx` export (donors + history) and a smart-merge import that matches existing donors by phone number instead of duplicating rows. |
| **Backup & migration** | One-click `.zip` backup and restore of the full system (database + photos) for moving between clinic computers. |
| **Bilingual UI** | Full Arabic (RTL, default) and French (LTR) interface with an instant language switch. |

---

## Planned Stack

- **Flutter Desktop** — native Windows build, developed on macOS, packaged as `.exe` / `.msi` through GitHub Actions.
- **Drift (SQLite)** — local, reactive, transactional storage. All data stays on the clinic computer.
- **PDF + printing** — native print dialog and save-as-PDF.
- **Bilingual fonts bundled offline** — no runtime font downloads.

### Data location

All mutable data lives in the OS application-data directory, never next to the executable:

```
%APPDATA%\CWTS_Setif\tabaro3_setif\
├── tabaro3_setif.sqlite    # database
├── photos\                 # resized donor photos
└── backups\                # automatic backups taken before destructive actions
```

---

## Releases

Two release channels will be published here:

| Channel | Version | Description |
| :--- | :--- | :--- |
| **Stable** | `vX.Y.Z` | Verified builds for production clinic use. |
| **Beta** | `vX.Y.Z-beta.N` | Pre-release builds with an isolated database folder, safe to install side by side with Stable. |

Windows installers are built and published automatically from GitHub Actions.

---

## License

Released under the [MIT License](LICENSE).

---

## Disclaimer

This software is a records-management tool. It does not provide medical advice and does not replace clinical judgement or official transfusion-centre procedures.
