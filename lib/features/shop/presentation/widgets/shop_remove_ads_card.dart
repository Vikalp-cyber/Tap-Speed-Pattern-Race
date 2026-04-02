import 'package:flutter/material.dart';

import 'shop_action_button.dart';
import 'shop_tokens.dart';

class ShopRemoveAdsCard extends StatelessWidget {
  const ShopRemoveAdsCard({
    required this.priceLabel,
    required this.onTap,
    super.key,
  });

  final String priceLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const ShapeDecoration(
        gradient: shopRemoveAdsGradient,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          side: BorderSide(color: shopBlue, width: 2),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            right: -16,
            top: -16,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: shopBlue.withValues(alpha: 0.2),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'REMOVE ADS',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: shopWhite,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Play uninterrupted forever.\nOne time purchase.',
                style: TextStyle(fontSize: 12, color: shopMuted, height: 1.5),
              ),
              const SizedBox(height: 16),
              ShopGradientButton(label: priceLabel, onTap: onTap),
            ],
          ),
        ],
      ),
    );
  }
}
