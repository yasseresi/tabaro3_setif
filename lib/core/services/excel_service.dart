import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel_plus/excel_plus.dart' as xl;
import 'package:file_picker/file_picker.dart';

import '../../data/app_database.dart';
import '../domain/eligibility.dart';

/// 2-sheet Excel export + template + Smart-Merge import (.xlsx / .csv).
class ExcelService {
  /// Exact clinic column order (spec `Tx`), extended with the CSW fiche
  /// identity fields so no data is lost in a round-trip.
  static const List<String> headers = [
    'Nom / الاسم',
    'Nom jeune fille / اسم الزواج',
    'Sexe / الجنس',
    'Groupe / الزمرة',
    'Téléphone / الهاتف',
    'Adresse / العنوان',
    'E-mail / البريد',
    'Adresse pro. / العنوان المهني',
    'Téléphone pro. / الهاتف المهني',
    'E-mail pro. / البريد المهني',
    'Phénotype / النمط الظاهري',
    'Date naissance / الميلاد',
    'Dernier don / آخر تبرع',
    'Dernière analyse / آخر تحليل',
    'Remarque / ملاحظة',
    'Prochaine éligibilité / الأهلية القادمة',
  ];

  static const String historySheet = 'Historique';
  static const String donorsSheet = 'Donneurs';

  /// Builds the 2-sheet workbook bytes: Donneurs + Historique.
  Future<List<int>> exportWorkbook(List<Donor> donors) async {
    final excel = xl.Excel.createExcel();
    excel.rename('Sheet1', donorsSheet);
    final sheet = excel[donorsSheet];

    sheet.appendRow(headers.map((h) => xl.TextCellValue(h)).toList());
    for (final d in donors) {
      final next = nextEligibleDate(
        gender: d.gender,
        lastDonation: d.lastDonation,
        lastTest: d.lastTest,
      );
      sheet.appendRow([
        xl.TextCellValue(d.name),
        xl.TextCellValue(d.maidenName),
        xl.TextCellValue(d.gender),
        xl.TextCellValue(d.bloodGroup),
        xl.TextCellValue(d.phone),
        xl.TextCellValue(d.address),
        xl.TextCellValue(d.email),
        xl.TextCellValue(d.workAddress),
        xl.TextCellValue(d.workPhone),
        xl.TextCellValue(d.workEmail),
        xl.TextCellValue(d.phenotype),
        xl.TextCellValue(displayDate(d.birthDate)),
        xl.TextCellValue(displayDate(d.lastDonation)),
        xl.TextCellValue(displayDate(d.lastTest)),
        xl.TextCellValue(d.notes),
        xl.TextCellValue(next == null ? '' : displayDate(isoDate(next))),
      ]);
    }

    // Sheet 2: Historique
    final hist = excel[historySheet];
    hist.appendRow(
      [
        'Nom / الاسم',
        'Téléphone / الهاتف',
        'Type / النوع',
        'Date / التاريخ',
        'TA',
        'Poids / الوزن',
        'Type de don / نوع التبرع',
        'Bilan / التحليل',
        'Observations / ملاحظات',
      ].map((h) => xl.TextCellValue(h)).toList(),
    );
    for (final d in donors) {
      final events = await _eventsOf(d.id);
      for (final e in events) {
        hist.appendRow([
          xl.TextCellValue(d.name),
          xl.TextCellValue(d.phone),
          xl.TextCellValue(e.eventType == 'donation' ? 'don' : 'analyse'),
          xl.TextCellValue(displayDate(e.eventDate)),
          xl.TextCellValue(e.ta),
          xl.TextCellValue(e.weight),
          xl.TextCellValue(e.donationType),
          xl.TextCellValue(e.bilan),
          xl.TextCellValue(e.notes),
        ]);
      }
    }

    // (Default sheet was renamed; we now have exactly 2 sheets.)
    return excel.encode()!;
  }

  final Future<List<DonationEvent>> Function(String donorId) _eventsOf;

  /// [_eventsOf] is usually a tear-off of [AppDatabase.getEvents].
  ExcelService(this._eventsOf);

  /// Generates the empty import template (headers only).
  Future<List<int>> exportTemplate() async {
    final excel = xl.Excel.createExcel();
    excel.rename('Sheet1', donorsSheet);
    excel[donorsSheet].appendRow(
      headers.map((h) => xl.TextCellValue(h)).toList(),
    );
    return excel.encode()!;
  }

  /// Opens a file dialog and parses .xlsx/.csv into import rows.
  /// Returns empty list when the user cancels.
  Future<List<ImportedDonor>> pickAndParse() async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
    );
    if (picked == null || picked.path == null) return [];
    final path = picked.path!;
    if (path.toLowerCase().endsWith('.csv')) {
      final raw = await File(path).readAsString();
      final rows = const CsvToListConverter(
        shouldParseNumbers: false,
      ).convert(raw);
      return _parseTable(rows);
    }
    try {
      final bytes = await File(path).readAsBytes();
      final excel = xl.Excel.decodeBytes(bytes);
      final sheetName = excel.sheets.keys.firstWhere(
        (n) => n.toLowerCase().startsWith('don'),
        orElse: () => excel.sheets.keys.first,
      );
      final rows = excel[sheetName].rows
          .map((r) => r.map((c) => c?.value).toList())
          .toList();
      return _parseTable(rows);
    } on FileSystemException {
      rethrow; // caller shows the "close Excel" message
    }
  }

  /// Parses raw table rows (list of cell lists) into ImportedDonor records.
  /// Tolerates missing/extra columns by header names; falls back to position.
  List<ImportedDonor> _parseTable(List<List<dynamic>> table) {
    if (table.isEmpty) return [];
    final headerRow = table.first
        .map((c) => c?.toString().toLowerCase().trim() ?? '')
        .toList();
    int findCol(List<String> keys, int fallback) {
      for (final k in keys) {
        final idx = headerRow.indexWhere((h) => h.contains(k));
        if (idx >= 0) return idx;
      }
      return fallback;
    }

    final cName = findCol(['nom', 'الاسم', 'name'], 0);
    final cMaiden = findCol(['jeune fille', 'اسم الزواج'], 1);
    final cSexe = findCol(['sexe', 'الجنس', 'gender'], 2);
    final cGroupe = findCol(['groupe', 'الزمرة', 'groupe sanguin'], 3);
    final cTel = findCol([
      'téléphone',
      'téléphone /',
      'الهاتف',
      'phone',
      'tel',
    ], 4);
    final cAddr = findCol(['adresse', 'العنوان', 'address'], 5);
    final cEmail = findCol(['e-mail', 'email', 'البريد'], 6);
    final cAddrPro = findCol(['adresse pro', 'العنوان المهني'], 7);
    final cTelPro = findCol(['téléphone pro', 'الهاتف المهني'], 8);
    final cEmailPro = findCol(['e-mail pro', 'البريد المهني'], 9);
    final cPheno = findCol(['phénotype', 'phenotype', 'النمط'], 10);
    final cBirth = findCol(['naissance', 'الميلاد', 'birth'], 11);
    final cDon = findCol(['dernier don', 'آخر تبرع'], 12);
    final cTest = findCol(['analyse', 'آخر تحليل'], 13);
    final cNotes = findCol(['remarque', 'ملاحظة', 'note'], 14);

    final out = <ImportedDonor>[];
    for (final row in table.skip(1)) {
      String cell(int i) =>
          i < row.length && row[i] != null ? row[i].toString().trim() : '';
      final name = cell(cName);
      final group = normalizeBloodGroup(cell(cGroupe));
      if (name.isEmpty || group == null) continue;
      out.add(
        ImportedDonor(
          name: name,
          gender: normalizeGender(cell(cSexe)),
          bloodGroup: group,
          phone: cell(cTel),
          maidenName: cell(cMaiden),
          address: cell(cAddr),
          email: cell(cEmail),
          workAddress: cell(cAddrPro),
          workPhone: cell(cTelPro),
          workEmail: cell(cEmailPro),
          phenotype: cell(cPheno),
          birthDate: normalizeDate(cell(cBirth)),
          lastDonation: normalizeDate(cell(cDon)),
          lastTest: normalizeDate(cell(cTest)),
          notes: cell(cNotes),
        ),
      );
    }
    return out;
  }
}
