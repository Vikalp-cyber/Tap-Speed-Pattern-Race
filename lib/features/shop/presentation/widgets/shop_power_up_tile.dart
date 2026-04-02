import 'package:flutter/material.dart';

import '../models/shop_catalog.dart';
import 'shop_action_button.dart';
import 'shop_tokens.dart';

class ShopPowerUpTile extends StatelessWidget {
  const ShopPowerUpTile({
    required this.offer,
    required this.onTap,
    this.showOwnedBadge = false,
    super.key,
  });

  final ShopPowerUpOffer offer;
  final VoidCallback onTap;
  final bool showOwnedBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: ShapeDecoration(
        color: shopPanel,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: shopBorder),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: showOwnedBadge ? 46 : 42,
            height: showOwnedBadge ? 46 : 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: showOwnedBadge
                  ? offer.accent.withValues(alpha: 0.12)
                  : shopBorder,
              border: showOwnedBadge
                  ? Border.all(color: offer.accent.withValues(alpha: 0.3))
                  : null,
            ),
            child: Icon(
              offer.icon,
              color: offer.accent,
              size: showOwnedBadge ? 22 : 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        offer.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: shopWhite,
                        ),
                      ),
                    ),
                    if (showOwnedBadge && offer.ownedCount > 0) ...<Widget>[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: offer.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'x${offer.ownedCount}',
                          style: TextStyle(
                            fontSize: 9,
                            color: offer.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  offer.description,
                  style: TextStyle(
                    fontSize: showOwnedBadge ? 11 : 12,
                    color: shopMuted,
                  ),
                ),
              ],
            ),
          ),
          ShopPricePill(label: offer.costLabel, onTap: onTap),
        ],
      ),
    );
  }
}
