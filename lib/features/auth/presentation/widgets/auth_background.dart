import 'dart:math' as math;

import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const <Widget>[
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(color: Color(0xFF040404)),
          ),
        ),
        Positioned.fill(child: _DiagonalStripeLayer()),
        Positioned.fill(child: _EdgeRails()),
      ],
    );
  }
}

class _DiagonalStripeLayer extends StatelessWidget {
  const _DiagonalStripeLayer();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _DiagonalStripePainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _DiagonalStripePainter extends CustomPainter {
  const _DiagonalStripePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint stripePaint = Paint()
      ..color = const Color(0xFF131313).withValues(alpha: 0.42)
      ..strokeWidth = 2;
    final Paint glowPaint = Paint()
      ..color = const Color(0xFF0B1630).withValues(alpha: 0.08);

    canvas.drawRect(Offset.zero & size, glowPaint);

    const double gap = 14;
    for (double x = -size.height; x < size.width + size.height; x += gap) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        stripePaint,
      );
    }

    final Paint orbPaint = Paint()
      ..shader =
          const RadialGradient(
            colors: <Color>[Color(0x141AA0FF), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.45),
              radius: math.max(size.width, size.height) * 0.45,
            ),
          );
    canvas.drawRect(Offset.zero & size, orbPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EdgeRails extends StatelessWidget {
  const _EdgeRails();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[_Rail(), _Rail()],
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            const Color(0xFF4EA8FF).withValues(alpha: 0.95),
            const Color(0xFF4EA8FF).withValues(alpha: 0.35),
            const Color(0xFF4EA8FF).withValues(alpha: 0.95),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF4EA8FF).withValues(alpha: 0.18),
            blurRadius: 12,
          ),
        ],
      ),
    );
  }
}
