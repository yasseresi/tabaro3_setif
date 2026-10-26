# Versioning, Branching & Beta/Stable Release Strategy (`docs/RELEASE_AND_VERSIONING.md`)

## 1. Overview: Two-Channel Release Model (`beta` vs `stable`)

To let you test new features and SQLite migrations on real Windows PCs without ever risking the live clinic database at CWTS Sétif, the project uses a **two-branch, side-by-side release architecture**:

| Channel | Git Branch | Version Format | GitHub Release Type | Windows Install Folder | SQLite `%APPDATA%` Folder |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Beta** | `beta` | `v1.2.0-beta.14` | **Pre-release** (Yellow badge) | `%LOCALAPPDATA%\Programs\Tabaro3SetifBeta` | `%APPDATA%\CWTS_Setif\tabaro3_setif_beta\` |
| **Stable** | `main` | `v1.2.0` | **Latest Release** (Green badge) | `%LOCALAPPDATA%\Programs\Tabaro3Setif` | `%APPDATA%\CWTS_Setif\tabaro3_setif\` |

### Why Isolated Beta & Stable Folders Matter
- **Side-by-Side Installation**: Both **Tabaro3 Sétif** (Stable) and **Tabaro3 Sétif (Beta)** can be installed on the exact same Windows computer at the same time with separate Desktop shortcuts.
- **Zero Risk to Live Data**: If a Beta build introduces a new SQLite schema migration (`schemaVersion` bump) that has a bug, it only touches `tabaro3_setif_beta\tabaro3_setif.sqlite`. The clinic's production database in `tabaro3_setif\` remains 100% untouched.
- **Easy Testing with Real Data**: To test Beta with real clinic records, export an `.xlsx` or `.zip` backup from Stable and import it into Beta.

---

## 2. Version Naming Strategy (Semantic Versioning)

Keep a single canonical base version in `pubspec.yaml`:

```yaml
version: 1.2.0+1
```

Follow **SemVer (`MAJOR.MINOR.PATCH`)**:
- **`MAJOR` (`2.0.0`)**: Major workflow overhaul or breaking change to backup/Excel formats.
- **`MINOR` (`1.1.0` → `1.2.0`)**: New feature, new screen, or new SQLite table/column migration.
- **`PATCH` (`1.2.0` → `1.2.1`)**: Bug fix, Arabic/French wording fix, PDF alignment fix, or performance tweak.

### How Version Strings Are Generated Automatically
- **On `beta` branch push**:
  - CI reads `1.2.0` from `pubspec.yaml` and appends `-beta.<github.run_number>` → **`v1.2.0-beta.14`**.
  - Installer file: `Tabaro3_Setif_Beta_Setup_v1.2.0-beta.14.exe`.
- **On `main` branch push (merged from `beta`)**:
  - CI reads `1.2.0` from `pubspec.yaml` → **`v1.2.0`**.
  - Installer file: `Tabaro3_Setif_Setup_v1.2.0.exe`.

---

## 3. Git Branching & Developer Workflow

```text
feature/xyz ──► beta (Auto-builds Beta Pre-release .exe) ──► main (Auto-builds Stable Release .exe)
```

1. **Daily Development**:
   - Work on `beta` (or short-lived `feat/...` / `fix/...` branches merged into `beta`).
   - Whenever you want a testable Windows `.exe`, bump `version:` in `pubspec.yaml` if needed and push to `beta`:
     ```bash
     git checkout beta
     git push origin beta
     ```
   - GitHub Actions automatically runs tests, compiles the Beta Windows installer, and publishes a **GitHub Pre-release**.
2. **Promoting Beta to Stable**:
   - Once the Beta installer has been verified on Windows:
     ```bash
     git checkout main
     git merge beta
     git push origin main
     ```
   - GitHub Actions automatically builds the Stable Windows installer, creates git tag `vX.Y.Z`, and publishes the **GitHub Latest Stable Release**.

---

## 4. How the Flutter Code Knows It Is `beta` vs `stable`

Use Dart's compile-time environment declarations (`--dart-define`) in `lib/core/resources/app_env.dart`:

```dart
class AppEnv {
  static const String channel = String.fromEnvironment('APP_ENV', defaultValue: 'stable');
  static const String version = String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0-dev');

  static bool get isBeta => channel == 'beta';

  /// Separate AppData subfolder so Beta never touches Stable SQLite DB or photos
  static String get appDataFolderName => isBeta ? 'tabaro3_setif_beta' : 'tabaro3_setif';

  /// Window title & header badge
  static String appTitle(String baseTitle) =>
      isBeta ? '$baseTitle [BETA $version]' : baseTitle;
}
```

### Visual Distinction in the UI
- **Window Title & Top Bar**: Displays an amber `BETA v1.2.0-beta.14` pill badge next to the app title when `AppEnv.isBeta` is `true`.
- **Settings Screen Footer**: Always displays the exact installed version and channel (e.g., `Version 1.2.0 (Stable)` or `Version 1.2.0-beta.14 (Beta)`) plus the local database path for easy support/debugging.

---

## 5. Parameterized Inno Setup Script (`installer/tabaro3_setif.iss`)

By passing `/DAppChannel` and `/DAppVersion` from GitHub Actions into `iscc`, a single `.iss` script builds both isolated installers:

```ini
#ifndef AppChannel
  #define AppChannel "stable"
#endif
#ifndef AppVersion
  #define AppVersion "1.0.0"
#endif

#if AppChannel == "beta"
  #define MyAppName "Tabaro3 Sétif (Beta)"
  #define MyAppId "{{9B4F2C81-6E1A-4D3B-9C12-BETA00CWTS19}"
  #define MyDirName "Tabaro3SetifBeta"
  #define MyInstallerBase "Tabaro3_Setif_Beta_Setup_v" + AppVersion
#else
  #define MyAppName "Tabaro3 Sétif"
  #define MyAppId "{{8A3E1B70-5D09-4C2A-8B01-STABLECWTS19}"
  #define MyDirName "Tabaro3Setif"
  #define MyInstallerBase "Tabaro3_Setif_Setup_v" + AppVersion
#endif

[Setup]
AppId={#MyAppId}
AppName={#MyAppName}
AppVersion={#AppVersion}
AppPublisher=CWTS Sétif
DefaultDirName={autopf}\{#MyDirName}
DefaultGroupName={#MyAppName}
PrivilegesRequired=lowest
OutputDir=..\build\installer
OutputBaseFilename={#MyInstallerBase}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\tabaro3_setif.exe"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\tabaro3_setif.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\tabaro3_setif.exe"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
```

---

## 6. Automated GitHub Actions Workflow (`.github/workflows/release.yml`)

```yaml
name: Build & Publish Windows Release (Beta & Stable)

on:
  push:
    branches:
      - beta
      - main
  workflow_dispatch:

permissions:
  contents: write

jobs:
  release-windows:
    runs-on: windows-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Determine Channel & Version from pubspec.yaml
        id: meta
        shell: pwsh
        run: |
          $line = Select-String -Path pubspec.yaml -Pattern '^version:\s*([0-9]+\.[0-9]+\.[0-9]+)'
          $baseVer = $line.Matches[0].Groups[1].Value
          if ("${{ github.ref_name }}" -eq "main") {
            $channel = "stable"
            $version = $baseVer
            $isPrerelease = "false"
          } else {
            $channel = "beta"
            $version = "$baseVer-beta.${{ github.run_number }}"
            $isPrerelease = "true"
          }
          "channel=$channel" >> $env:GITHUB_OUTPUT
          "version=$version" >> $env:GITHUB_OUTPUT
          "tag=v$version" >> $env:GITHUB_OUTPUT
          "prerelease=$isPrerelease" >> $env:GITHUB_OUTPUT

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          cache: true

      - name: Install dependencies & run tests
        run: |
          flutter pub get
          flutter analyze
          flutter test

      - name: Build Windows Native Release
        run: |
          flutter build windows --release `
            --dart-define=APP_ENV=${{ steps.meta.outputs.channel }} `
            --dart-define=APP_VERSION=${{ steps.meta.outputs.version }}

      - name: Bundle VC++ Runtime DLLs
        shell: pwsh
        run: |
          $sys32 = "$env:SystemRoot\System32"
          $dest = "build\windows\x64\runner\Release"
          Copy-Item "$sys32\vcruntime140.dll" $dest -Force
          Copy-Item "$sys32\vcruntime140_1.dll" $dest -Force
          Copy-Item "$sys32\msvcp140.dll" $dest -Force

      - name: Compile Inno Setup (.exe) Installer
        run: |
          iscc `
            "/DAppChannel=${{ steps.meta.outputs.channel }}" `
            "/DAppVersion=${{ steps.meta.outputs.version }}" `
            installer/tabaro3_setif.iss

      - name: Publish to GitHub Releases
        uses: softprops/action-gh-release@v2
        with:
          tag_name: ${{ steps.meta.outputs.tag }}
          name: "Tabaro3 Sétif ${{ steps.meta.outputs.tag }} (${{ steps.meta.outputs.channel }})"
          prerelease: ${{ steps.meta.outputs.prerelease }}
          generate_release_notes: true
          files: |
            build/installer/*.exe
```
