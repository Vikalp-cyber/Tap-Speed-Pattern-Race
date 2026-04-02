import 'package:flutter/material.dart';

import '../models/game_demo_sequence.dart';
import 'gameplay_tokens.dart';

class GameplayGridBackground extends StatelessWidget {
  const GameplayGridBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _GridPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class GameplayAmbientGlow extends StatelessWidget {
  const GameplayAmbientGlow({required this.phase, super.key});

  final GameDemoPhase phase;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (phase) {
      case GameDemoPhase.failure:
        color = gameplayRed.withValues(alpha: 0.14);
      case GameDemoPhase.victory:
        color = gameplayAmber.withValues(alpha: 0.18);
      case GameDemoPhase.levelUp:
        color = gameplayAmber.withValues(alpha: 0.14);
      case GameDemoPhase.countdown:
      case GameDemoPhase.pattern:
      case GameDemoPhase.input:
        return const SizedBox.shrink();
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.3),
          radius: 1.2,
          colors: <Color>[color, Colors.transparent],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}
