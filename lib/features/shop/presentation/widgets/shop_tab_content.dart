import 'package:flutter/material.dart';

import '../models/shop_catalog.dart';
import 'shop_coin_pack_card.dart';
import 'shop_power_up_tile.dart';
import 'shop_remove_ads_card.dart';
import 'shop_tokens.dart';

class CoinsTabContent extends StatelessWidget {
  const CoinsTabContent({
    required this.onBuyCoinPack,
    required this.onBuyPowerUp,
    required this.onBuyRemoveAds,
    super.key,
  });

  final ValueChanged<ShopCoinOffer> onBuyCoinPack;
  final ValueChanged<ShopPowerUpOffer> onBuyPowerUp;
  final VoidCallback onBuyRemoveAds;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool stackCards = constraints.maxWidth < 360;

            if (stackCards) {
              return Column(
                children: ShopCatalog.coinOffers.map((ShopCoinOffer offer) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ShopCoinPackCard(
                      offer: offer,
                      onTap: () => onBuyCoinPack(offer),
                    ),
                  );
                }).toList(),
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<Widget>.generate(ShopCatalog.coinOffers.length, (
                int index,
              ) {
                final ShopCoinOffer offer = ShopCatalog.coinOffers[index];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : 5,
                      right: index == ShopCatalog.coinOffers.length - 1 ? 0 : 5,
                    ),
                    child: ShopCoinPackCard(
                      offer: offer,
                      onTap: () => onBuyCoinPack(offer),
                    ),
                  ),
                );
              }),
            );
          },
        ),
        const SizedBox(height: 28),
        const Text(
          '[ POWER-UPS ]',
          style: TextStyle(
            color: shopBlue,
            fontWeight: FontWeight.w800,
            fontSize: 10,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 14),
        ...ShopCatalog.coinTabPowerUps.map((ShopPowerUpOffer offer) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ShopPowerUpTile(
              offer: offer,
              onTap: () => onBuyPowerUp(offer),
            ),
          );
        }),
        const SizedBox(height: 24),
        ShopRemoveAdsCard(
          priceLabel: ShopCatalog.removeAdsPrice,
          onTap: onBuyRemoveAds,
        ),
      ],
    );
  }
}

class PowerUpsTabContent extends StatelessWidget {
  const PowerUpsTabContent({required this.onBuyPowerUp, super.key});

  final ValueChanged<ShopPowerUpOffer> onBuyPowerUp;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          '[ YOUR POWER-UPS ]',
          style: TextStyle(
            color: shopBlue,
            fontWeight: FontWeight.w800,
            fontSize: 10,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 14),
        ...ShopCatalog.allPowerUps.map((ShopPowerUpOffer offer) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ShopPowerUpTile(
              offer: offer,
              onTap: () => onBuyPowerUp(offer),
              showOwnedBadge: true,
            ),
          );
        }),
      ],
    );
  }
}
