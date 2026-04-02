import 'package:flutter/material.dart';

class ShopBackground extends StatelessWidget {
  const ShopBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _ShopBackgroundPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _ShopBackgroundPainter extends CustomPainter {
  const _ShopBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = const Color(0xFF16D5FF).withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    const double gap = 32;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final Paint topGlow = Paint()
      ..shader =
          const RadialGradient(
            colors: <Color>[Color(0x1816D5FF), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.8, size.height * 0.08),
              radius: size.width * 0.55,
            ),
          );
    canvas.drawRect(Offset.zero & size, topGlow);

    final Paint midGlow = Paint()
      ..shader =
          const RadialGradient(
            colors: <Color>[Color(0x140F55FF), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.2, size.height * 0.42),
              radius: size.width * 0.5,
            ),
          );
    canvas.drawRect(Offset.zero & size, midGlow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
