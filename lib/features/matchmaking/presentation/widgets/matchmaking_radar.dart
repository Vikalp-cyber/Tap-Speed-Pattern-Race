import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../matchmaking_tokens.dart';
import 'matchmaking_player_card.dart';

class MatchmakingRadar extends StatelessWidget {
  const MatchmakingRadar({
    required this.sweepTurns,
    required this.pulseScales,
    required this.pulseOpacities,
    required this.playerName,
    super.key,
  });

  final Animation<double> sweepTurns;
  final List<Animation<double>> pulseScales;
  final List<Animation<double>> pulseOpacities;
  final String playerName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 340,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: 332,
            height: 332,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  matchmakingBlue.withValues(alpha: 0.10),
                  Colors.transparent,
                ],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: matchmakingBlue.withValues(alpha: 0.14),
                  blurRadius: 48,
                  spreadRadius: 6,
                ),
              ],
            ),
          ),
          Container(
            width: 318,
            height: 318,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: matchmakingBlue.withValues(alpha: 0.24),
              ),
            ),
          ),
          const _Ring(fraction: 1.00, opacity: 0.20),
          const _Ring(fraction: 0.75, opacity: 0.30),
          const _Ring(fraction: 0.50, opacity: 0.40),
          RotationTransition(
            turns: sweepTurns,
            child: CustomPaint(
              size: const Size(320, 320),
              painter: const _SweepPainter(),
            ),
          ),
          const _RadarTarget(
            alignment: Alignment(-0.46, -0.56),
            accent: matchmakingPurple,
            size: 11,
          ),
          const _RadarTarget(
            alignment: Alignment(0.60, -0.22),
            accent: matchmakingBlue,
            size: 9,
          ),
          const _RadarTarget(
            alignment: Alignment(0.22, 0.62),
            accent: matchmakingPurple,
            size: 8,
          ),
          for (int index = 0; index < pulseScales.length; index += 1)
            AnimatedBuilder(
              animation: Listenable.merge(<Listenable>[
                pulseScales[index],
                pulseOpacities[index],
              ]),
              builder: (_, __) {
                return Transform.scale(
                  scale: pulseScales[index].value,
                  child: Opacity(
                    opacity: pulseOpacities[index].value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: matchmakingBlue, width: 2),
                      ),
                    ),
                  ),
                );
              },
            ),
          MatchmakingPlayerCard(playerName: playerName),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.fraction, required this.opacity});

  final double fraction;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: fraction,
      heightFactor: fraction,
      child: Opacity(
        opacity: opacity,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: matchmakingBlue, width: 1),
          ),
        ),
      ),
    );
  }
}

class _SweepPainter extends CustomPainter {
  const _SweepPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        colors: <Color>[
          Colors.transparent,
          Colors.transparent,
          matchmakingBlue.withValues(alpha: 0.0),
          matchmakingBlue.withValues(alpha: 0.45),
        ],
        stops: const <double>[0.0, 0.65, 0.70, 1.0],
      ).createShader(rect);

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _SweepPainter oldDelegate) => false;
}

class _RadarTarget extends StatelessWidget {
  const _RadarTarget({
    required this.alignment,
    required this.accent,
    required this.size,
  });

  final Alignment alignment;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accent,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: accent.withValues(alpha: 0.55),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}
