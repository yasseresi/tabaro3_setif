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
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final rect = Offset.zero & size;

    // White face + green half
    canvas.drawCircle(rect.center, s / 2, Paint()..color = Colors.white);
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, s / 2, s));
    canvas.drawCircle(
      rect.center,
      s / 2,
      Paint()..color = const Color(0xFF006233),
    );
    canvas.restore();

    // Red crescent = big red circle minus offset white circle
    final cx = s * 0.42, cy = s * 0.5, r = s * 0.30;
    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(s / 2)),
      doAntiAlias: true,
    );
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()..color = const Color(0xFFD21034),
    );
    canvas.drawCircle(
      Offset(cx + r * 0.32, cy),
      r * 0.82,
      Paint()..color = Colors.white,
    );
    canvas.restore();

    // Red star
    final star = Path();
    final sx = cx + r * 0.82, sy = cy, srad = s * 0.11;
    for (var i = 0; i < 5; i++) {
      final a = -math.pi / 2 + i * 4 * math.pi / 5;
      final p = Offset(sx + srad * math.cos(a), sy + srad * math.sin(a));
      i == 0 ? star.moveTo(p.dx, p.dy) : star.lineTo(p.dx, p.dy);
    }
    star.close();
    canvas.drawPath(star, Paint()..color = const Color(0xFFD21034));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Crimson blood-drop logo with a white heart.
class BloodDropLogo extends StatelessWidget {
  final double size;
  final Color color;
  const BloodDropLogo({
    super.key,
    this.size = 48,
    this.color = AppColors.blood,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * 0.82, size),
      painter: _DropPainter(color: color),
    );
  }
}

class _DropPainter extends CustomPainter {
  final Color color;
  _DropPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final drop = Path()
      ..moveTo(w * 0.5, h)
      ..cubicTo(w * 0.95, h * 0.62, w, h * 0.52, w, h * 0.34)
      ..cubicTo(w, h * 0.13, w * 0.78, 0, w * 0.5, 0)
      ..cubicTo(w * 0.22, 0, 0, h * 0.13, 0, h * 0.34)
      ..cubicTo(0, h * 0.52, w * 0.05, h * 0.62, w * 0.5, h)
      ..close();
    canvas.drawPath(drop, Paint()..color = color);

    // White heart in the lower half
    final heart = Path()
      ..moveTo(w * 0.5, h * 0.76)
      ..cubicTo(w * 0.2, h * 0.55, w * 0.24, h * 0.40, w * 0.38, h * 0.40)
      ..cubicTo(w * 0.45, h * 0.40, w * 0.49, h * 0.44, w * 0.5, h * 0.47)
      ..cubicTo(w * 0.51, h * 0.44, w * 0.55, h * 0.40, w * 0.62, h * 0.40)
      ..cubicTo(w * 0.76, h * 0.40, w * 0.8, h * 0.55, w * 0.5, h * 0.76)
      ..close();
    canvas.drawPath(heart, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _DropPainter oldDelegate) =>
      oldDelegate.color != color;
}
