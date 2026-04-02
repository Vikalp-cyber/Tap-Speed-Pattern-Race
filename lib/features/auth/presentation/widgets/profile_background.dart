import 'package:flutter/material.dart';

import 'profile_tokens.dart';

class ProfileBackground extends StatelessWidget {
  const ProfileBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _ProfileBackgroundPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _ProfileBackgroundPainter extends CustomPainter {
  const _ProfileBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = profileBlue.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const double gap = 34;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final Paint heroGlow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -1),
        radius: 1.4,
        colors: <Color>[
          profileBlue.withValues(alpha: 0.20),
          profilePurple.withValues(alpha: 0.10),
          Colors.transparent,
        ],
        stops: const <double>[0, 0.45, 0.75],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 280));
    canvas.drawRect(Offset.zero & size, heroGlow);

    final Paint sideGlow = Paint()
      ..shader =
          const RadialGradient(
            colors: <Color>[Color(0x140F55FF), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.85, size.height * 0.2),
              radius: size.width * 0.48,
            ),
          );
    canvas.drawRect(Offset.zero & size, sideGlow);

    final Paint lowGlow = Paint()
      ..shader =
          const RadialGradient(
            colors: <Color>[Color(0x0E16D5FF), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.18, size.height * 0.68),
              radius: size.width * 0.56,
            ),
          );
    canvas.drawRect(Offset.zero & size, lowGlow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
