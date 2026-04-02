import 'package:flutter/material.dart';

import '../models/shop_catalog.dart';
import 'shop_action_button.dart';
import 'shop_tokens.dart';

class ShopCoinPackCard extends StatelessWidget {
  const ShopCoinPackCard({required this.offer, required this.onTap, super.key});

  final ShopCoinOffer offer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(10, 18, 10, 12),
          decoration: ShapeDecoration(
            color: shopPanel,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: offer.isFeatured ? shopBlue : shopBorder,
                width: offer.isFeatured ? 2 : 1,
              ),
            ),
            shadows: offer.isFeatured
                ? <BoxShadow>[
                    BoxShadow(
                      color: shopBlue.withValues(alpha: 0.1),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _CoinIcon(
                size: offer.isFeatured ? 36 : 28,
                isFeatured: offer.isFeatured,
              ),
              const SizedBox(height: 8),
              Text(
                offer.amountLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: offer.isFeatured ? 18 : 13,
                  color: offer.isFeatured ? shopAmber : shopWhite,
                ),
              ),
              if (offer.subtitle.isNotEmpty) ...<Widget>[
                const SizedBox(height: 2),
                Text(
                  offer.subtitle,
                  style: const TextStyle(fontSize: 11, color: shopMuted),
                ),
              ],
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: offer.isFeatured
                    ? ShopGradientButton(
                        label: offer.priceLabel,
                        compact: true,
                        onTap: onTap,
                      )
                    : offer.isFree
                    ? ShopFlatButton(label: offer.priceLabel, onTap: onTap)
                    : ShopFlatButton(label: offer.priceLabel, onTap: onTap),
              ),
            ],
          ),
        ),
        if (offer.badgeLabel != null)
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: const ShapeDecoration(
                  color: shopBlue,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                ),
                child: Text(
                  offer.badgeLabel!,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: shopWhite,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CoinIcon extends StatelessWidget {
  const _CoinIcon({required this.size, required this.isFeatured});

  final double size;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Icon(
          Icons.monetization_on_rounded,
          color: shopAmber,
          size: size,
          shadows: isFeatured
              ? <Shadow>[
                  Shadow(
                    color: shopAmber.withValues(alpha: 0.5),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        if (!isFeatured && size < 30)
          const Positioned(
            right: -8,
            bottom: -4,
            child: Icon(
              Icons.monetization_on_rounded,
              color: shopAmber,
              size: 18,
            ),
          ),
      ],
    );
  }
}
