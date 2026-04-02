import 'package:flutter/material.dart';

class SplashLoadingBar extends StatelessWidget {
  const SplashLoadingBar({required this.progress, super.key});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final int percentage = (progress * 100).round().clamp(0, 100);
    final double fill = (0.02 + (progress * 0.98)).clamp(0, 1);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'SYS.INIT //',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 9,
                    color: const Color(0xFF4FAEFF),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'LOADING $percentage%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 9,
                  color: const Color(0xFFE5EEFF),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 4,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF16324C)),
              color: const Color(0xFF040A12),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: fill,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF16D5FF),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFF3DE3FF).withValues(alpha: 0.6),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
