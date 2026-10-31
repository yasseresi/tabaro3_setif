import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Shared PDF helpers: Cairo font loading + CWTS institutional header.
class PdfCommon {
  PdfCommon._();

  /// Sends finished PDF bytes to the OS print flow.
  /// Windows: native print dialog via `printing` (the clinic's platform).
  /// macOS: open in Preview — its print dialog is the native macOS way
  /// (`Printing.layoutPdf`'s WKWebView dialog is unreliable there).
  static Future<void> printPdf(
    pw.Document pdf, {
    String name = 'tabaro3',
  }) async {
    final bytes = await pdf.save();
    if (Platform.isMacOS) {
      final file = File(
        p.join(
          Directory.systemTemp.path,
          '${name}_${DateTime.now().millisecondsSinceEpoch}.pdf',
        ),
      );
      await file.writeAsBytes(bytes);
      await Process.run('open', [file.path]);
    } else {
      await Printing.layoutPdf(onLayout: (_) => bytes);
    }
  }

  static Future<(pw.Font, pw.Font)> loadFonts() async {
    final regular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Cairo-Regular.ttf'),
    );
    final bold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Cairo-Bold.ttf'),
    );
    return (regular, bold);
  }

  /// Algerian flag circular emblem drawn with PdfGraphics.
  static pw.Widget flagEmblem({double size = 40}) => pw.CustomPaint(
    size: PdfPoint(size, size),
    painter: (PdfGraphics canvas, PdfPoint sz) {
      final w = sz.x, h = sz.y, r = w / 2;
      final cx = w / 2, cy = h / 2, k = 0.5523 * r;
      // White ring border + white face
      canvas
        ..setFillColor(PdfColors.white)
        ..drawEllipse(cx, cy, r, r)
        ..fillPath()
        ..setStrokeColor(PdfColors.grey400)
        ..setLineWidth(1)
        ..drawEllipse(cx, cy, r, r)
        ..strokePath();
      // Green left half: full green circle, then white right half over it
      // (drawShape supports M/L/C/Z only — no SVG arcs, so the half-disc is
      // drawn with the standard cubic kappa approximation).
      canvas
        ..setFillColor(const PdfColor.fromInt(0xFF006233))
        ..drawEllipse(cx, cy, r, r)
        ..fillPath()
        ..setFillColor(PdfColors.white)
        ..drawShape(
          'M $cx ${cy - r} '
          'C ${cx + k} ${cy - r} ${cx + r} ${cy - k} ${cx + r} $cy '
          'C ${cx + r} ${cy + k} ${cx + k} ${cy + r} $cx ${cy + r} Z',
        )
        ..fillPath();
      // Crescent (outer disc minus inner disc) + star, official proportions.
      const red = PdfColor.fromInt(0xFFD21034);
      canvas.setFillColor(red);
      const n = 48, phi = 0.6751; // inner-disc tip angle
      final ix = 0.5605 * w, ir = 0.2 * w, or = 0.25 * w;
      for (var i = 0; i <= n; i++) {
        final a = -math.pi / 6 - (5 * math.pi / 3) * i / n;
        final x = cx + or * math.cos(a), y = cy + or * math.sin(a);
        i == 0 ? canvas.moveTo(x, y) : canvas.lineTo(x, y);
      }
      for (var i = 0; i <= n; i++) {
        final a = phi + (2 * math.pi - 2 * phi) * i / n;
        canvas.lineTo(ix + ir * math.cos(a), cy + ir * math.sin(a));
      }
      canvas.fillPath();
      final sx = 0.6011 * w, srad = 0.125 * w;
      for (var i = 0; i < 10; i++) {
        final radius = i.isEven ? srad : srad * 0.382;
        final a = i * math.pi / 5;
        final px = sx + radius * math.cos(a), py = cy + radius * math.sin(a);
        i == 0 ? canvas.moveTo(px, py) : canvas.lineTo(px, py);
      }
      canvas.fillPath();
    },
  );

  /// Crimson blood-drop-with-heart emblem (same shape as the on-screen logo).
  static pw.Widget dropEmblem({double size = 36}) => pw.CustomPaint(
    size: PdfPoint(size * 0.82, size),
    painter: (PdfGraphics canvas, PdfPoint sz) {
      final w = sz.x, h = sz.y;
      // Shapes are written in screen coords (y down); `y()` flips for PDF.
      String pt(double x, double y) => '$x ${h - y}';
      final drop =
          'M ${pt(w * 0.5, 0)} '
          'C ${pt(w * 0.62, h * 0.18)} ${pt(w, h * 0.42)} ${pt(w, h * 0.66)} '
          'C ${pt(w, h * 0.86)} ${pt(w * 0.78, h)} ${pt(w * 0.5, h)} '
          'C ${pt(w * 0.22, h)} ${pt(0, h * 0.86)} ${pt(0, h * 0.66)} '
          'C ${pt(0, h * 0.42)} ${pt(w * 0.38, h * 0.18)} ${pt(w * 0.5, 0)} Z';
      canvas
        ..setFillColor(const PdfColor.fromInt(0xFFD92638))
        ..drawShape(drop)
        ..fillPath();
      final cx = w * 0.5, cy = h * 0.68, u = w * 0.24;
      final heart =
          'M ${pt(cx, cy + u * 0.95)} '
          'C ${pt(cx - u * 1.5, cy - u * 0.05)} ${pt(cx - u * 0.9, cy - u * 1.1)} ${pt(cx, cy - u * 0.4)} '
          'C ${pt(cx + u * 0.9, cy - u * 1.1)} ${pt(cx + u * 1.5, cy - u * 0.05)} ${pt(cx, cy + u * 0.95)} Z';
      canvas
        ..setFillColor(PdfColors.white)
        ..drawShape(heart)
        ..fillPath();
    },
  );

  /// Bilingual institutional banner used by the donor card & CSW fiche.
  static pw.Widget header(
    pw.Context context, {
    required bool rtl,
    required pw.Font base,
    required pw.Font bold,
  }) {
    final dir = rtl ? pw.TextDirection.rtl : pw.TextDirection.ltr;
    final ar = const [
      'الجمهورية الجزائرية الديمقراطية الشعبية',
      'وزارة الصحة',
      'المركز الولائي لحقن الدم سطيف',
    ];
    final fr = const [
      'République Algérienne Démocratique et Populaire',
      'Ministère de la Santé',
      'Centre de Wilaya de Transfusion Sanguine – Sétif',
    ];
    final lines = rtl ? ar : fr;
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.blueGrey50,
        border: pw.Border.all(color: PdfColors.blueGrey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Directionality(
        textDirection: dir,
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            flagEmblem(size: 44),
            pw.SizedBox(width: 12),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  for (var i = 0; i < lines.length; i++)
                    pw.Text(
                      lines[i],
                      textDirection: dir,
                      style: pw.TextStyle(
                        font: base,
                        fontBold: bold,
                        fontWeight: i == lines.length - 1
                            ? pw.FontWeight.bold
                            : pw.FontWeight.normal,
                        fontSize: i == lines.length - 1 ? 12 : 8.5,
                      ),
                    ),
                ],
              ),
            ),
            pw.SizedBox(width: 12),
            dropEmblem(size: 40),
          ],
        ),
      ),
    );
  }
}
