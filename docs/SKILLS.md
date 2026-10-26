# Agent Skills Guide (`docs/SKILLS.md`)

This guide maps the skills installed in your OpenCode environment to specific tasks in **Tabaro3 Sétif**, and explains which parts of each skill to use vs skip so the codebase stays lightweight (`ponytail` mode).

---

## 1. Primary Skills to Use (and How to Adapt Them)

| Task / Phase | Skill to Load | How to Use It in This Repo |
| :--- | :--- | :--- |
| **Keep code minimal & direct** | `ponytail` | **Always on.** Write the smallest complete change. Skip unrequested abstractions, wrapper classes, or extra layers. |
| **Centralizing Colors, Fonts, Strings, Theme** | `flutter-resources-centralization`, `flutter-ui-design-system`, `flutter-setup-localization` | **Use** the centralized `lib/core/resources/` pattern (zero hardcoded colors, strings, or font sizes in widgets) and `flutter-setup-localization` for Arabic (`RTL`) & French (`LTR`) `Directionality` setup. |
| **Dart 3 Sealed Classes & Pattern Matching** | `dart-use-pattern-matching` | Use Dart 3 `switch` expressions, records, and exhaustive pattern matching for `EligibilityStatus` (`due`, `soon`, `wait`, `none`) and import results without needing `freezed` or `dartz`. |
| **Desktop & Responsive Layouts** | `flutter-build-responsive-layout` | Use when building the 2-column Add/Edit Donor form, Dashboard charts, and resizable Windows desktop tables (`1024x700` up to `1920x1080`). |
| **Fixing RenderFlex / Overflow / Runtime Bugs** | `flutter-fix-layout-issues`, `dart-fix-runtime-errors` | Use immediately if switching between Arabic (`RTL`) and French (`LTR`) or resizing the desktop window causes `RenderFlex overflowed` or runtime errors. |
| **Static Analysis & Package Resolution** | `dart-run-static-analysis`, `dart-resolve-package-conflicts` | Run `dart analyze` and `dart fix --apply` before every commit, and use `dart-resolve-package-conflicts` if `pub get` hits version constraints. |
| **Unit Testing Eligibility & Excel Logic** | `dart-add-unit-test` & `tdd` | Use when implementing `eligibility.dart` (3m/4m clamped month addition), Excel date parsing (`DD/MM/YYYY`, `YYYY-MM-DD`, serial dates), and Smart-Merge upsert logic. |
| **Widget Testing Screens** | `flutter-add-widget-test` | Use to test the Login flow, Donor Form validation (`name` + `bloodGroup` required), and Alerts "Mark Donated Today" button. |
| **GitHub Actions Windows Installer & CI** | `ci-cd-and-automation`, `github-actions-templates`, `gh-fix-ci` | Use when setting up or debugging `.github/workflows/release.yml` (`beta` & `main` channels) and `installer/tabaro3_setif.iss` (Inno Setup `.exe`). |
| **Pre-Merge Code Review** | `ponytail-review` | Run before finishing any feature to verify logic, edge cases (leap years, RTL/LTR blood groups, locked `.xlsx` files), and zero dead code. |
| **Up-to-Date Package Docs** | `context7-mcp` / `documentation-lookup` | Use via `execute` (`tools.context7`) if you need current API syntax for `drift`, `pdf`, `printing`, `excel`, or `window_manager`. |

---

## 2. Installed Skills to SKIP (Or Use Selectively)

Because we chose the **Simple Feature-First (Lightweight)** architecture for a 100% offline local SQLite desktop app, **DO NOT** blindly apply these heavy enterprise skills:

| Skill | Why to Skip / What to Ignore |
| :--- | :--- |
| `flutter-api-integration` | **Skip completely.** There is no REST API, no `dio`, no `retrofit`, and no `NetworkInfo` check. All data lives in local Drift SQLite. |
| `flutter-clean-architecture` | **Skip the 11-file vertical slice.** Do not create `Request -> API -> Response -> Mapper -> RemoteDataSource -> Repository -> UseCase -> ViewModel` for local SQLite tables. Call Drift DAO/database methods directly from feature screens or thin services. |
| `flutter-mvvm-state` | **Skip `rxdart` `BehaviorSubject<FlowState>` + `freezed` form objects.** Use standard Flutter `StreamBuilder` (wired directly to Drift's `.watch()` queries) and `ValueNotifier` / `StatefulWidget` controllers for forms. |
| `flutter-error-handling` | **Skip `dartz` `Either<Failure, T>` and HTTP `ResponseCode` tables.** Instead, use standard Dart `try / catch` around file I/O (Excel import/export, PDF printing, `.zip` backup) and show user-friendly localized toast/snackbar messages. |

---

## 3. Recommended Implementation Order (Workflow with Skills)

1. **Step 1 — Core Domain & SQLite (`dart-add-unit-test`)**:
   - Implement `lib/core/domain/eligibility.dart` + unit tests (`test/eligibility_test.dart`).
   - Implement `lib/data/app_database.dart` (Drift tables: `Donors`, `DonationEvents`, `AppSettings`) + unit tests (`test/database_test.dart`).
2. **Step 2 — Design System & Brand Shell (`flutter-resources-centralization`)**:
   - Implement `lib/core/resources/` (`app_colors.dart`, `app_strings.dart`, `app_theme.dart` with bundled `Cairo` font).
   - Implement `brand_emblems.dart` (Algerian Flag SVG & Blood Drop Heart SVG), `status_badge.dart`, `ltr_text.dart`, and `app_shell.dart`.
3. **Step 3 — Feature Screens (`flutter-build-responsive-layout`)**:
   - `login_screen.dart` -> `dashboard_screen.dart` -> `donors_list_screen.dart` -> `donor_form_screen.dart` -> `alerts_screen.dart` -> `settings_screen.dart`.
4. **Step 4 — Excel, PDF Print & ZIP Backup (`dart-add-unit-test`)**:
   - `excel_service.dart` (2-sheet export, template, Smart-Merge import) + unit tests.
   - `pdf_card_service.dart` (printable Donor Card with embedded `Cairo` font).
   - `backup_service.dart` (`.zip` export/restore + auto-backup before reset).
5. **Step 5 — Windows Installer & CI/CD (`ci-cd-and-automation` + `ponytail-review`)**:
   - `installer/tabaro3_setif.iss` + `.github/workflows/release.yml`.
