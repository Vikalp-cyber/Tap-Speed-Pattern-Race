import 'package:flutter/material.dart';

import '../models/game_demo_sequence.dart';
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
      color: gameplayBg.withValues(alpha: 0.90),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          for (int index = 0; index < 3; index += 1)
            _StaggeredRipple(controller: rippleController, delay: index * 0.4),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: gameplayBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: gameplayBlue.withValues(alpha: 0.3),
                  ),
                ),
                child: const Text(
                  'MATCH STARTING',
                  style: TextStyle(
                    fontSize: 11,
                    color: gameplayBlue,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 40),
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
                            fontSize: 80,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 6,
                            color: gameplayWhite,
                          ),
                        ),
                      )
                    : Text(
                        '${step.countdownValue}',
                        style: TextStyle(
                          fontSize: 160,
                          fontWeight: FontWeight.w900,
                          color: gameplayWhite,
                          height: 1,
                          shadows: <Shadow>[
                            Shadow(
                              color: gameplayBlue.withValues(alpha: 0.9),
                              blurRadius: 40,
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 40),
              const Text(
                'GET READY',
                style: TextStyle(
                  fontSize: 13,
                  color: gameplayMuted,
                  letterSpacing: 5,
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  _MatchAvatar(name: 'YOU', color: gameplayBlue, isYou: true),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 11,
                        color: gameplayDim,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _MatchAvatar(name: 'NightOwl', color: gameplayPurple),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 11,
                        color: gameplayDim,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _MatchAvatar(name: 'FastFin', color: gameplayAmber),
                ],
              ),
            ],
          ),
        ],
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
        final double scale = 0.6 + (t * 1.6);
        final double opacity = (1.0 - t) * 0.5;
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity.clamp(0, 1),
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: gameplayBlue, width: 1.5),
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
    required this.color,
    this.isYou = false,
  });

  final String name;
  final Color color;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[color, color.withValues(alpha: 0.5)],
            ),
            border: Border.all(
              color: isYou ? color : color.withValues(alpha: 0.4),
              width: isYou ? 2 : 1,
            ),
            boxShadow: isYou
                ? <BoxShadow>[
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 14,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1,
            color: isYou ? gameplayWhite : gameplayMuted,
            fontWeight: isYou ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
