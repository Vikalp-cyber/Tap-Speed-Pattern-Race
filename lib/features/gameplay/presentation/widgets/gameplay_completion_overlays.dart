import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/game_demo_sequence.dart';
import 'gameplay_tokens.dart';

class GameplayLevelUpOverlay extends StatelessWidget {
  const GameplayLevelUpOverlay({
    required this.step,
    required this.floatAnimation,
    required this.pulseAnimation,
    super.key,
  });

  final GameDemoStep step;
  final Animation<double> floatAnimation;
  final Animation<double> pulseAnimation;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: gameplayBg.withValues(alpha: 0.88),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'ROUND COMPLETE',
              style: TextStyle(
                fontSize: 12,
                color: gameplayAmber,
                letterSpacing: 5,
              ),
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(
              animation: floatAnimation,
              builder: (_, __) {
                return Transform.translate(
                  offset: Offset(0, floatAnimation.value),
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        for (int index = 0; index < 6; index += 1)
                          Transform.rotate(
                            angle: index * math.pi / 3,
                            child: Transform.translate(
                              offset: const Offset(0, -62),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: gameplayAmber,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: gameplayAmber.withValues(
                                        alpha: 0.9,
                                      ),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: <Color>[
                                gameplayAmber.withValues(alpha: 0.3),
                                gameplayAmber.withValues(alpha: 0.08),
                              ],
                            ),
                            border: Border.all(
                              color: gameplayAmber.withValues(alpha: 0.6),
                              width: 2,
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: gameplayAmber.withValues(alpha: 0.4),
                                blurRadius: 40,
                              ),
                              BoxShadow(
                                color: gameplayAmber.withValues(alpha: 0.15),
                                blurRadius: 80,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'LVL',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: gameplayAmber,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                '${step.level}',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: gameplayAmber,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: <Color>[
                    gameplayAmber,
                    Color(0xFFFBBF24),
                    Color(0xFFFDE68A),
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: const Text(
                'LEVEL UP!',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: gameplayWhite,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your reflex chain is getting faster. The next pattern will push harder.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.5, color: gameplayMuted),
            ),
            const SizedBox(height: 20),
            _SignalPill(
              pulseAnimation: pulseAnimation,
              color: gameplayAmber,
              label: 'SPEED BONUS +10%',
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: gameplayPanel,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: gameplayBorder),
              ),
              child: const Column(
                children: <Widget>[
                  Text(
                    'NEXT ROUND BOOSTS',
                    style: TextStyle(
                      fontSize: 10,
                      color: gameplayDim,
                      letterSpacing: 2.5,
                    ),
                  ),
                  SizedBox(height: 14),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _StatChip(
                          label: 'SEQUENCE',
                          value: '+1 TILE',
                          accent: gameplayBlue,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _StatChip(
                          label: 'TEMPO',
                          value: 'FASTER',
                          accent: gameplayGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameplayVictoryOverlay extends StatelessWidget {
  const GameplayVictoryOverlay({
    required this.step,
    required this.floatAnimation,
    required this.onPlayAgain,
    required this.onReturnToLobby,
    super.key,
  });

  final GameDemoStep step;
  final Animation<double> floatAnimation;
  final VoidCallback onPlayAgain;
  final VoidCallback onReturnToLobby;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: gameplayBg.withValues(alpha: 0.9),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: floatAnimation,
              builder: (_, __) {
                return Transform.translate(
                  offset: Offset(0, floatAnimation.value),
                  child: Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: <Color>[
                          gameplayAmber.withValues(alpha: 0.34),
                          gameplayAmber.withValues(alpha: 0.1),
                        ],
                      ),
                      border: Border.all(
                        color: gameplayAmber.withValues(alpha: 0.55),
                        width: 2,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: gameplayAmber.withValues(alpha: 0.35),
                          blurRadius: 36,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: gameplayAmber,
                      size: 56,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: <Color>[gameplayAmber, gameplayWhite, gameplayBlue],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: const Text(
                'VICTORY',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                  color: gameplayWhite,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You outran the lobby and claimed the round.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.5, color: gameplayMuted),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: gameplayPanel,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: gameplayBorder),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: gameplayBlue.withValues(alpha: 0.08),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  const Text(
                    'FINAL STANDINGS',
                    style: TextStyle(
                      fontSize: 10,
                      color: gameplayDim,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _ResultRow(
                    place: '1',
                    label: 'YOU',
                    value: '${step.yourProgress}%',
                    accent: gameplayBlue,
                    highlight: true,
                  ),
                  const SizedBox(height: 10),
                  _ResultRow(
                    place: '2',
                    label: GameDemoSequence.opponents[0],
                    value: '${step.opponentOneProgress}%',
                    accent: gameplayPurple,
                  ),
                  const SizedBox(height: 10),
                  _ResultRow(
                    place: '3',
                    label: GameDemoSequence.opponents[1],
                    value: '${step.opponentTwoProgress}%',
                    accent: gameplayAmber,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[gameplayBlue, gameplayPurple],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: gameplayBlue.withValues(alpha: 0.24),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onPlayAgain,
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'PLAY AGAIN',
                          style: TextStyle(
                            color: gameplayWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onReturnToLobby,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: gameplayBorder.withValues(alpha: 0.9),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'RETURN TO LOBBY',
                  style: TextStyle(
                    color: gameplayWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignalPill extends StatelessWidget {
  const _SignalPill({
    required this.pulseAnimation,
    required this.color,
    required this.label,
  });

  final Animation<double> pulseAnimation;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (_, __) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: pulseAnimation.value),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: color.withValues(alpha: pulseAnimation.value),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: gameplayMuted,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: accent,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.place,
    required this.label,
    required this.value,
    required this.accent,
    this.highlight = false,
  });

  final String place;
  final String label;
  final String value;
  final Color accent;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: highlight
            ? gameplayBlue.withValues(alpha: 0.14)
            : gameplayBorder.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight
              ? gameplayBlue.withValues(alpha: 0.4)
              : gameplayBorder,
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(
            place,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: accent,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
                color: highlight ? gameplayWhite : gameplayMuted,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}
