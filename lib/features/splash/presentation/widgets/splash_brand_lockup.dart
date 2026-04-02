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
              Text(
                'TAP SPEED',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.8,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      color: const Color(
                        0xFF7A96FF,
                      ).withValues(alpha: 0.16 * glowPulse),
                      blurRadius: 24,
                    ),
                    Shadow(
                      color: Colors.white.withValues(alpha: 0.18),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'PATTERN RACE',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  letterSpacing: 4.2,
                  color: const Color(0xFFAE8FFF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
