import 'package:flutter/material.dart';

class SplashLoadingBar extends StatelessWidget {
  const SplashLoadingBar({required this.progress, super.key});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final int percentage = (progress * 100).round().clamp(0, 100);
    final double fill = (0.06 + (progress * 0.94)).clamp(0, 1);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 152),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 3,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFF16324C),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: fill,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: <Color>[Color(0xFF16D5FF), Color(0xFF7AF0FF)],
                        ),
                        borderRadius: BorderRadius.circular(99),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color(
                              0xFF3DE3FF,
                            ).withValues(alpha: 0.35),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'LOADING $percentage%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 8.2,
              color: const Color(0xFFE5EEFF),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
