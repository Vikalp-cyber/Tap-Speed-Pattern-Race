import 'package:flutter/material.dart';

import '../matchmaking_tokens.dart';

class MatchmakingGridBackground extends StatelessWidget {
  const MatchmakingGridBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _GridPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = matchmakingBlue.withValues(alpha: 0.10)
      ..strokeWidth = 1;

    const double step = 40;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}
