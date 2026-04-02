import 'package:flutter/material.dart';

import '../models/game_demo_sequence.dart';
import 'gameplay_tokens.dart';

class GameplayGridBackground extends StatelessWidget {
  const GameplayGridBackground({super.key});

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
              colors: <Color>[gameplayBg, Color(0xFF091427), gameplayBg],
            ),
          ),
        ),
        const Positioned.fill(child: CustomPaint(painter: _GridPainter())),
        Positioned(
          top: -120,
          right: -68,
          child: _BackgroundGlow(
            size: 300,
            color: gameplayBlue.withValues(alpha: 0.14),
          ),
        ),
        Positioned(
          top: 120,
          left: -100,
          child: _BackgroundGlow(
            size: 260,
            color: gameplayPurple.withValues(alpha: 0.14),
          ),
        ),
        Positioned(
          bottom: -150,
          left: 0,
          right: 0,
          child: Center(
            child: _BackgroundGlow(
              size: 360,
              color: gameplayBlueDeep.withValues(alpha: 0.12),
            ),
          ),
        ),
      ],
    );
  }
}

class GameplayAmbientGlow extends StatelessWidget {
  const GameplayAmbientGlow({required this.phase, super.key});

  final GameDemoPhase phase;

  @override
  Widget build(BuildContext context) {
    final (Color topColor, Color bottomColor) = switch (phase) {
      GameDemoPhase.failure => (
        gameplayRed.withValues(alpha: 0.14),
        gameplayRed.withValues(alpha: 0.08),
      ),
      GameDemoPhase.levelUp => (
        gameplayAmber.withValues(alpha: 0.15),
        gameplayBlue.withValues(alpha: 0.08),
      ),
      GameDemoPhase.victory => (
        gameplayAmber.withValues(alpha: 0.18),
        gameplayBlue.withValues(alpha: 0.10),
      ),
      GameDemoPhase.countdown => (
        gameplayBlue.withValues(alpha: 0.10),
        gameplayPurple.withValues(alpha: 0.08),
      ),
      GameDemoPhase.pattern => (
        gameplayBlue.withValues(alpha: 0.08),
        gameplayBlueDeep.withValues(alpha: 0.08),
      ),
      GameDemoPhase.input => (
        gameplayGreen.withValues(alpha: 0.10),
        gameplayBlue.withValues(alpha: 0.06),
      ),
    };

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.32),
                radius: 1.15,
                colors: <Color>[topColor, Colors.transparent],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: <Color>[bottomColor, Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = gameplayBlue.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 36) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 36) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final Paint diagonalPaint = Paint()
      ..color = gameplayBlue.withValues(alpha: 0.028)
      ..strokeWidth = 1.2;
    const double diagonalGap = 70;
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

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow({required this.size, required this.color});

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
