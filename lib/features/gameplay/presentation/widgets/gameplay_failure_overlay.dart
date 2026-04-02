import 'package:flutter/material.dart';

import '../models/game_demo_sequence.dart';
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

    return Stack(
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: gameplayRed.withValues(alpha: 0.25),
                blurRadius: 80,
                spreadRadius: 40,
              ),
            ],
          ),
          child: const SizedBox.expand(),
        ),
        ColoredBox(
          color: gameplayBg.withValues(alpha: 0.88),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: gameplayRed.withValues(alpha: 0.15),
                    border: Border.all(color: gameplayRed, width: 2),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: gameplayRed.withValues(alpha: 0.5),
                        blurRadius: 36,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: gameplayRed,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 22),
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
                        color: gameplayRed.withValues(alpha: 0.7),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You tapped the wrong tile.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: gameplayDim,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: gameplayPanel,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: gameplayBorder),
                  ),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'CORRECT PATTERN WAS',
                        style: TextStyle(
                          fontSize: 10,
                          color: gameplayDim,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(step.pattern.length, (
                          int index,
                        ) {
                          final int tileIndex = step.pattern[index];
                          final GameDemoTile tile =
                              GameDemoSequence.tiles[tileIndex];
                          final bool isWrong = index == wrongStep;
                          final bool isDone = index < wrongStep;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: tile.color,
                                    borderRadius: BorderRadius.circular(10),
                                    border: isWrong
                                        ? Border.all(
                                            color: gameplayRed,
                                            width: 2,
                                          )
                                        : null,
                                    boxShadow: isDone
                                        ? <BoxShadow>[
                                            BoxShadow(
                                              color: tile.glow,
                                              blurRadius: 10,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  foregroundDecoration: !isDone && !isWrong
                                      ? BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.55,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isWrong ? gameplayRed : gameplayDim,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'TAPPED WRONG ON STEP ${wrongStep + 1}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: gameplayRed,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _PulseWarning(
                  color: gameplayRed,
                  label: 'OPPONENT IS GAINING GROUND',
                  pulseAnimation: pulseAnimation,
                ),
                const SizedBox(height: 24),
                _GradientButton(
                  label: 'WATCH AD - CONTINUE',
                  onTap: onContinue,
                ),
                const SizedBox(height: 12),
                _OutlineButton(label: 'RESTART MATCH', onTap: onRestart),
              ],
            ),
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

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[gameplayBlue, gameplayPurple],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: gameplayBlue.withValues(alpha: 0.25),
              blurRadius: 20,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
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
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: gameplayBorder.withValues(alpha: 0.9)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: gameplayWhite,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
