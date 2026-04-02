import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class NeonPanel extends StatelessWidget {
  const NeonPanel({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(18),
    this.accentColor = AppTheme.neonCyan,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppTheme.panelColor.withValues(alpha: 0.96),
            const Color(0xFF08111C).withValues(alpha: 0.92),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withValues(alpha: 0.35)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accentColor.withValues(alpha: 0.15),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}
