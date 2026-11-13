import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

/// Algerian flag circular emblem (green half, red crescent + star).
class AlgerianEmblem extends StatelessWidget {
  final double size;
  const AlgerianEmblem({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: CustomPaint(size: Size(size, size), painter: _FlagPainter()),
      ),
    );
  }
}

class _FlagPainter extends CustomPainter {
  // Geometry of the official 900x600 flag, cropped to its central circle:
  // green hoist half, white fly half, red crescent centred on the seam with
  // the star (one tip pointing right) inside its mouth.
  static const _red = Color(0xFFD21034);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    Offset at(double x, double y) => Offset(x * s, y * s);

    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, s / 2, s),
      Paint()..color = const Color(0xFF006233),
    );

    final crescent = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: at(0.5, 0.5), radius: 0.25 * s)),
      Path()
        ..addOval(Rect.fromCircle(center: at(0.5605, 0.5), radius: 0.2 * s)),
    );
    canvas.drawPath(crescent, Paint()..color = _red);

    final star = Path();
    final c = at(0.6011, 0.5);
    for (var i = 0; i < 10; i++) {
      final radius = (i.isEven ? 0.125 : 0.125 * 0.382) * s;
      final a = i * math.pi / 5;
      final p = c + Offset(radius * math.cos(a), radius * math.sin(a));
      i == 0 ? star.moveTo(p.dx, p.dy) : star.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(star..close(), Paint()..color = _red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Crimson blood-drop logo with a white heart.
class BloodDropLogo extends StatelessWidget {
  final double size;
  final Color color;
  final Color? heartColor;
  const BloodDropLogo({
    super.key,
    this.size = 48,
    this.color = AppColors.blood,
    this.heartColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * 0.82, size),
      painter: _DropPainter(
        color: color,
        heartColor: heartColor ?? Colors.white,
      ),
    );
  }
}

class _DropPainter extends CustomPainter {
  final Color color;
  final Color heartColor;
  _DropPainter({required this.color, required this.heartColor});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    // Classic drop: pointed tip on top, round belly below.
    final drop = Path()
      ..moveTo(w * 0.5, 0)
      ..cubicTo(w * 0.62, h * 0.18, w, h * 0.42, w, h * 0.66)
      ..cubicTo(w, h * 0.86, w * 0.78, h, w * 0.5, h)
      ..cubicTo(w * 0.22, h, 0, h * 0.86, 0, h * 0.66)
      ..cubicTo(0, h * 0.42, w * 0.38, h * 0.18, w * 0.5, 0)
      ..close();
    final hsl = HSLColor.fromColor(color);
    canvas.drawPath(
      drop,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            hsl.withLightness((hsl.lightness + 0.08).clamp(0.0, 1.0)).toColor(),
            hsl.withLightness((hsl.lightness - 0.08).clamp(0.0, 1.0)).toColor(),
          ],
        ).createShader(Offset.zero & size),
    );

    // Soft highlight on the left shoulder.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.2, h * 0.62)
        ..quadraticBezierTo(w * 0.2, h * 0.46, w * 0.34, h * 0.32),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = w * 0.07
        ..color = Colors.white.withValues(alpha: 0.35),
    );

    // Heart centred in the belly.
    final cx = w * 0.5, cy = h * 0.68, u = w * 0.24;
    final heart = Path()
      ..moveTo(cx, cy + u * 0.95)
      ..cubicTo(
        cx - u * 1.5,
        cy - u * 0.05,
        cx - u * 0.9,
        cy - u * 1.1,
        cx,
        cy - u * 0.4,
      )
      ..cubicTo(
        cx + u * 0.9,
        cy - u * 1.1,
        cx + u * 1.5,
        cy - u * 0.05,
        cx,
        cy + u * 0.95,
      )
      ..close();
    canvas.drawPath(heart, Paint()..color = heartColor);
  }

  @override
  bool shouldRepaint(covariant _DropPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.heartColor != heartColor;
}
