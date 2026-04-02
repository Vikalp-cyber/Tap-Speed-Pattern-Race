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
        Positioned.fill(child: _GridMatrixLayer()),
        Positioned.fill(child: _AuthCornerBrackets()),
      ],
    );
  }
}

class _GridMatrixLayer extends StatelessWidget {
  const _GridMatrixLayer();

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
    final Paint gridPaint = Paint()
      ..color = const Color(0xFF16D5FF).withValues(alpha: 0.05)
      ..strokeWidth = 1.5;

    final Paint glowPaint = Paint()
      ..color = const Color(0xFF040A1A).withValues(alpha: 0.4);
    canvas.drawRect(Offset.zero & size, glowPaint);

    const double gap = 32;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final Paint orbPaint = Paint()
      ..shader =
          const RadialGradient(
            colors: <Color>[Color(0x1816D5FF), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.35),
              radius: math.max(size.width, size.height) * 0.5,
            ),
          );
    canvas.drawRect(Offset.zero & size, orbPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AuthCornerBrackets extends StatelessWidget {
  const _AuthCornerBrackets();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              _Bracket(alignment: Alignment.topLeft),
              _Bracket(alignment: Alignment.topRight),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              _Bracket(alignment: Alignment.bottomLeft),
              _Bracket(alignment: Alignment.bottomRight),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bracket extends StatelessWidget {
  const _Bracket({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final bool isTop = alignment.y < 0;
    final bool isLeft = alignment.x < 0;
    const Color bracketColor = Color(0xFF16D5FF);

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? BorderSide(color: bracketColor.withValues(alpha: 0.6), width: 3)
              : BorderSide.none,
          bottom: !isTop
              ? BorderSide(color: bracketColor.withValues(alpha: 0.6), width: 3)
              : BorderSide.none,
          left: isLeft
              ? BorderSide(color: bracketColor.withValues(alpha: 0.6), width: 3)
              : BorderSide.none,
          right: !isLeft
              ? BorderSide(color: bracketColor.withValues(alpha: 0.6), width: 3)
              : BorderSide.none,
        ),
      ),
    );
  }
}
