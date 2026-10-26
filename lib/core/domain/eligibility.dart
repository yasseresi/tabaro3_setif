/// Pure eligibility math per CWTS Sétif rules:
/// 3 calendar months for men (M), 4 for women (F), computed from
/// max(lastDonation, lastTest), with end-of-month clamping.
const Map<String, int> cooldownMonths = {'M': 3, 'F': 4};

/// Adds [monthsToAdd] calendar months, clamping the day when the target
/// month is shorter (e.g. 2026-11-30 + 3m -> 2027-02-28).
DateTime addMonthsClamped(DateTime date, int monthsToAdd) {
  final targetYear = date.year + ((date.month - 1 + monthsToAdd) ~/ 12);
  final targetMonth = ((date.month - 1 + monthsToAdd) % 12) + 1;
  final lastDayOfTargetMonth = DateTime(targetYear, targetMonth + 1, 0).day;
  final clampedDay = date.day <= lastDayOfTargetMonth
      ? date.day
      : lastDayOfTargetMonth;
  return DateTime(targetYear, targetMonth, clampedDay);
}

/// The most recent of lastDonation / lastTest (null if both empty).
DateTime? referenceDate(String lastDonation, String lastTest) {
  final d1 = _parseOrNull(lastDonation);
  final d2 = _parseOrNull(lastTest);
  if (d1 == null) return d2;
  if (d2 == null) return d1;
  return d1.isAfter(d2) ? d1 : d2;
}

DateTime? _parseOrNull(String iso) {
  if (iso.isEmpty) return null;
  return DateTime.tryParse(iso);
}

/// Next eligible date = referenceDate + gender cooldown, or null without dates.
DateTime? nextEligibleDate({
  required String gender,
  required String lastDonation,
  required String lastTest,
}) {
  final ref = referenceDate(lastDonation, lastTest);
  if (ref == null) return null;
  return addMonthsClamped(ref, cooldownMonths[gender] ?? 3);
}

/// Eligibility status keys: 'due' | 'soon' | 'wait' | 'none'.
String eligibilityStatus({
  required String gender,
  required String lastDonation,
  required String lastTest,
  DateTime? now,
}) {
  final next = nextEligibleDate(
    gender: gender,
    lastDonation: lastDonation,
    lastTest: lastTest,
  );
  if (next == null) return 'none';
  final today = now ?? DateTime.now();
  final todayDay = DateTime(today.year, today.month, today.day);
  final daysUntil = DateTime(
    next.year,
    next.month,
    next.day,
  ).difference(todayDay).inDays;
  if (daysUntil <= 0) return 'due';
  if (daysUntil <= 7) return 'soon';
  return 'wait';
}

/// Statuses to show on the Alerts screen, sorted most-overdue first.
bool isAlertStatus(String status) => status == 'due' || status == 'soon';

/// ISO date (YYYY-MM-DD) helpers used across DB, Excel and PDF layers.
String isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Display format DD/MM/YYYY ('' when empty).
String displayDate(String iso) {
  final parsed = _parseOrNull(iso);
  if (parsed == null) return '';
  return '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year}';
}

/// Parses flexible clinic dates into ISO YYYY-MM-DD ('' when invalid).
/// Accepts Excel serials (int/double), DD/MM/YYYY, DD-MM-YYYY, DD.MM.YYYY,
/// YYYY-MM-DD and already-parsed DateTime values.
String normalizeDate(dynamic value) {
  if (value == null) return '';
  if (value is DateTime) return isoDate(value);
  if (value is num) return _fromExcelSerial(value);
  final s = value.toString().trim();
  if (s.isEmpty) return '';
  // ISO
  final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})').firstMatch(s);
  if (iso != null) {
    return _valid(
      int.parse(iso.group(1)!),
      int.parse(iso.group(2)!),
      int.parse(iso.group(3)!),
    );
  }
  // French DD/MM/YYYY, DD-MM-YYYY, DD.MM.YYYY
  final fr = RegExp(r'^(\d{1,2})[/\-.](\d{1,2})[/\-.](\d{4})').firstMatch(s);
  if (fr != null) {
    return _valid(
      int.parse(fr.group(3)!),
      int.parse(fr.group(2)!),
      int.parse(fr.group(1)!),
    );
  }
  // Pure Excel serial number as string
  final serial = num.tryParse(s);
  if (serial != null && serial >= 1 && serial < 100000) {
    return _fromExcelSerial(serial);
  }
  return '';
}

String _fromExcelSerial(num serial) {
  // Excel day 1 = 1900-01-01, with the famous 1900 leap-year bug offset.
  final days = (serial.toDouble()).floor() - 25569;
  final date = DateTime.utc(1970, 1, 1).add(Duration(days: days));
  return _valid(date.year, date.month, date.day);
}

String _valid(int y, int m, int d) {
  if (m < 1 || m > 12 || d < 1 || d > 31) return '';
  final date = DateTime(y, m, d);
  if (date.year != y || date.month != m || date.day != d) return '';
  return isoDate(date);
}

/// Robust max of two ISO date strings ('' = empty).
String maxIsoDate(String a, String b) {
  if (a.isEmpty) return b;
  if (b.isEmpty) return a;
  return a.compareTo(b) >= 0 ? a : b;
}

/// Gender normalization: 'F'/'femme'/'أنثى' -> F, everything male-ish -> M.
String normalizeGender(dynamic value) {
  final s = value.toString().trim().toLowerCase();
  if (s.isEmpty) {
    return 'M';
  }
  if (s == 'f' || s == 'femme' || s == 'أنثى' || s == 'انثى' || s == 'female') {
    return 'F';
  }
  return 'M';
}

const List<String> bloodGroups = [
  'A+',
  'A-',
  'B+',
  'B-',
  'AB+',
  'AB-',
  'O+',
  'O-',
];

/// Blood group normalization: strip spaces, uppercase, validate.
String? normalizeBloodGroup(dynamic value) {
  final s = value.toString().replaceAll(' ', '').toUpperCase();
  return bloodGroups.contains(s) ? s : null;
}

/// Splits a blood group into ABO letter + Rhésus sign for the CSW fiche.
({String abo, String rhesus}) splitBloodGroup(String bloodGroup) => (
  abo: bloodGroup.substring(0, bloodGroup.length - 1),
  rhesus: bloodGroup.substring(bloodGroup.length - 1),
);

/// Phone normalization for smart-merge matching: digits only.
String normalizePhone(dynamic value) =>
    value.toString().replaceAll(RegExp(r'[\s\-.()]'), '').trim();

/// Name normalization for smart-merge matching: trimmed, collapsed whitespace.
String normalizeName(String value) =>
    value.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
