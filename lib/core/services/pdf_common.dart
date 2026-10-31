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
      // Red crescent = big red circle minus offset white circle
      final mx = w * 0.42, my = h * 0.5, cr = h * 0.30;
      canvas
        ..setFillColor(const PdfColor.fromInt(0xFFD21034))
        ..drawEllipse(mx, my, cr, cr)
        ..fillPath()
        ..setFillColor(PdfColors.white)
        ..drawEllipse(mx + cr * 0.30, my, cr * 0.80, cr * 0.80)
        ..fillPath();
      // 5-point star
      canvas.setFillColor(const PdfColor.fromInt(0xFFD21034));
      final sx = mx + cr * 0.78, srad = h * 0.10;
      for (var i = 0; i < 10; i++) {
        final radius = i.isEven ? srad : srad * 0.42;
        final a = -math.pi / 2 + i * math.pi / 5;
        final px = sx + radius * math.cos(a), py = my + radius * math.sin(a);
        if (i == 0) {
          canvas.moveTo(px, py);
        } else {
          canvas.lineTo(px, py);
        }
      }
      canvas.fillPath();
    },
  );

  /// Crimson blood-drop-with-heart emblem.
  static pw.Widget dropEmblem({double size = 36}) => pw.CustomPaint(
    size: PdfPoint(size * 0.82, size),
    painter: (PdfGraphics canvas, PdfPoint sz) {
      final w = sz.x, h = sz.y;
      // Teardrop silhouette (SVG path in widget coords)
      final d =
          'M ${(w * 0.5).toStringAsFixed(0)} $h '
          'C ${w * 0.95} ${h * 0.62} $w ${h * 0.52} $w ${h * 0.34} '
          'C $w ${h * 0.13} ${w * 0.78} 0 ${(w * 0.5).toStringAsFixed(0)} 0 '
          'C ${w * 0.22} 0 0 ${h * 0.13} 0 ${h * 0.34} '
          'C 0 ${h * 0.52} ${w * 0.05} ${h * 0.62} ${(w * 0.5).toStringAsFixed(0)} $h Z';
      canvas
        ..setFillColor(const PdfColor.fromInt(0xFFD92638))
        ..drawShape(d)
        ..fillPath();
      // White heart centered in lower half: two lobes + triangle body
      canvas
        ..setFillColor(PdfColors.white)
        ..drawEllipse(w * 0.30, h * 0.52, w * 0.22, h * 0.09)
        ..fillPath()
        ..drawEllipse(w * 0.70, h * 0.52, w * 0.22, h * 0.09)
        ..fillPath()
        ..drawShape(
          'M ${w * 0.19} ${h * 0.54} L ${w * 0.81} ${h * 0.54} L ${(w * 0.5).toStringAsFixed(0)} ${h * 0.76} Z',
        )
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
