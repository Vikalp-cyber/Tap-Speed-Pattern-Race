import 'package:flutter/material.dart';

import 'gameplay_tokens.dart';

enum GameplayActionButtonVariant { primary, outline }

class GameplayActionButton extends StatelessWidget {
  const GameplayActionButton({
    required this.label,
    required this.onTap,
    super.key,
    this.variant = GameplayActionButtonVariant.primary,
    this.accentColor = gameplayBlue,
  });

  final String label;
  final VoidCallback onTap;
  final GameplayActionButtonVariant variant;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = variant == GameplayActionButtonVariant.primary;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: isPrimary ? null : gameplayPanel,
          gradient: isPrimary
              ? LinearGradient(
                  colors: <Color>[
                    accentColor,
                    accentColor == gameplayAmber
                        ? const Color(0xFFFFD24F)
                        : gameplayBlueDeep,
                  ],
                )
              : null,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isPrimary
                  ? Colors.transparent
                  : accentColor.withValues(alpha: 0.4),
              width: 1.4,
            ),
          ),
          shadows: <BoxShadow>[
            if (isPrimary)
              BoxShadow(
                color: accentColor.withValues(alpha: 0.22),
                blurRadius: 18,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isPrimary ? gameplayBg : gameplayWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
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
