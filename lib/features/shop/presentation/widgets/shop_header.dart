import 'package:flutter/material.dart';

import '../models/shop_catalog.dart';
import 'shop_tokens.dart';

class ShopHeader extends StatelessWidget {
  const ShopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        decoration: const BoxDecoration(
          color: shopBg,
          border: Border(bottom: BorderSide(color: shopBorder)),
        ),
        child: Row(
          children: <Widget>[
            const Text(
              'SHOP',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: shopWhite,
                letterSpacing: 4,
              ),
            ),
            const Spacer(),
            const ShopCurrencyBadge(
              icon: Icons.monetization_on_rounded,
              iconColor: shopAmber,
              label: ShopCatalog.coinsBalance,
              labelColor: shopAmber,
            ),
            const SizedBox(width: 10),
            const ShopCurrencyBadge(
              icon: Icons.bolt_rounded,
              iconColor: shopPurple,
              label: ShopCatalog.energyBalance,
              labelColor: shopPurple,
            ),
          ],
        ),
      ),
    );
  }
}

class ShopCurrencyBadge extends StatelessWidget {
  const ShopCurrencyBadge({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.labelColor,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ShapeDecoration(
        color: shopPanel,
        shape: BeveledRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          side: BorderSide(color: iconColor.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}
