# UI & Domain Specification (Extracted from Prototype)

> Source Prototype: `https://prototypeyasser.lovable.app`  
> Title: **برنامج إدارة المتبرعين بالدم – المركز الولائي لحقن الدم سطيف** / **Gestion des donneurs de sang – CWTS Sétif**

---

## 1. Visual Identity & Design Tokens

### Typography
- **Font Family**: `Cairo` (weights: `400` Regular, `600` SemiBold, `700` Bold, `800` ExtraBold), bundled offline in `assets/fonts/Cairo-*.ttf`.
- **Default Language & Direction**: Arabic (`ar`, `RTL`) by default; instant toggle to French (`fr`, `LTR`).
- **Directional Exceptions**: Blood group badges (`A+`, `O-`, `AB+`) and phone numbers (`0551234567`) **always** force `LTR` direction so the `+`/`-` signs stay on the right of the blood type letter even in Arabic RTL mode.

### Color Palette (Light Mode — Clinic Default)
| Token | Role | OKLCH (Prototype) | Hex Equivalent |
| :--- | :--- | :--- | :--- |
| `background` | App canvas background | `oklch(97% 0.01 250)` | `#F4F6FB` |
| `card` / `panel` | Surface / panel background | `oklch(100% 0 0)` | `#FFFFFF` |
| `primary` | Institutional Navy Blue | `oklch(45% 0.13 255)` | `#2557A7` |
| `primaryForeground` | Text on primary | `oklch(100% 0 0)` | `#FFFFFF` |
| `blood` | Medical Crimson Red | `oklch(55% 0.21 25)` | `#D92638` |
| `bloodSoft` | Soft red tint background | `oklch(95% 0.03 25)` | `#FDECEE` |
| `success` | Eligible / Save New | `oklch(60% 0.15 150)` | `#1F9D55` |
| `warning` | Eligible soon (`<= 7 days`) | `oklch(75% 0.15 70)` | `#D9822B` |
| `destructive` | Delete / Reset danger | `oklch(58% 0.20 25)` | `#DC2626` |
| `sidebarBgTop` | Sidebar gradient top | `oklch(36% 0.11 257)` | `#1D3B73` |
| `sidebarBgBottom` | Sidebar gradient bottom | `oklch(27% 0.09 260)` | `#12264E` |
| `sidebarActive` | Active nav item fill | `oklch(55% 0.15 252)` | `#2E6FD8` |
| `headerGradient` | Institutional top banner | `120deg: #F4F7FC -> #E4ECF7` | `#F4F7FC` → `#E4ECF7` |
| `border` / `muted` | Borders & subtle fills | `oklch(92% 0.01 250)` | `#E2E8F0` / `#F1F5F9` |

### Custom Brand Marks (Vector SVGs)
1. **Algerian Flag Circular Emblem (`cx`)**:
   - Circular `100x100` viewBox with white ring border and shadow:
   - Left half `#006233` (green), right half `#FFFFFF` (white), red crescent (`#D21034`) + 5-point star in center.
2. **Blood Drop with Heart Logo (`lx`)**:
   - Crimson blood drop icon (`#D92638`) with a white heart centered in the lower half.

---

## 2. Core Domain Rules & Eligibility Math

### Blood Groups (`Gb`)
8 canonical values:
`['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']`

### Cooldown Interval by Gender (`Kb`)
- **Male (`M`)**: **3 calendar months** after reference date.
- **Female (`F`)**: **4 calendar months** after reference date.

### Reference Date Calculation (`Jb`)
For any donor, the reference date is the **more recent** of `lastDonation` and `lastTest`:
```
referenceDate = max(lastDonation, lastTest) // null if both are empty
```

### Next Eligible Date Calculation (`qb` / `Yb`)
Given `referenceDate` (`YYYY-MM-DD`) and `months` (`3` or `4`):
1. Add `months` to the month component of `referenceDate`.
2. **End-of-month clamping**: If the day overflows the target month (e.g., `2026-11-30` + 3 months would overflow February), clamp to the **last day of the target month** (`2027-02-28`).
```dart
DateTime addMonthsClamped(DateTime date, int monthsToAdd) {
  final targetYear = date.year + ((date.month - 1 + monthsToAdd) ~/ 12);
  final targetMonth = ((date.month - 1 + monthsToAdd) % 12) + 1;
  final lastDayOfTargetMonth = DateTime(targetYear, targetMonth + 1, 0).day;
  final clampedDay = date.day <= lastDayOfTargetMonth ? date.day : lastDayOfTargetMonth;
  return DateTime(targetYear, targetMonth, clampedDay);
}
```

### Eligibility Status (`Xb`)
Let `today = DateTime(now.year, now.month, now.day)` and `daysUntil = nextEligible.difference(today).inDays`:
- **`none`** (`بدون تاريخ` / `Sans date`): `nextEligible == null`
- **`due`** (`مؤهل للتبرع` / `Éligible`): `daysUntil <= 0` (Green badge)
- **`soon`** (`قريباً` / `Bientôt`): `1 <= daysUntil <= 7` (Amber badge)
- **`wait`** (`في الانتظار` / `En attente`): `daysUntil > 7` (Muted grey badge)

---

## 3. Screen-by-Screen Specification

### Global App Shell (Authenticated)
- **Institutional Header Banner**:
  - Left/Start: Algerian Flag circular emblem (`68px`).
  - Center:
    - Line 1: `الجمهورية الجزائرية الديمقراطية الشعبية` / `République Algérienne Démocratique et Populaire`
    - Line 2: `وزارة الصحة` / `Ministère de la Santé`
    - Line 3 (ExtraBold): `المركز الولائي لحقن الدم سطيف` / `Centre de Wilaya de Transfusion Sanguine – Sétif`
  - Right/End: Slogan (`التبرع بالدم حياة...` / `Donner son sang, c'est donner la vie...`) + Blood drop heart emblem (`64px`).
- **Sidebar (`240px` wide, deep navy gradient)**:
  1. `dashboard` — لوحة التحكم / Tableau de bord
  2. `donors` — قائمة المتبرعين / Liste des donneurs
  3. `form` — إضافة متبرع / Ajouter un donneur
  4. `alerts` — التنبيهات / Rappels *(shows red pill badge with count of `due` donors)*
  5. `data` — استيراد / تصدير / Import / Export
  6. `settings` — الإعدادات / Paramètres
  - Divider + `logout` — خروج / Déconnexion
  - Bottom footer: Blood drop logo (`80px`) + `معاً من أجل إنقاذ الأرواح` / `Ensemble pour sauver des vies`.

---

### Screen 0: Login (`mx`)
- Centered card (`400px` wide) over radial navy gradient background.
- Blood drop logo (`72px`), Center title, Slogan.
- Fields: `username`, `password` (obscured).
- Error message on bad credentials (`badLogin`), hint (`الافتراضي: admin / admin` — hidden once admin changes default password).
- Primary `Login` button + `Français / العربية` language toggle button.

---

### Screen 1: Dashboard (`yx`)
1. **Top KPI Cards (3-column grid, clickable)**:
   - **Total Donors (`total`)** → navigates to `donors` list.
   - **Eligible Now (`eligibleNow`, count of `due`)** → navigates to `alerts`.
   - **Eligible This Week (`thisWeek`, count of `soon`)** → navigates to `alerts`.
2. **Rule Banner**: Soft red banner explaining the 3-month (men) / 4-month (women) rule.
3. **2-Column Bottom Section**:
   - **Blood Group Distribution Bar Chart (`byGroup`)**: Vertical bars for `A+, A-, B+, B-, AB+, AB-, O+, O-` with count label on top and `LTR` group label at bottom.
   - **Recent Donors Added (`recent`)**: Last 5 added donors (blood group circle, name, status badge; clicking opens edit form; "View All" button goes to `donors`).

---

### Screen 2: Donors List (`bx`)
- **Filter Bar**:
  - Search input (`search`: matches `name` case-insensitively or `phone` substring).
  - Blood Group dropdown (`All` or one of the 8 blood groups).
  - Status dropdown (`All`, `due`, `soon`, `wait`, `none`).
- **Table Columns**:
  1. `name` (Bold)
  2. `gender` (`ذكر`/`أنثى` or `Homme`/`Femme`)
  3. `bloodGroup` (Bold red, `LTR`)
  4. `phone` (`LTR`)
  5. `lastDonation` (`DD/MM/YYYY` or `—`)
  6. `nextEligible` (`DD/MM/YYYY` or `—`)
  7. `status` (Colored pill badge)
  8. `actions`: **Edit** (pencil), **Print Donor Card** (printer), **Delete** (trash, with confirmation dialog).
- **Footer**: Total matching records count + pagination controls (`10` rows per page).

---

### Screen 3: Add / Edit Donor Form (`Cx`)
- **2-Column Layout** (`[1fr, 220px]`):
  - **Main Form Column**:
    - `name` (Text input, **required**)
    - `gender` (2 toggle buttons: `M (3 months)` / `F (4 months)`)
    - `bloodGroup` (8 toggle buttons in a row, `LTR`, **required**)
    - `phone` (Text input, `LTR`, digits/+ and spaces, max 15 chars)
    - `birthDate` (Date picker `DD/MM/YYYY` — *added to complete the Excel schema*)
    - `address` (2-row textarea)
    - 2-column date row: `lastDonation` (Date picker) & `lastTest` (Date picker)
    - `notes` (2-row textarea)
  - **Side Column (`220px`)**:
    - Photo preview box (`224px` tall rounded box; shows donor photo or placeholder user icon) + `Add Photo` button (picks image & copies resized JPEG into `photos/`).
    - Live Eligibility Preview card (`bg-blood-soft`): shows calculated `nextEligible` date in large crimson font + live `StatusBadge`.
    - Donation History summary (when editing an existing donor: shows total donations count & collapsible list of past `donation_events`).
- **Bottom Action Bar**:
  - `Save` (Primary blue)
  - `New` (Green — clears form to add another donor)
  - `Cancel` (Grey — returns to Donors list)
  - `Print` (Outlined primary — opens PDF print preview for this donor; enabled once saved)

---

### Screen 4: Alerts / Reminders (`wx`)
- Filters all donors whose status is `due` or `soon`, sorted ascending by `nextEligible` date (most overdue first).
- Header right action: Desktop Notifications status / toggle.
- Each row shows:
  - Circular blood group badge (`LTR`)
  - Donor name (clickable to edit)
  - Subtitle: `Gender · Last Donation/Test: DD/MM/YYYY · Next Eligible: DD/MM/YYYY`
  - Status pill badge (`due` or `soon`)
  - **Call (`اتصال` / `Appeler`)**: Copies phone number to clipboard and opens a clear call card displaying the donor's name and large-print phone number.
  - **Mark Donated Today (`تسجيل تبرع اليوم` / `Don enregistré aujourd'hui`)**: Inserts a `donation` event for today into `donation_events` and sets `lastDonation = today` in one click.

---

### Screen 5: Import / Export & Backup (`Dx`)
- **Left Panel — Import from Excel**:
  - Drag-and-drop / file picker zone for `.xlsx` and `.csv`.
  - Smart-merge upsert logic (updates existing donors matched by phone or name+bloodGroup, inserts new ones, and reports `X added, Y updated`).
  - `Download Empty Template` (`modele_donneurs.xlsx`) button.
- **Right Panel — Export to Excel**:
  - Displays total donor count in large typography.
  - `Export to Excel` (`donneurs_YYYY-MM-DD.xlsx`) button with 2 sheets (`Donneurs` + `Historique`).
- **Bottom Panel — Full PC-to-PC System Backup (`.zip`)**:
  - `Export Full Backup (.zip)` (SQLite DB + donor photos) and `Restore from Backup (.zip)`.

---

### Screen 6: Settings (`Ox`)
- **Account Panel**: Change admin `username` and `newPass` (minimum 4 chars).
- **Language & Data Panel**:
  - Language toggle buttons (`العربية` / `Français`).
  - `Reset All Data` (`مسح جميع البيانات` / `Effacer toutes les données`): Protected by admin password prompt + automatic pre-wipe `.zip` backup in `backups/`.

---

### Screen 7: Printable Donor Card PDF (`kx`)
- Generated via `pdf` + `printing` with embedded `Cairo` Regular & Bold fonts:
  - Top institutional header (Algerian emblem, Republic, Ministry of Health, CWTS Sétif, Blood drop logo).
  - Title: `بطاقة متبرع` / `Fiche donneur`.
  - Bordered details table (`name`, `gender`, `bloodGroup`, `phone`, `birthDate`, `address`, `lastDonation`, `lastTest`, `nextEligible`, `notes`) + donor photo if available.

---

## 4. Complete Bilingual Dictionary (`ar` / `fr`)

| Key | Arabic (`ar` — RTL) | French (`fr` — LTR) |
| :--- | :--- | :--- |
| `appName` | برنامج إدارة المتبرعين بالدم | Gestion des donneurs de sang |
| `republic` | الجمهورية الجزائرية الديمقراطية الشعبية | République Algérienne Démocratique et Populaire |
| `ministry` | وزارة الصحة | Ministère de la Santé |
| `center` | المركز الولائي لحقن الدم سطيف | Centre de Wilaya de Transfusion Sanguine – Sétif |
| `slogan` | التبرع بالدم حياة... | Donner son sang, c'est donner la vie... |
| `together` | معاً من أجل إنقاذ الأرواح | Ensemble pour sauver des vies |
| `username` | اسم المستخدم | Nom d'utilisateur |
| `password` | كلمة المرور | Mot de passe |
| `login` | دخول | Se connecter |
| `badLogin` | اسم المستخدم أو كلمة المرور غير صحيحة | Identifiants incorrects |
| `defaultHint` | الافتراضي: admin / admin | Par défaut : admin / admin |
| `dashboard` | لوحة التحكم | Tableau de bord |
| `donors` | قائمة المتبرعين | Liste des donneurs |
| `addDonor` | إضافة متبرع | Ajouter un donneur |
| `editDonor` | تعديل متبرع | Modifier le donneur |
| `alerts` | التنبيهات | Rappels |
| `data` | استيراد / تصدير | Import / Export |
| `settings` | الإعدادات | Paramètres |
| `logout` | خروج | Déconnexion |
| `donorInfo` | معلومات المتبرع | Informations du donneur |
| `name` | الاسم و اللقب | Nom et prénom |
| `gender` | الجنس | Sexe |
| `male` | ذكر | Homme |
| `female` | أنثى | Femme |
| `bloodGroup` | زمرة الدم | Groupe sanguin |
| `chooseGroup` | اختر زمرة الدم | Choisir le groupe |
| `phone` | رقم الهاتف | Téléphone |
| `address` | العنوان | Adresse |
| `birthDate` | تاريخ الميلاد | Date de naissance |
| `lastDonation` | آخر تبرع | Dernier don |
| `lastTest` | آخر تحليل دم | Dernière analyse |
| `notes` | ملاحظة | Remarque |
| `photo` | إضافة صورة | Ajouter une photo |
| `save` | حفظ | Enregistrer |
| `cancel` | إلغاء | Annuler |
| `newBtn` | جديد | Nouveau |
| `print` | طباعة | Imprimer |
| `delete` | حذف | Supprimer |
| `edit` | تعديل | Modifier |
| `search` | ابحث بالاسم أو الهاتف... | Rechercher par nom ou téléphone... |
| `all` | الكل | Tous |
| `nextEligible` | الأهلية القادمة | Prochaine éligibilité |
| `status` | الحالة | Statut |
| `st_due` | مؤهل للتبرع | Éligible |
| `st_soon` | قريباً | Bientôt |
| `st_wait` | في الانتظار | En attente |
| `st_none` | بدون تاريخ | Sans date |
| `actions` | إجراءات | Actions |
| `noData` | لا توجد بيانات للعرض | Aucune donnée à afficher |
| `records` | عدد السجلات | Nombre d'enregistrements |
| `total` | إجمالي المتبرعين | Total donneurs |
| `eligibleNow` | مؤهلون الآن | Éligibles maintenant |
| `thisWeek` | مؤهلون هذا الأسبوع | Éligibles cette semaine |
| `byGroup` | التوزيع حسب زمرة الدم | Répartition par groupe |
| `rule` | القاعدة: 3 أشهر للرجال و 4 أشهر للنساء بعد آخر تبرع أو تحليل | Règle : 3 mois (hommes) / 4 mois (femmes) après le dernier don ou analyse |
| `alertsTitle` | متبرعون يمكن الاتصال بهم | Donneurs à recontacter |
| `noAlerts` | لا توجد تنبيهات حالياً | Aucun rappel pour le moment |
| `markDonated` | تسجيل تبرع اليوم | Don enregistré aujourd'hui |
| `call` | اتصال | Appeler |
| `since` | منذ | depuis |
| `months` | أشهر | mois |
| `enableNotif` | تفعيل إشعارات سطح المكتب | Activer les notifications |
| `notifOn` | الإشعارات مفعلة | Notifications activées |
| `notifTitle` | متبرع مؤهل للتبرع | Donneur éligible |
| `notifBody` | أصبح مؤهلاً للتبرع من جديد | est de nouveau éligible au don |
| `exportX` | تصدير إلى Excel | Exporter vers Excel |
| `importX` | استيراد من Excel | Importer depuis Excel |
| `template` | تحميل نموذج فارغ | Télécharger un modèle |
| `importHelp` | يجب أن يحتوي الملف على أعمدة: الاسم، الجنس، زمرة الدم، الهاتف، العنوان، تاريخ الميلاد، آخر تبرع، آخر تحليل، ملاحظة | Le fichier doit contenir : Nom, Sexe, Groupe, Téléphone, Adresse, Date naissance, Dernier don, Dernière analyse, Remarque |
| `imported` | تم استيراد | Importés : |
| `exportHelp` | تصدير جميع المتبرعين مع تاريخ الأهلية القادمة | Exporter tous les donneurs avec la date d'éligibilité |
| `saved` | تم الحفظ بنجاح | Enregistré avec succès |
| `deleted` | تم الحذف | Supprimé |
| `confirmDel` | هل تريد حذف هذا المتبرع؟ | Supprimer ce donneur ? |
| `required` | الاسم وزمرة الدم مطلوبان | Nom et groupe sanguin requis |
| `account` | الحساب | Compte |
| `newPass` | كلمة مرور جديدة | Nouveau mot de passe |
| `language` | اللغة | Langue |
| `resetData` | مسح جميع البيانات | Effacer toutes les données |
| `confirmReset` | سيتم حذف جميع المتبرعين. متأكد؟ | Tous les donneurs seront supprimés. Confirmer ? |
| `welcome` | مرحباً | Bienvenue |
| `recent` | آخر المتبرعين المضافين | Derniers donneurs ajoutés |
| `viewAll` | عرض الكل | Voir tout |
| `card` | بطاقة متبرع | Fiche donneur |

### Excel Column Headers (`Tx` — Exact Order)
1. `Nom / الاسم`
2. `Sexe / الجنس` (`H` or `M` for Male, `F` for Female; importer also accepts `femme`, `أنثى`, `انثى`, `ذكر`, `homme`)
3. `Groupe / الزمرة` (`A+`, `A-`, `B+`, `B-`, `AB+`, `AB-`, `O+`, `O-`)
4. `Téléphone / الهاتف`
5. `Adresse / العنوان`
6. `Date naissance / الميلاد` (`DD/MM/YYYY` or `YYYY-MM-DD` or Excel date serial)
7. `Dernier don / آخر تبرع` (`DD/MM/YYYY` or `YYYY-MM-DD` or Excel date serial)
8. `Dernière analyse / آخر تحليل` (`DD/MM/YYYY` or `YYYY-MM-DD` or Excel date serial)
9. `Remarque / ملاحظة`
10. `Prochaine éligibilité / الأهلية القادمة` *(computed on export; ignored on import)*
