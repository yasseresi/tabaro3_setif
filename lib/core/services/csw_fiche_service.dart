import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../data/app_database.dart';
import '../domain/eligibility.dart';
import 'pdf_common.dart';

/// Reproduces the official CWTS Sétif paper form
/// « CSW / SETIF — FICHE DONNEUR DE SANG » (ANS/COL/FIC02/V01/22).
///
/// Layout (French, LTR — the original form is a French document):
///  - identity block: Identifiant donneur, Nom/Prénoms, Nom de jeune fille,
///    Né(e) le, Adresse domicile, Tél/E-mail, Adresse professionnelle, Tél/E-mail
///  - donation history table: Date du don | N° d'identification du don | TA |
///    Poids | Type de don | Bilan | Contre-indications au don et Observations
///    (pre-filled from donation_events, remaining rows blank for handwriting)
///  - Groupe ABO / Rhésus / Phénotype block
///  - footer stamp ref: ANS/COL/FIC02/V01/22
///
/// [blank]=true prints an empty form for handwriting at the reception desk.
class CswFicheService {
  static const formRef = 'ANS/COL/FIC02/V01/22';
  static const _tableRows = 20;
  static const _rowHeight = 20.0;

  static Future<void> printFiche(
    Donor d,
    List<DonationEvent> events, {
    bool blank = false,
  }) async {
    final (base, bold) = await PdfCommon.loadFonts();
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: base, bold: bold),
    );
    pdf.addPage(_page(pdf, d, events, blank, base, bold));
    await Printing.layoutPdf(onLayout: (f) => pdf.save());
  }

  /// Multi-donor print job: one fiche page per donor.
  static Future<void> printAllFiches(
    List<Donor> donors,
    Future<List<DonationEvent>> Function(String) eventsOf,
  ) async {
    final (base, bold) = await PdfCommon.loadFonts();
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: base, bold: bold),
    );
    for (final d in donors) {
      final events = await eventsOf(d.id);
      pdf.addPage(_page(pdf, d, events, false, base, bold));
    }
    await Printing.layoutPdf(onLayout: (f) => pdf.save());
  }

  static pw.Page _page(
    pw.Document pdf,
    Donor d,
    List<DonationEvent> events,
    bool blank,
    pw.Font base,
    pw.Font bold,
  ) {
    final dons = events.where((e) => e.eventType == 'donation').toList();
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.fromLTRB(36, 26, 36, 24),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Row(
            children: [
              pw.Text(
                'CSW / SETIF',
                style: pw.TextStyle(
                  font: bold,
                  fontBold: bold,
                  fontSize: 11,
                  color: PdfColors.grey700,
                ),
              ),
              pw.Spacer(),
              PdfCommon.flagEmblem(size: 30),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Center(
            child: pw.Text(
              'FICHE DONNEUR DE SANG',
              style: pw.TextStyle(
                font: bold,
                fontBold: bold,
                fontSize: 15,
                letterSpacing: 1.2,
                color: const PdfColor.fromInt(0xFFD92638),
              ),
            ),
          ),
          pw.SizedBox(height: 10),
          _identityBlock(d, blank, base, bold),
          pw.SizedBox(height: 10),
          _historyTable(dons, blank, base, bold),
          pw.SizedBox(height: 10),
          _aboBlock(d, blank, base, bold),
          pw.Spacer(),
          pw.Align(
            alignment: pw.Alignment.bottomLeft,
            child: pw.Text(
              formRef,
              style: pw.TextStyle(
                font: base,
                fontSize: 8,
                color: PdfColors.grey600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Blocks -----------------------------------------------------------

  static pw.Widget _identityBlock(
    Donor d,
    bool blank,
    pw.Font base,
    pw.Font bold,
  ) {
    pw.Widget field(String label, String value) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2.8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.SizedBox(
            width: 175,
            child: pw.Text(
              '$label :',
              style: pw.TextStyle(font: bold, fontBold: bold, fontSize: 10.5),
            ),
          ),
          pw.Expanded(
            child: pw.Container(
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(color: PdfColors.grey500),
                ),
              ),
              padding: const pw.EdgeInsets.only(bottom: 1),
              child: pw.Text(
                blank ? '' : value,
                style: pw.TextStyle(font: base, fontSize: 10.5),
              ),
            ),
          ),
        ],
      ),
    );

    pw.Widget twoFields(String l1, String v1, String l2, String v2) => pw.Row(
      children: [
        pw.SizedBox(width: 250, child: field(l1, v1)),
        pw.SizedBox(width: 16),
        pw.Expanded(child: field(l2, v2)),
      ],
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        field('Identifiant donneur', d.id),
        field('Nom, Prénom (s)', d.name),
        field('Nom de jeune fille', d.maidenName),
        field('Né (e) le', displayDate(d.birthDate)),
        field('Adresse domicile', d.address),
        twoFields('Tél', d.phone, 'E-mail', d.email),
        field('Adresse professionnelle', d.workAddress),
        twoFields('Tél', d.workPhone, 'E-mail', d.workEmail),
      ],
    );
  }

  static pw.Widget _historyTable(
    List<DonationEvent> dons,
    bool blank,
    pw.Font base,
    pw.Font bold,
  ) {
    const columns = [
      'Date\nDu don',
      "N° d'identification\nDu don",
      'TA',
      'Poids',
      'Type de\ndon',
      'Bilan',
      'Contre-indications au don et Observations',
    ];
    const widths = [
      52.0,
      78.0,
      36.0,
      40.0,
      58.0,
      56.0,
      203.0,
    ]; // = 523 (A4 - margins)

    pw.Widget cell(
      String s,
      double w, {
      required pw.Font f,
      pw.Alignment align = pw.Alignment.center,
    }) {
      return pw.Container(
        width: w,
        height: _rowHeight,
        padding: const pw.EdgeInsets.all(2.5),
        alignment: align,
        child: pw.Text(
          s,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(font: f, fontBold: bold, fontSize: 8.5),
        ),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.7),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            for (var i = 0; i < columns.length; i++)
              cell(columns[i], widths[i], f: bold),
          ],
        ),
        for (var i = 0; i < _tableRows; i++)
          pw.TableRow(
            children: [
              for (var c = 0; c < columns.length; c++)
                cell(
                  blank
                      ? ''
                      : switch (c) {
                          0 =>
                            i < dons.length
                                ? displayDate(dons[i].eventDate)
                                : '',
                          1 => i < dons.length ? '${i + 1}' : '',
                          2 => i < dons.length ? dons[i].ta : '',
                          3 => i < dons.length ? dons[i].weight : '',
                          4 => i < dons.length ? dons[i].donationType : '',
                          5 => i < dons.length ? dons[i].bilan : '',
                          _ => i < dons.length ? dons[i].notes : '',
                        },
                  widths[c],
                  f: base,
                  align: c == columns.length - 1
                      ? pw.Alignment.topLeft
                      : pw.Alignment.topCenter,
                ),
            ],
          ),
      ],
    );
  }

  static pw.Widget _aboBlock(Donor d, bool blank, pw.Font base, pw.Font bold) {
    final split = blank ? null : splitBloodGroup(d.bloodGroup);
    final abo = split?.abo ?? '';
    final rhesus = split?.rhesus ?? '';
    pw.Widget line(String label, String value) => pw.Row(
      children: [
        pw.SizedBox(
          width: 130,
          child: pw.Text(
            label,
            style: pw.TextStyle(font: bold, fontBold: bold, fontSize: 10.5),
          ),
        ),
        pw.Container(
          width: 140,
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey500)),
          ),
          child: pw.Text(
            value,
            style: pw.TextStyle(font: base, fontSize: 10.5),
          ),
        ),
      ],
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        line('Groupe ABO :', abo),
        pw.SizedBox(height: 4),
        line(
          'Rhésus :',
          blank ? '' : (rhesus == '+' ? 'Positif (+)' : 'Négatif (-)'),
        ),
        pw.SizedBox(height: 4),
        line('Phénotype :', blank ? '' : d.phenotype),
      ],
    );
  }
}
