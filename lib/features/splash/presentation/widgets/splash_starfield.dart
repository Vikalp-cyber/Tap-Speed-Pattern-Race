import 'dart:math' as math;

import 'package:flutter/material.dart';

class SplashStarfield extends StatelessWidget {
  const SplashStarfield({required this.progress, super.key});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SplashStarfieldPainter(progress: progress),
      child: const SizedBox.expand(),
    );
  }
}

class _SplashStarfieldPainter extends CustomPainter {
  const _SplashStarfieldPainter({required this.progress});

  final double progress;

  static const List<_StarData> _stars = <_StarData>[
    _StarData(0.08, 0.05, 0.8, 1.2),
    _StarData(0.18, 0.14, 0.45, 1.0),
    _StarData(0.34, 0.03, 0.35, 0.9),
    _StarData(0.52, 0.07, 0.7, 1.1),
    _StarData(0.78, 0.11, 0.5, 1.0),
    _StarData(0.92, 0.05, 0.35, 0.85),
    _StarData(0.14, 0.33, 0.32, 0.85),
    _StarData(0.28, 0.29, 0.48, 0.95),
    _StarData(0.82, 0.27, 0.4, 1.0),
    _StarData(0.9, 0.38, 0.75, 1.15),
    _StarData(0.16, 0.63, 0.25, 0.8),
    _StarData(0.24, 0.72, 0.42, 0.95),
    _StarData(0.86, 0.68, 0.58, 1.05),
    _StarData(0.11, 0.9, 0.4, 1.0),
    _StarData(0.88, 0.88, 0.65, 1.15),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint mistPaint = Paint()
      ..shader =
          const RadialGradient(
            colors: <Color>[Color(0x140F55FF), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.3),
              radius: size.shortestSide * 0.55,
            ),
          );
    canvas.drawRect(Offset.zero & size, mistPaint);

    for (int index = 0; index < _stars.length; index += 1) {
      final _StarData star = _stars[index];
      final double pulse =
          0.35 +
          (math.sin((progress * math.pi * 4) + (index * 0.85)).abs() * 0.65);
      final Paint starPaint = Paint()
        ..color = const Color(0xFF76A7FF).withValues(alpha: star.alpha * pulse);

      canvas.drawCircle(
        Offset(size.width * star.xFactor, size.height * star.yFactor),
        star.radius * pulse,
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SplashStarfieldPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _StarData {
  const _StarData(this.xFactor, this.yFactor, this.alpha, this.radius);

  final double xFactor;
  final double yFactor;
  final double alpha;
  final double radius;
}
