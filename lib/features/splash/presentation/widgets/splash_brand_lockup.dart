import 'dart:math' as math;

import 'package:flutter/material.dart';

class SplashBrandLockup extends StatelessWidget {
  const SplashBrandLockup({required this.progress, super.key});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final double reveal = Curves.easeOutBack.transform(
      ((progress - 0.12) / 0.58).clamp(0, 1),
    );
    final double opacity = Curves.easeIn.transform(
      ((progress - 0.06) / 0.42).clamp(0, 1),
    );
    final double glowPulse = 0.75 + (math.sin(progress * math.pi * 5) * 0.18);

    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(0, 38 * (1 - reveal)),
        child: Transform.scale(
          scale: 0.92 + (0.08 * reveal),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xFFE5EEFF),
                      Color(0xFF8FF8FF),
                      Color(0xFF16D5FF),
                    ],
                    stops: <double>[0.0, 0.5, 1.0],
                  ).createShader(bounds);
                },
                child: Text(
                  'TAP SPEED',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.5,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        color: const Color(
                          0xFF16D5FF,
                        ).withValues(alpha: 0.3 * glowPulse),
                        blurRadius: 24,
                      ),
                      Shadow(
                        color: Colors.white.withValues(alpha: 0.2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.6),
                  border: Border.all(
                    color: const Color(0xFF4FAEFF).withValues(alpha: 0.3),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'PATTERN RACE',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    letterSpacing: 6.0,
                    color: const Color(0xFF7AF0FF),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
