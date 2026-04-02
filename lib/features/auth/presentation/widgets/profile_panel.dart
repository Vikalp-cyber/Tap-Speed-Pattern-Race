import 'package:flutter/material.dart';

import 'profile_tokens.dart';

class ProfilePanel extends StatelessWidget {
  const ProfilePanel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.accentColor,
    this.gradient,
    this.borderRadius = 18,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? accentColor;
  final Gradient? gradient;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final Color resolvedAccent = accentColor ?? profileBlue;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient ?? profilePanelGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: accentColor == null
              ? profileBorder
              : resolvedAccent.withValues(alpha: 0.32),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
          if (accentColor != null)
            BoxShadow(
              color: resolvedAccent.withValues(alpha: 0.10),
              blurRadius: 20,
              spreadRadius: 1,
            ),
        ],
      ),
      child: child,
    );
  }
}
