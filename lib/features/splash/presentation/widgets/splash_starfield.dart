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

  static const List<_LineData> _lines = <_LineData>[
    _LineData(0.08, 0.05, 0.8, 1.2, 0.6, 0.08),
    _LineData(0.18, 0.14, 0.45, 1.0, 0.4, 0.05),
    _LineData(0.34, 0.03, 0.35, 0.9, 0.5, 0.06),
    _LineData(0.52, 0.07, 0.7, 1.1, 0.7, 0.10),
    _LineData(0.78, 0.11, 0.5, 1.0, 0.35, 0.04),
    _LineData(0.92, 0.05, 0.35, 0.85, 0.65, 0.09),
    _LineData(0.14, 0.33, 0.32, 0.85, 0.45, 0.05),
    _LineData(0.28, 0.29, 0.48, 0.95, 0.55, 0.07),
    _LineData(0.82, 0.27, 0.4, 1.0, 0.4, 0.04),
    _LineData(0.9, 0.38, 0.75, 1.15, 0.8, 0.12),
    _LineData(0.16, 0.63, 0.25, 0.8, 0.3, 0.03),
    _LineData(0.24, 0.72, 0.42, 0.95, 0.5, 0.06),
    _LineData(0.86, 0.68, 0.58, 1.05, 0.6, 0.08),
    _LineData(0.11, 0.9, 0.4, 1.0, 0.45, 0.05),
    _LineData(0.88, 0.88, 0.65, 1.15, 0.75, 0.11),
    _LineData(0.45, 0.88, 0.8, 1.8, 1.2, 0.2),
    _LineData(0.65, 0.55, 0.8, 1.8, 1.1, 0.18),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint mistPaint = Paint()
      ..shader =
          const RadialGradient(
            colors: <Color>[
              Color(0x2A1A8FFF),
              Color(0x140F55FF),
              Colors.transparent,
            ],
            stops: <double>[0.0, 0.4, 1.0],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.4),
              radius: size.shortestSide * 0.8,
            ),
          );
    canvas.drawRect(Offset.zero & size, mistPaint);

    final double fastProgress = progress * 4;

    for (int index = 0; index < _lines.length; index += 1) {
      final _LineData lineData = _lines[index];

      final double currentYFactor =
          (lineData.yFactor + (fastProgress * lineData.speed)) % 1.0;

      final Paint linePaint = Paint()
        ..color = const Color(0xFF7AF0FF).withValues(alpha: lineData.alpha)
        ..strokeWidth = lineData.thickness
        ..strokeCap = StrokeCap.round;

      final double x = size.width * lineData.xFactor;
      final double y = size.height * currentYFactor;
      final double lineLength = size.height * lineData.length;

      canvas.drawLine(Offset(x, y - lineLength), Offset(x, y), linePaint);

      if (y - lineLength < 0) {
        canvas.drawLine(
          Offset(x, y - lineLength + size.height),
          Offset(x, y + size.height),
          linePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SplashStarfieldPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _LineData {
  const _LineData(
    this.xFactor,
    this.yFactor,
    this.alpha,
    this.thickness,
    this.speed,
    this.length,
  );

  final double xFactor;
  final double yFactor;
  final double alpha;
  final double thickness;
  final double speed;
  final double length;
}
