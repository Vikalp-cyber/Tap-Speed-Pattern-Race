import 'package:flutter/material.dart';

import '../models/game_demo_sequence.dart';
import 'gameplay_action_button.dart';
import 'gameplay_panel.dart';
import 'gameplay_tokens.dart';

class GameplayFailureOverlay extends StatelessWidget {
  const GameplayFailureOverlay({
    required this.step,
    required this.pulseAnimation,
    required this.onContinue,
    required this.onRestart,
    super.key,
  });

  final GameDemoStep step;
  final Animation<double> pulseAnimation;
  final VoidCallback onContinue;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final int wrongStep = step.tapPosition ?? 2;

    return ColoredBox(
      color: gameplayBg.withValues(alpha: 0.90),
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
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: gameplayRed.withValues(alpha: 0.14),
                          border: Border.all(color: gameplayRed, width: 2),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: gameplayRed.withValues(alpha: 0.36),
                              blurRadius: 32,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: gameplayRed,
                          size: 42,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'WRONG PATTERN!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: gameplayRed,
                          letterSpacing: 2,
                          shadows: <Shadow>[
                            Shadow(
                              color: gameplayRed.withValues(alpha: 0.5),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'One tile broke the chain. Study the sequence, then jump back in before momentum slips away.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: gameplayMuted,
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _PulseWarning(
                        color: gameplayRed,
                        label: 'OPPONENT IS GAINING GROUND',
                        pulseAnimation: pulseAnimation,
                      ),
                      const SizedBox(height: 18),
                      GameplayPanel(
                        accentColor: gameplayRed,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Text(
                              'CORRECT PATTERN WAS',
                              style: TextStyle(
                                fontSize: 10,
                                color: gameplayDim,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 10,
                              runSpacing: 10,
                              children: List<Widget>.generate(
                                step.pattern.length,
                                (int index) {
                                  final int tileIndex = step.pattern[index];
                                  final GameDemoTile tile =
                                      GameDemoSequence.tiles[tileIndex];
                                  final bool isWrong = index == wrongStep;
                                  final bool isDone = index < wrongStep;
                                  return _ReplayTile(
                                    tile: tile,
                                    order: index + 1,
                                    isWrong: isWrong,
                                    isDone: isDone,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'TAPPED WRONG ON STEP ${wrongStep + 1}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 10,
                                color: gameplayRed,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GameplayPanel(
                        accentColor: gameplayPurple,
                        child: const Row(
                          children: <Widget>[
                            Expanded(
                              child: _FailureMetric(
                                label: 'ROUND',
                                value: '01',
                                accent: gameplayBlue,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _FailureMetric(
                                label: 'MISTAKE',
                                value: 'SYNC',
                                accent: gameplayRed,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _FailureMetric(
                                label: 'RECOVER',
                                value: 'FAST',
                                accent: gameplayGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      GameplayActionButton(
                        label: 'WATCH AD - CONTINUE',
                        onTap: onContinue,
                        accentColor: gameplayBlue,
                      ),
                      const SizedBox(height: 12),
                      GameplayActionButton(
                        label: 'RESTART MATCH',
                        onTap: onRestart,
                        variant: GameplayActionButtonVariant.outline,
                        accentColor: gameplayRed,
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

class _ReplayTile extends StatelessWidget {
  const _ReplayTile({
    required this.tile,
    required this.order,
    required this.isWrong,
    required this.isDone,
  });

  final GameDemoTile tile;
  final int order;
  final bool isWrong;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                tile.color.withValues(alpha: 0.96),
                tile.color.withValues(alpha: 0.68),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isWrong ? gameplayRed : tile.color.withValues(alpha: 0.28),
              width: isWrong ? 2 : 1.1,
            ),
            boxShadow: isDone
                ? <BoxShadow>[BoxShadow(color: tile.glow, blurRadius: 12)]
                : null,
          ),
          foregroundDecoration: !isDone && !isWrong
              ? BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(14),
                )
              : null,
        ),
        const SizedBox(height: 6),
        Text(
          '$order',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: isWrong ? gameplayRed : gameplayDim,
          ),
        ),
      ],
    );
  }
}

class _PulseWarning extends StatelessWidget {
  const _PulseWarning({
    required this.color,
    required this.label,
    required this.pulseAnimation,
  });

  final Color color;
  final String label;
  final Animation<double> pulseAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (_, __) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
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
                  color: color.withValues(alpha: pulseAnimation.value),
                  shape: BoxShape.circle,
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

class _FailureMetric extends StatelessWidget {
  const _FailureMetric({
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
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: gameplayDim,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
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
