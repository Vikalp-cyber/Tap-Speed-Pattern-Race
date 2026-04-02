import 'package:flutter/material.dart';

import '../matchmaking_tokens.dart';

class MatchmakingGridBackground extends StatelessWidget {
  const MatchmakingGridBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[matchmakingBg, Color(0xFF081426), matchmakingBg],
            ),
          ),
        ),
        const Positioned.fill(child: CustomPaint(painter: _GridPainter())),
        Positioned(
          top: -120,
          right: -72,
          child: _GlowOrb(
            size: 280,
            color: matchmakingBlue.withValues(alpha: 0.16),
          ),
        ),
        Positioned(
          top: 160,
          left: -96,
          child: _GlowOrb(
            size: 240,
            color: matchmakingPurple.withValues(alpha: 0.14),
          ),
        ),
        Positioned(
          bottom: -150,
          left: 0,
          right: 0,
          child: Center(
            child: _GlowOrb(
              size: 360,
              color: matchmakingBlueDeep.withValues(alpha: 0.14),
            ),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = matchmakingBlue.withValues(alpha: 0.07)
      ..strokeWidth = 1;

    const double step = 36;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final Paint diagonalPaint = Paint()
      ..color = matchmakingBlue.withValues(alpha: 0.035)
      ..strokeWidth = 1.2;
    const double diagonalGap = 64;
    for (
      double start = -size.height;
      start < size.width;
      start += diagonalGap
    ) {
      canvas.drawLine(
        Offset(start, 0),
        Offset(start + size.height, size.height),
        diagonalPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: <Color>[color, Colors.transparent]),
        ),
      ),
    );
  }
}
