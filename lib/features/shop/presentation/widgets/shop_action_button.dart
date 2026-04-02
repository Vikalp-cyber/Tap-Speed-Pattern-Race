import 'package:flutter/material.dart';

import 'shop_tokens.dart';

class ShopGradientButton extends StatelessWidget {
  const ShopGradientButton({
    required this.label,
    required this.onTap,
    this.compact = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
        gradient: shopPrimaryGradient,
        shadows: <BoxShadow>[
          BoxShadow(
            color: shopBlue.withValues(alpha: 0.4),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 0 : 24,
              vertical: compact ? 8 : 10,
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: shopWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShopFlatButton extends StatelessWidget {
  const ShopFlatButton({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Ink(
          decoration: ShapeDecoration(
            color: shopBorder,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: SizedBox(
            height: 32,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: shopWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShopPricePill extends StatelessWidget {
  const ShopPricePill({required this.label, required this.onTap, super.key});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: const ShapeDecoration(
            color: shopBorder,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: shopWhite,
                ),
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.monetization_on_rounded,
                color: shopAmber,
                size: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
