# Technology Stack & CI/CD Packaging

## 1. Why Flutter Desktop (Windows Native + macOS Dev)

- **True Native Compilation**: Compiles Dart to native x64 Windows machine code (`tabaro3_setif.exe`) rendered via Skia/Impeller.
- **Zero WebView2 Dependency**: Unlike web-wrapper frameworks, Flutter draws every pixel itself using bundled `Cairo` fonts. It looks and behaves identically on Windows 10 and Windows 11 clinic PCs even on completely air-gapped/offline hospital networks.
- **Develop on macOS, Ship to Windows**: You develop and debug at 120fps natively on macOS (`flutter run -d macos`), while GitHub Actions (`windows-latest`) compiles the Windows release and packages `.exe` and `.msi` installers automatically.

---

## 2. Approved Package List (`pubspec.yaml`)

Keep dependencies lean (`ponytail` principle: never add a package for what 10 lines of Dart can do).

### Core Runtime Dependencies
| Category | Package | Why This Package |
| :--- | :--- | :--- |
| **Local Database** | `drift`, `sqlite3_flutter_libs`, `sqlite3` | Type-safe reactive SQLite queries, transactions, schema migrations, and zero-config native `sqlite3.dll` bundling on Windows & macOS. |
| **Paths & Files** | `path_provider`, `path` | Resolves `%APPDATA%\CWTS_Setif\tabaro3_setif` on Windows and `~/Library/Application Support/...` on macOS. |
| **Excel (`.xlsx`)** | `excel` (or `syncfusion_flutter_xlsio` for write + `excel` for read) | Pure-Dart reading & writing of `.xlsx` workbooks without requiring Microsoft Office to be installed on the clinic PC. |
| **CSV Fallback** | `csv` | Supports `.csv` import alongside `.xlsx` as shown in the prototype. |
| **File Picker** | `file_picker` | Native Windows/macOS Open & Save dialogs for `.xlsx`, `.zip`, and donor photos. |
| **Backup Archive** | `archive` | Pure-Dart `.zip` creation and extraction for 1-click full database + photos backup/restore. |
| **PDF & Printing** | `pdf`, `printing` | Generates vector `بطاقة متبرع / Fiche donneur` cards with embedded `Cairo` fonts and opens the native Windows Print / Save-as-PDF preview. |
| **Password Hash** | `crypto` | Official Dart team package for salted SHA-256 local admin password hashing. |
| **UUIDs** | `uuid` | Generates RFC-4122 v4 UUIDs for donor IDs. |
| **Icons** | `lucide_icons_flutter` (or `lucide_icons`) | Matches the exact Lucide icons used in the Lovable prototype (`droplet`, `heart`, `users`, `user-plus`, `bell`, `file-spreadsheet`, `settings`, `printer`). |
| **Window Control** | `window_manager` | Sets minimum desktop window size (`1024x700`), window title, and clean desktop framing. |
| **Desktop Alerts** | `local_notifier` | Native Windows Toast notifications for newly eligible donors. |

### Dev Dependencies
| Package | Role |
| :--- | :--- |
| `drift_dev`, `build_runner` | Generates SQLite table classes and reactive queries at build time. |
| `flutter_test` | Unit and widget testing for eligibility math, Excel smart-merge, and UI flows. |
| `flutter_lints` | Standard static analysis rules. |

---

## 3. What We Deliberately Excluded (Do Not Add)

- **No `dio`, `retrofit`, `http`**: The app is 100% offline.
- **No `dartz`, `fpdart`, `rxdart`, `flutter_bloc`, `get_it`, `injectable`**: Unnecessary ceremony for a 6-screen local SQLite desktop app. Drift already provides reactive `Stream`s and `Future`s out of the box.
- **No `google_fonts` runtime fetching**: Hospital PCs in Sétif may be offline. Bundle `Cairo-Regular.ttf`, `Cairo-SemiBold.ttf`, `Cairo-Bold.ttf`, and `Cairo-ExtraBold.ttf` directly in `assets/fonts/` and declare them in `pubspec.yaml`.

---

## 4. Windows Installer Strategy (`.exe` + `.msi`)

### Primary Installer: Inno Setup (`.exe`)
- **Why Inno Setup (`iscc`)**:
  - Pre-installed on every GitHub Actions `windows-latest` runner.
  - Produces a single compressed `Tabaro3_Setif_Setup_vX.Y.Z.exe` (~18–25 MB).
  - Supports `PrivilegesRequired=lowest` (installs cleanly into `%LOCALAPPDATA%\Programs\Tabaro3Setif` even if the hospital receptionist does not have Windows Administrator privileges!).
  - Supports French & Arabic installer wizard pages, Desktop shortcut creation, and clean uninstallation (while leaving `%APPDATA%` donor data untouched on upgrade).
  - Bundles `msvcp140.dll`, `vcruntime140.dll`, and `vcruntime140_1.dll` alongside `tabaro3_setif.exe` so the app never fails with *"VCRUNTIME140.dll was not found"* on older Windows machines.

### Optional Secondary Installer: WiX Toolset (`.msi`)
- Also pre-installed on GitHub Actions `windows-latest` (`wix`). Can be generated in the same workflow for IT administrators who prefer `.msi` group-policy deployment.

### Why NOT `.msix`
- Windows blocks `.msix` packages unless signed by a paid commercial certificate ($300+/yr) or manually trusted via PowerShell/Registry in Local Machine Root Certificates. Always ship a standard `.exe` (Inno Setup) and/or `.msi` so any clinic computer can install it immediately.

---

## 5. GitHub Actions CI/CD Release Blueprint (`.github/workflows/release.yml`)

When ready to wire CI/CD, use this workflow structure so pushing a git tag `v1.0.0` automatically tests, compiles on Windows, bundles VC++ runtime DLLs, builds the `.exe` installer, and publishes it to GitHub Releases:

```yaml
name: Build & Release Windows Installer

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:

permissions:
  contents: write

jobs:
  build-windows:
    runs-on: windows-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      - name: Install dependencies & verify tests
        run: |
          flutter pub get
          flutter analyze
          flutter test

      - name: Build Windows Release
        run: flutter build windows --release

      - name: Copy VC++ Redistributable DLLs into Release Bundle
        shell: pwsh
        run: |
          $sys32 = "$env:SystemRoot\System32"
          $dest = "build\windows\x64\runner\Release"
          Copy-Item "$sys32\vcruntime140.dll" $dest -Force
          Copy-Item "$sys32\vcruntime140_1.dll" $dest -Force
          Copy-Item "$sys32\msvcp140.dll" $dest -Force

      - name: Compile Inno Setup (.exe) Installer
        run: iscc installer/tabaro3_setif.iss

      - name: Publish Installers to GitHub Release
        if: startsWith(github.ref, 'refs/tags/v')
        uses: softprops/action-gh-release@v2
        with:
          files: |
            build/installer/*.exe
```
