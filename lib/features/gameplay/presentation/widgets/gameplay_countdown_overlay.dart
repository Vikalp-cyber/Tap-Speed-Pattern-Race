import 'package:flutter/material.dart';

import '../models/game_demo_sequence.dart';
import 'gameplay_panel.dart';
import 'gameplay_tokens.dart';

class GameplayCountdownOverlay extends StatelessWidget {
  const GameplayCountdownOverlay({
    required this.step,
    required this.popScale,
    required this.rippleController,
    super.key,
  });

  final GameDemoStep step;
  final Animation<double> popScale;
  final AnimationController rippleController;

  @override
  Widget build(BuildContext context) {
    final bool isGo = step.countdownValue == 0;

    return ColoredBox(
      color: gameplayBg.withValues(alpha: 0.88),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: gameplayBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: gameplayBlue.withValues(alpha: 0.28),
                    ),
                  ),
                  child: const Text(
                    'MATCH STARTING',
                    style: TextStyle(
                      fontSize: 11,
                      color: gameplayBlue,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.2,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            for (int index = 0; index < 3; index += 1)
                              _StaggeredRipple(
                                controller: rippleController,
                                delay: index * 0.4,
                              ),
                            Container(
                              width: 216,
                              height: 216,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: <Color>[
                                    gameplayBlue.withValues(alpha: 0.14),
                                    gameplayPurple.withValues(alpha: 0.08),
                                    Colors.transparent,
                                  ],
                                ),
                                border: Border.all(
                                  color: gameplayBlue.withValues(alpha: 0.22),
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: gameplayBlue.withValues(alpha: 0.16),
                                    blurRadius: 30,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 156,
                              height: 156,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: <Color>[
                                    gameplayPanelElevated,
                                    gameplayPanel,
                                  ],
                                ),
                                border: Border.all(
                                  color: gameplayBlue.withValues(alpha: 0.28),
                                  width: 1.6,
                                ),
                              ),
                            ),
                            ScaleTransition(
                              scale: popScale,
                              child: isGo
                                  ? ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                          colors: <Color>[
                                            gameplayBlue,
                                            gameplayPurple,
                                            gameplayGreen,
                                          ],
                                        ).createShader(bounds);
                                      },
                                      blendMode: BlendMode.srcIn,
                                      child: const Text(
                                        'GO!',
                                        style: TextStyle(
                                          fontSize: 78,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 6,
                                          color: gameplayWhite,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      '${step.countdownValue}',
                                      style: TextStyle(
                                        fontSize: 138,
                                        fontWeight: FontWeight.w900,
                                        color: gameplayWhite,
                                        height: 1,
                                        shadows: <Shadow>[
                                          Shadow(
                                            color: gameplayBlue.withValues(
                                              alpha: 0.8,
                                            ),
                                            blurRadius: 32,
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'GET READY',
                        style: TextStyle(
                          fontSize: 13,
                          color: gameplayMuted,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Three players synced. Sequence feed is about to unlock.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: gameplayDim,
                          fontSize: 11,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GameplayPanel(
                accentColor: gameplayBlue,
                child: const Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'TRIO LOCKUP',
                            style: TextStyle(
                              fontSize: 10,
                              color: gameplayDim,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.8,
                            ),
                          ),
                        ),
                        Text(
                          'LIVE FEED',
                          style: TextStyle(
                            fontSize: 10,
                            color: gameplayBlue,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: _MatchAvatar(
                            name: 'YOU',
                            role: 'PLAYER 1',
                            color: gameplayBlue,
                            isYou: true,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _MatchAvatar(
                            name: 'NightOwl',
                            role: 'PLAYER 2',
                            color: gameplayPurple,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _MatchAvatar(
                            name: 'FastFin',
                            role: 'PLAYER 3',
                            color: gameplayAmber,
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
  }
}

class _StaggeredRipple extends StatelessWidget {
  const _StaggeredRipple({required this.controller, required this.delay});

  final AnimationController controller;
  final double delay;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final double t = (controller.value + delay) % 1.0;
        final double scale = 0.58 + (t * 1.9);
        final double opacity = (1.0 - t) * 0.45;
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity.clamp(0, 1),
            child: Container(
              width: 138,
              height: 138,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: gameplayBlue.withValues(alpha: 0.75),
                  width: 1.4,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MatchAvatar extends StatelessWidget {
  const _MatchAvatar({
    required this.name,
    required this.role,
    required this.color,
    this.isYou = false,
  });

  final String name;
  final String role;
  final Color color;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[color, color.withValues(alpha: 0.45)],
            ),
            border: Border.all(
              color: isYou ? color : color.withValues(alpha: 0.4),
              width: isYou ? 2 : 1.2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: color.withValues(alpha: isYou ? 0.30 : 0.16),
                blurRadius: 16,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1,
            color: isYou ? gameplayWhite : gameplayMuted,
            fontWeight: isYou ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          role,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 9,
            color: gameplayDim,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
