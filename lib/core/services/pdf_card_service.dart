import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../data/app_database.dart';
import '../domain/eligibility.dart';
import 'pdf_common.dart';

/// Printable bilingual donor card (بطاقة متبرع / Fiche donneur).
class PdfCardService {
  /// Generates and opens the native print dialog (print or save-as-PDF).
  static Future<void> printDonorCard(
    Donor d,
    bool rtl, {
    Future<List<DonationEvent>> Function(String)? eventsOf,
  }) async {
    final (base, bold) = await PdfCommon.loadFonts();
    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(base: base, bold: bold),
    );

    final next = nextEligibleDate(
      gender: d.gender,
      lastDonation: d.lastDonation,
      lastTest: d.lastTest,
    );
    final events = eventsOf == null ? <DonationEvent>[] : await eventsOf(d.id);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (context) => pw.Directionality(
          textDirection: rtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              PdfCommon.header(context, rtl: rtl, base: base, bold: bold),
              pw.SizedBox(height: 16),
              pw.Center(
                child: pw.Text(
                  rtl ? 'بطاقة متبرع بالدم' : 'Fiche du donneur de sang',
                  textDirection: rtl
                      ? pw.TextDirection.rtl
                      : pw.TextDirection.ltr,
                  style: pw.TextStyle(
                    font: bold,
                    fontBold: bold,
                    fontSize: 18,
                    color: const PdfColor.fromInt(0xFFD92638),
                  ),
                ),
              ),
              pw.SizedBox(height: 12),
              _detailsTable(d, next, rtl, base, bold),
              if (events.isNotEmpty) ...[
                pw.SizedBox(height: 14),
                pw.Text(
                  rtl ? 'سجل التبرعات' : 'Historique des dons',
                  style: pw.TextStyle(font: bold, fontBold: bold, fontSize: 13),
                ),
                pw.SizedBox(height: 6),
                _historyTable(events, rtl, base, bold),
              ],
              pw.Spacer(),
              pw.Align(
                alignment: rtl
                    ? pw.Alignment.bottomLeft
                    : pw.Alignment.bottomRight,
                child: pw.Text(
                  '${rtl ? "التبرع بالدم حياة..." : "Donner son sang, c'est donner la vie..."} — '
                  '${displayDate(isoDate(DateTime.now()))}',
                  textDirection: rtl
                      ? pw.TextDirection.rtl
                      : pw.TextDirection.ltr,
                  style: pw.TextStyle(
                    font: base,
                    fontSize: 9,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await PdfCommon.printPdf(pdf, name: 'donor_card');
  }

  static pw.Widget _detailsTable(
    Donor d,
    DateTime? next,
    bool rtl,
    pw.Font base,
    pw.Font bold,
  ) {
    final dir = rtl ? pw.TextDirection.rtl : pw.TextDirection.ltr;
    pw.TableRow row(String ar, String fr, String value) {
      final label = rtl ? ar : fr;
      return pw.TableRow(
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300)),
        ),
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text(
              label,
              textDirection: dir,
              style: pw.TextStyle(font: bold, fontBold: bold, fontSize: 10),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text(
              value,
              textDirection: dir,
              style: pw.TextStyle(font: base, fontSize: 10),
            ),
          ),
        ],
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey500),
      columnWidths: const {0: pw.FlexColumnWidth(1), 1: pw.FlexColumnWidth(2)},
      children: [
        row('الاسم و اللقب', 'Nom et prénom', d.name),
        row('اسم الزواج', 'Nom de jeune fille', d.maidenName),
        row(
          'الجنس',
          'Sexe',
          d.gender == 'M' ? (rtl ? 'ذكر' : 'Homme') : (rtl ? 'أنثى' : 'Femme'),
        ),
        row('زمرة الدم', 'Groupe sanguin', d.bloodGroup),
        row('رقم الهاتف', 'Téléphone', d.phone),
        row('تاريخ الميلاد', 'Date de naissance', displayDate(d.birthDate)),
        row('مكان الميلاد', 'Lieu de naissance', d.birthPlace),
        row('العنوان', 'Adresse', d.address),
        row('البريد الإلكتروني', 'E-mail', d.email),
        row('عنوان مكان العمل', 'Adresse professionnelle', d.workAddress),
        row('هاتف العمل', 'Téléphone professionnel', d.workPhone),
        row('النمط الظاهري', 'Phénotype', d.phenotype),
        row('آخر تبرع', 'Dernier don', displayDate(d.lastDonation)),
        row('آخر تحليل دم', 'Dernière analyse', displayDate(d.lastTest)),
        row(
          'الأهلية القادمة',
          'Prochaine éligibilité',
          next == null ? '' : displayDate(isoDate(next)),
        ),
        row('ملاحظة', 'Remarque', d.notes),
      ],
    );
  }

  static pw.Widget _historyTable(
    List<DonationEvent> events,
    bool rtl,
    pw.Font base,
    pw.Font bold,
  ) {
    final dir = rtl ? pw.TextDirection.rtl : pw.TextDirection.ltr;
    pw.Widget cell(String s, {pw.Font? f}) => pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        s,
        textDirection: dir,
        style: pw.TextStyle(font: f ?? base, fontBold: bold, fontSize: 9),
      ),
    );
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey500),
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            cell(rtl ? 'التاريخ' : 'Date', f: bold),
            cell(rtl ? 'النوع' : 'Type', f: bold),
            cell(rtl ? 'ضغط الدم' : 'TA', f: bold),
            cell(rtl ? 'الوزن' : 'Poids', f: bold),
            cell(rtl ? 'نوع التبرع' : 'Type de don', f: bold),
            cell(rtl ? 'التحليل' : 'Bilan', f: bold),
            cell(rtl ? 'ملاحظات' : 'Observations', f: bold),
          ],
        ),
        for (final e in events)
          pw.TableRow(
            children: [
              cell(displayDate(e.eventDate)),
              cell(
                e.eventType == 'donation'
                    ? (rtl ? 'تبرع' : 'Don')
                    : (rtl ? 'تحليل' : 'Analyse'),
              ),
              cell(e.ta),
              cell(e.weight),
              cell(e.donationType),
              cell(e.bilan),
              cell(e.notes),
            ],
          ),
      ],
    );
  }
}
