# What to Avoid — Anti-Patterns & Common Pitfalls (`docs/WHAT_TO_AVOID.md`)

Read this list before implementing features. Every item below represents a real bug found either in the web prototype or in typical Flutter Windows desktop deployments.

---

## 1. Prototype Bugs You Must NOT Copy

1. **DO NOT Blindly Append Rows on Excel Import**:
   - *Prototype bug*: The prototype generates a new `UUID` for every row in an imported Excel file and prepends it to the list. Re-importing an exported Excel file duplicates every single donor in the database.
   - *Do instead*: Always run **Smart-Merge** (match by normalized phone number, or exact normalized `name + blood_group` when phone is blank; update latest dates and merge non-empty fields).
2. **DO NOT Omit `birthDate` (`تاريخ الميلاد`) from the Donor Form**:
   - *Prototype bug*: `birthDate` exists in the Excel import/export columns (`col[5]`), but the prototype forgot to include a `birthDate` input field in the Add/Edit Donor UI form.
   - *Do instead*: Include `birthDate` on the Add/Edit Donor screen and on the printed Donor Card.
3. **DO NOT Overwrite `lastDonation` Without Recording History**:
   - *Prototype bug*: Clicking "Mark Donated Today" (`تسجيل تبرع اليوم`) simply overwrote `lastDonation` on the donor object, destroying all history of previous donations.
   - *Do instead*: Insert a row into `donation_events` and update `donors.last_donation` + `donors.donation_count` inside a single SQLite transaction.
4. **DO NOT Use `tel:` Links for the "Call" Button on Desktop**:
   - *Prototype bug*: Uses `<a href="tel:...">`, which on Windows desktop PCs either does nothing or launches an unconfigured Skype/Teams window.
   - *Do instead*: Copy the phone number to the Windows clipboard and display a clean modal/toast with the donor's name and large-print phone number so reception staff can dial it easily.
5. **DO NOT Allow Single-Click Unprotected Database Wipe**:
   - *Prototype bug*: "Reset All Data" wipes the entire database after a single browser `confirm()`.
   - *Do instead*: Require entering the admin password AND automatically create a `.zip` backup in `backups/` before deleting rows.

---

## 2. Flutter Windows & SQLite Pitfalls to Avoid

1. **NEVER Store the SQLite Database or Photos in `Directory.current` or Next to the `.exe`**:
   - On Windows, when launched from a Desktop shortcut or installed in `Program Files`, `Directory.current` may be `C:\Windows\System32` or a read-only folder.
   - Always resolve paths via `getApplicationSupportDirectory()` (`%APPDATA%`).
2. **NEVER Store Donor Photos as Base64 Strings in SQLite or Excel**:
   - *Prototype bug*: Uses `FileReader.readAsDataURL()` and saves full-resolution Base64 strings inside JSON storage. With 500 donor photos, the database balloons to hundreds of megabytes and freezes the UI.
   - *Do instead*: Save resized JPEG files in `%APPDATA%\...\photos\<id>.jpg` and bundle them in the `.zip` backup for PC-to-PC migration.
3. **NEVER Use `google_fonts` HTTP Fetching**:
   - Clinic PCs at CWTS Sétif frequently operate offline or behind restricted local networks. Runtime font fetching will fail or crash startup. Bundle `Cairo-*.ttf` in `assets/fonts/`.
4. **NEVER Ship a Windows Build Without Bundling VC++ Runtime DLLs**:
   - Flutter Windows release binaries depend on `vcruntime140.dll`, `vcruntime140_1.dll`, and `msvcp140.dll`. Fresh Windows 10/11 machines without Visual C++ Redistributable installed will fail to launch with a system error popup.
   - Always copy those 3 DLLs into the release folder in GitHub Actions before running Inno Setup (`iscc`).
5. **NEVER Package as Unsigned `.msix` for End Users**:
   - Windows SmartScreen and AppInstaller block unsigned/self-signed `.msix` files unless the hospital IT manually imports a root certificate via Administrator PowerShell.
   - Always distribute an **Inno Setup `.exe` installer** (`PrivilegesRequired=lowest`) via GitHub Releases.

---

## 3. Arabic RTL, Date Math & PDF Pitfalls to Avoid

1. **NEVER Render Blood Groups (`A+`, `O-`) Without `Directionality.ltr`**:
   - In Arabic (`RTL`) mode, `+` and `-` are neutral bidirectional characters and will jump to the wrong side (`+A`, `-O`). Always wrap blood groups and phone numbers in `Directionality(textDirection: TextDirection.ltr, ...)`.
2. **NEVER Use Default Helvetica Font in the `pdf` Package**:
   - The `pdf` package's built-in Helvetica font only supports Latin-1 characters; Arabic text (`المركز الولائي لحقن الدم سطيف`) will render as `[][][][]` boxes or crash. Always pass the embedded `Cairo` TTF font and set `pw.TextDirection.rtl` on Arabic text blocks.
3. **NEVER Add `90` or `120` Days Instead of `3` or `4` Calendar Months**:
   - Medical blood donation eligibility in Algeria is defined in **calendar months** (3 months for men, 4 months for women) with end-of-month clamping (e.g., Jan 15 -> Apr 15 for men, May 15 for women), matching the prototype's `qb()` function.
4. **NEVER Over-Engineer with Enterprise Boilerplate**:
   - Avoid adding `get_it`, `injectable`, `dartz`, `freezed`, `rxdart`, `retrofit`, `dio`, or 3-layer mapper classes. Keep the codebase small, readable, and fast to modify.
