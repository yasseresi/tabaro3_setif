# AGENTS.md — Tabaro3 Sétif (CWTS Sétif Blood Donor Desktop App)

> **Organization**: المركز الولائي لحقن الدم سطيف — *Centre de Wilaya de Transfusion Sanguine (CWTS) – Sétif*  
> **App Type**: Offline-first Windows Desktop Application (developed & tested on macOS, packaged as `.exe` / `.msi` via GitHub Actions)  
> **Languages**: Bilingual Arabic (`ar`, RTL, default) & French (`fr`, LTR)

---

## 1. Quick Context & Documentation Map

Before writing or modifying code, read the relevant blueprint in `docs/`:

| Document | Purpose |
| :--- | :--- |
| [`docs/UI_AND_DOMAIN_SPEC.md`](docs/UI_AND_DOMAIN_SPEC.md) | Complete specification extracted from the Lovable prototype (`https://prototypeyasser.lovable.app`): screens, exact eligibility rules (3m Male / 4m Female), colors, SVGs, and the full Arabic/French translation table. |
| [`docs/STACK.md`](docs/STACK.md) | Selected tech stack (Flutter Desktop, Drift SQLite, Excel, PDF/Printing, Inno Setup `.exe` + GitHub Actions CI/CD). |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Lightweight Feature-First architecture, SQLite schema (`donors`, `donation_events`, `app_settings`), `%APPDATA%` storage layout, Smart-Merge Excel flow, and `.zip` backup/restore. |
| [`docs/SKILLS.md`](docs/SKILLS.md) | Which OpenCode agent skills to load per task—and which heavy patterns to skip. |
| [`docs/BEST_PRACTICES.md`](docs/BEST_PRACTICES.md) | Rules for SQLite safety, Arabic/French RTL-LTR switching, Excel parsing, PDF font shaping, and Windows packaging. |
| [`docs/WHAT_TO_AVOID.md`](docs/WHAT_TO_AVOID.md) | Hard guardrails against common Flutter Windows, SQLite, Excel, and Arabic PDF bugs. |
| [`docs/RELEASE_AND_VERSIONING.md`](docs/RELEASE_AND_VERSIONING.md) | Two-channel release model (`beta` branch → Pre-release vs `main` branch → Stable Release), SemVer naming, and isolated `%APPDATA%` folders. |

---

## 2. Core Architectural Decisions (Locked)

1. **Stack**: Flutter Desktop (Windows target + macOS dev host) + **Drift** (`drift` + `sqlite3_flutter_libs`) for local SQLite.
2. **Architecture**: **Simple Feature-First (Lightweight)**.
   - **No over-engineering**: Do NOT add `dio`, `retrofit`, `dartz` (`Either`), `rxdart`, or multi-layer UseCase/Repository/Mapper boilerplate. This is a 100% offline local SQLite desktop app.
   - Use **Drift** reactive queries (`Stream` / `Future`) + lightweight controllers (`ChangeNotifier` / `ValueNotifier`) per feature.
   - Centralize all UI tokens, colors, typography, and bilingual strings (`ar` / `fr`) in `lib/core/resources/`.
3. **Database & Storage**:
   - Store the SQLite database (`tabaro3_setif.sqlite`), donor photos (`photos/`), and rolling automatic backups (`backups/`) inside the OS Application Support directory (`getApplicationSupportDirectory()`, i.e. `%APPDATA%\CWTS_Setif\tabaro3_setif\` on Windows)—**never** in the install directory (`Program Files`) or working directory.
   - Store donor photos as resized local files (`photos/<donor_id>.jpg`), storing only the relative filename in SQLite—**never** as multi-megabyte Base64 strings in SQLite.
4. **Domain Rules**:
   - **Eligibility interval**: **3 calendar months** for men (`M`), **4 calendar months** for women (`F`), calculated from `max(last_donation, last_test)` with end-of-month clamping.
   - **Statuses**:
     - `due` (`<= 0` days remaining)
     - `soon` (`1..7` days remaining)
     - `wait` (`> 7` days remaining)
     - `none` (no `last_donation` and no `last_test`)
   - **Donation History**: Recording a donation or blood test inserts a row in `donation_events` AND updates `donors.last_donation` / `donors.last_test` inside a single SQLite transaction.
5. **Import / Export & PC-to-PC Migration**:
   - **Smart-Merge Excel Import**: Match existing donors by normalized phone number (or exact normalized `name + blood_group` when phone is empty) and upsert/merge instead of duplicating rows.
   - **2-Sheet Excel Export**: Sheet 1 (`Donneurs`) matches the 10-column clinic format; Sheet 2 (`Historique`) exports `donation_events`.
   - **Full System `.zip` Backup / Restore**: Bundles `tabaro3_setif.sqlite` + `photos/` into a single `.zip` archive to move the entire system (including photos and history) to another desktop PC.
6. **Data Safety Guardrails**:
   - Single local admin login (default `admin` / `admin`, hashed in SQLite, editable in Settings).
   - "Reset All Data" and bulk imports **must** automatically create a timestamped `.zip` backup in `backups/` first and require password confirmation before wiping data.
7. **Beta vs Stable Channels (`beta` & `main` branches)**:
   - Pushing to `beta` auto-builds `vX.Y.Z-beta.<run_number>` (GitHub Pre-release) with `APP_ENV=beta`, using an isolated `%APPDATA%\CWTS_Setif\tabaro3_setif_beta\` folder and `[BETA]` badge so testing never touches live clinic data.
   - Merging `beta` into `main` auto-builds `vX.Y.Z` (GitHub Latest Stable Release) with `APP_ENV=stable`, using `%APPDATA%\CWTS_Setif\tabaro3_setif\`.

---

## 3. Development Commands

```bash
# Run locally on macOS during development
flutter run -d macos

# Generate Drift SQLite code after editing tables/queries
dart run build_runner build --delete-conflicting-outputs

# Analyze & run unit/widget tests
flutter analyze
flutter test

# Build Windows release (on Windows or in GitHub Actions)
flutter build windows --release
```

---

## 4. Coding Conventions & Ponytail Mode

- **Smallest complete change**: Solve the whole problem with the least new code. Reuse existing widgets (`AppPanel`, `FormRow`, `StatusBadge`) and Drift queries.
- **Zero hardcoded UI values**: Every string must go through the `ar`/`fr` dictionary in `lib/core/resources/app_strings.dart`, and every color/radius/spacing through `lib/core/resources/app_theme.dart`.
- **RTL/LTR discipline**: Use directional layout APIs (`EdgeInsetsDirectional`, `AlignmentDirectional`, `TextAlign.start`). Always wrap phone numbers (`0551...`) and blood groups (`O+`, `AB-`) in `Directionality(textDirection: TextDirection.ltr, ...)` so `+` and `-` signs never flip in Arabic mode (`A+` must not render as `+A`).
- **Tests**: Add focused unit tests in `test/` for eligibility date math, Excel date parsing, and smart-merge deduplication.
