# Best Practices (`docs/BEST_PRACTICES.md`)

## 1. Local SQLite & Data Integrity (Drift)

1. **Always Store Mutable Files in `getApplicationSupportDirectory()`**:
   - On Windows, this resolves to `%APPDATA%\CWTS_Setif\tabaro3_setif\`.
   - Never write the database, photos, or temporary files next to the `.exe` binary (`C:\Program Files\...` is read-only for standard Windows users and gets wiped during app updates).
2. **Enable SQLite WAL Mode & Foreign Keys on Startup**:
   - Execute `PRAGMA foreign_keys = ON;` and `PRAGMA journal_mode = WAL;` inside Drift's `beforeOpen` callback so `ON DELETE CASCADE` on `donation_events` always works and concurrent reads never block writes.
3. **Use `VACUUM INTO` for Live Backups**:
   - Never copy a live `.sqlite` file with `File.copy()` while WAL mode is active (you might miss uncommitted `-wal` frames). Instead, run `await db.customStatement('VACUUM INTO ?', [tempBackupPath])` to produce a guaranteed-consistent single-file snapshot before zipping.
4. **Keep Donor Photos Out of SQLite Rows**:
   - When the user picks a donor photo, resize/compress it to max `600x600` JPEG and save it to `photos/<donor_id>.jpg`. Store only `<donor_id>.jpg` in `donors.photo_filename`. This keeps the SQLite database tiny (< 5 MB even with 20,000 donors) and makes queries instantaneous.
5. **Atomic Transactions for Donations**:
   - Wrapping `insert(donationEvents)` + `update(donors)` inside `db.transaction(() async { ... })` guarantees that a donor's `last_donation` and their `donation_events` history never drift out of sync.

---

## 2. Bilingual Arabic (`RTL`) & French (`LTR`) UI

1. **Instant Root Direction Switching**:
   - Drive `MaterialApp`'s `builder` with a `Directionality(textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr, ...)` wrapper bound to the current language setting so switching between `العربية` and `Français` flips the entire layout immediately without restarting the app.
2. **Directional Layout Primitives Only**:
   - Always use `EdgeInsetsDirectional.only(start: ..., end: ...)`, `AlignmentDirectional.centerStart`, and `TextAlign.start` instead of `left`/`right`.
3. **Force `LTR` on Blood Groups & Phone Numbers**:
   - In Arabic (`RTL`), the Unicode Bidirectional Algorithm moves trailing `+` or `-` signs to the left side of Latin characters, turning `O+` into `+O` and `AB-` into `-AB`.
   - Always wrap blood group strings and phone numbers in our shared `<LtrText>` widget (`Directionality(textDirection: TextDirection.ltr, child: Text(...))`).
4. **Bundle `Cairo` Fonts Offline**:
   - Bundle `Cairo-Regular.ttf`, `Cairo-SemiBold.ttf`, `Cairo-Bold.ttf`, and `Cairo-ExtraBold.ttf` in `assets/fonts/` and register them in `pubspec.yaml`. Never fetch fonts from Google Fonts over the internet at runtime.

---

## 3. Excel Import / Export Reliability

1. **Accept All Real-World Algerian Clinic Date Formats**:
   - Hospital spreadsheets often mix Excel native date cells, French strings (`23/10/2026`, `23-10-2026`, `23.10.2026`), and ISO strings (`2026-10-23`).
   - Parse all three cleanly into `YYYY-MM-DD` before touching the database, and validate that the resulting calendar date actually exists.
2. **Flexible Gender & Blood Group Normalization**:
   - Normalize gender values case-insensitively: `['f', 'femme', 'أنثى', 'انثى']` → `'F'`, everything else (`'m'`, `'h'`, `'homme'`, `'ذكر'`) → `'M'`.
   - Normalize blood groups by stripping spaces and uppercasing (`' o + '` → `'O+'`), validating against the 8 valid groups.
3. **Graceful Handling of Locked `.xlsx` Files on Windows**:
   - Microsoft Excel places an exclusive OS file lock on any `.xlsx` file currently open on the user's desktop.
   - Wrap file reads/writes in `try / catch (FileSystemException)` and display a clear message (*"Please close the Excel file in Microsoft Excel and try again"*) instead of crashing.
4. **Smart-Merge Summary Feedback**:
   - After importing an Excel file, show a clear toast/dialog with counts: **`X new donors added, Y existing donors updated, Z invalid rows skipped`**.

---

## 4. Printable Donor Card (`pdf` + `printing`)

1. **Embed Both Arabic-Capable TTF Fonts in the PDF Document**:
   - Load `assets/fonts/Cairo-Regular.ttf` and `assets/fonts/Cairo-Bold.ttf` via `rootBundle.load()` and pass them to `pw.ThemeData.withFont(base: cairoRegular, bold: cairoBold)`.
2. **Set `pw.Directionality` on PDF Pages**:
   - Wrap the `pw.Page` content in `pw.Directionality(textDirection: lang == 'ar' ? pw.TextDirection.rtl : pw.TextDirection.ltr, ...)` so table columns and Arabic text align properly when printed.
3. **Use `Printing.layoutPdf()`**:
   - Opens the native OS print dialog on both Windows and macOS, allowing staff either to print directly to an attached laser/inkjet printer or save as a PDF file.

---

## 5. Windows Desktop UX & Packaging

1. **Enforce a Sensible Minimum Window Size**:
   - Set `windowManager.setMinimumSize(const Size(1024, 680))` on startup so the 8-column donors table and 2-column form never crush into unreadable widths.
2. **Keyboard Navigation & Shortcuts**:
   - Support `Enter` to submit the Login form and Donor form, `Escape` to cancel/close dialogs, and auto-focus the search bar on the Donors screen.
3. **Automatic Pre-Destructive Backup**:
   - Before executing **"Reset All Data"** (`مسح جميع البيانات`) or **"Restore from Backup"**, automatically create `backups/pre_reset_YYYYMMDD_HHMMSS.zip` and prune backups older than the last 10 snapshots.
