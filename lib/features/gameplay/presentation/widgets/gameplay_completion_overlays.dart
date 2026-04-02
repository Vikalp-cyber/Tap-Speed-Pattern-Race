import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/game_demo_sequence.dart';
import 'gameplay_action_button.dart';
import 'gameplay_panel.dart';
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
      color: gameplayBg.withValues(alpha: 0.90),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'ROUND COMPLETE',
                        style: TextStyle(
                          fontSize: 12,
                          color: gameplayAmber,
                          fontWeight: FontWeight.w800,
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
                              width: 184,
                              height: 184,
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 168,
                                    height: 168,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: <Color>[
                                          gameplayAmber.withValues(alpha: 0.16),
                                          gameplayBlue.withValues(alpha: 0.04),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  for (int index = 0; index < 6; index += 1)
                                    Transform.rotate(
                                      angle: index * math.pi / 3,
                                      child: Transform.translate(
                                        offset: const Offset(0, -70),
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: gameplayAmber,
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                color: gameplayAmber.withValues(
                                                  alpha: 0.8,
                                                ),
                                                blurRadius: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  Container(
                                    width: 118,
                                    height: 118,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: <Color>[
                                          gameplayAmber.withValues(alpha: 0.28),
                                          gameplayAmber.withValues(alpha: 0.08),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: gameplayAmber.withValues(
                                          alpha: 0.65,
                                        ),
                                        width: 2,
                                      ),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: gameplayAmber.withValues(
                                            alpha: 0.32,
                                          ),
                                          blurRadius: 34,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Text(
                                          'LVL',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: gameplayAmber,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                        Text(
                                          '${step.level}',
                                          style: const TextStyle(
                                            fontSize: 42,
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
                      const SizedBox(height: 10),
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: <Color>[
                              gameplayAmber,
                              Color(0xFFFFD24F),
                              gameplayWhite,
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcIn,
                        child: const Text(
                          'LEVEL UP!',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.5,
                            color: gameplayWhite,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Reflex chain upgraded. The next round pushes a longer sequence at a higher tempo.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: gameplayMuted,
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _SignalPill(
                        pulseAnimation: pulseAnimation,
                        color: gameplayAmber,
                        label: 'SPEED BONUS +10%',
                      ),
                      const SizedBox(height: 18),
                      GameplayPanel(
                        accentColor: gameplayAmber,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              'NEXT ROUND BOOSTS',
                              style: TextStyle(
                                fontSize: 10,
                                color: gameplayDim,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.2,
                              ),
                            ),
                            SizedBox(height: 16),
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
              ),
            );
          },
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
      color: gameplayBg.withValues(alpha: 0.92),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: floatAnimation,
                        builder: (_, __) {
                          return Transform.translate(
                            offset: Offset(0, floatAnimation.value),
                            child: Container(
                              width: 118,
                              height: 118,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: <Color>[
                                    gameplayAmber.withValues(alpha: 0.34),
                                    gameplayAmber.withValues(alpha: 0.08),
                                  ],
                                ),
                                border: Border.all(
                                  color: gameplayAmber.withValues(alpha: 0.55),
                                  width: 2,
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: gameplayAmber.withValues(alpha: 0.3),
                                    blurRadius: 34,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.workspace_premium_rounded,
                                color: gameplayAmber,
                                size: 58,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return gameplayVictoryGradient.createShader(bounds);
                        },
                        blendMode: BlendMode.srcIn,
                        child: const Text(
                          'VICTORY',
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                            color: gameplayWhite,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You outran the lobby and claimed the round. The pattern feed is yours.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: gameplayMuted,
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 18),
                      GameplayPanel(
                        accentColor: gameplayAmber,
                        child: const Row(
                          children: <Widget>[
                            Expanded(
                              child: _VictoryMetric(
                                label: 'COINS',
                                value: '+140',
                                accent: gameplayAmber,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _VictoryMetric(
                                label: 'XP',
                                value: '+320',
                                accent: gameplayBlue,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _VictoryMetric(
                                label: 'STREAK',
                                value: 'x3',
                                accent: gameplayGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GameplayPanel(
                        accentColor: gameplayBlue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Text(
                              'FINAL STANDINGS',
                              style: TextStyle(
                                fontSize: 10,
                                color: gameplayDim,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.3,
                              ),
                            ),
                            const SizedBox(height: 16),
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
                      const SizedBox(height: 18),
                      GameplayActionButton(
                        label: 'PLAY AGAIN',
                        onTap: onPlayAgain,
                        accentColor: gameplayBlue,
                      ),
                      const SizedBox(height: 12),
                      GameplayActionButton(
                        label: 'RETURN TO LOBBY',
                        onTap: onReturnToLobby,
                        variant: GameplayActionButtonVariant.outline,
                        accentColor: gameplayBlue,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
                  fontWeight: FontWeight.w800,
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
              fontWeight: FontWeight.w700,
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
            : gameplayPanelElevated.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight
              ? gameplayBlue.withValues(alpha: 0.38)
              : gameplaySoftBorder,
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

class _VictoryMetric extends StatelessWidget {
  const _VictoryMetric({
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: gameplayDim,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: accent,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
