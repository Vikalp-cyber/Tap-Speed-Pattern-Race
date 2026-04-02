import 'package:flutter/material.dart';

import 'gameplay_tokens.dart';

class GameplayPanel extends StatelessWidget {
  const GameplayPanel({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.accentColor = gameplayBlue,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        gradient: gameplayPanelGradient,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: accentColor.withValues(alpha: 0.28)),
        ),
        shadows: <BoxShadow>[
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 22,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}
