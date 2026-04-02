import 'package:flutter/material.dart';

import '../widgets/shop_tokens.dart';

enum ShopTabSection { coins, powerUps }

class ShopCoinOffer {
  const ShopCoinOffer({
    required this.amountLabel,
    required this.subtitle,
    required this.priceLabel,
    this.isFeatured = false,
    this.isFree = false,
    this.badgeLabel,
  });

  final String amountLabel;
  final String subtitle;
  final String priceLabel;
  final bool isFeatured;
  final bool isFree;
  final String? badgeLabel;
}

class ShopPowerUpOffer {
  const ShopPowerUpOffer({
    required this.icon,
    required this.accent,
    required this.name,
    required this.description,
    required this.costLabel,
    this.ownedCount = 0,
  });

  final IconData icon;
  final Color accent;
  final String name;
  final String description;
  final String costLabel;
  final int ownedCount;
}

abstract final class ShopCatalog {
  static const String coinsBalance = '2,450';
  static const String energyBalance = '15';
  static const String removeAdsPrice = '\$4.99';

  static const List<ShopCoinOffer> coinOffers = <ShopCoinOffer>[
    ShopCoinOffer(
      amountLabel: '100',
      subtitle: 'Coins',
      priceLabel: 'FREE',
      isFree: true,
    ),
    ShopCoinOffer(
      amountLabel: '500',
      subtitle: '',
      priceLabel: '\$0.99',
      isFeatured: true,
      badgeLabel: 'POPULAR',
    ),
    ShopCoinOffer(amountLabel: '2000', subtitle: 'Coins', priceLabel: '\$2.99'),
  ];

  static const List<ShopPowerUpOffer> coinTabPowerUps = <ShopPowerUpOffer>[
    ShopPowerUpOffer(
      icon: Icons.shield_rounded,
      accent: shopBlue,
      name: 'HINT',
      description: 'Reveal one tile',
      costLabel: '50',
    ),
    ShopPowerUpOffer(
      icon: Icons.bolt_rounded,
      accent: shopPurple,
      name: 'FREEZE OPPONENT',
      description: 'Freeze for 3s',
      costLabel: '100',
    ),
    ShopPowerUpOffer(
      icon: Icons.access_time_rounded,
      accent: shopGreen,
      name: 'SLOW TIME',
      description: 'Half speed for 5s',
      costLabel: '150',
    ),
  ];

  static const List<ShopPowerUpOffer> allPowerUps = <ShopPowerUpOffer>[
    ShopPowerUpOffer(
      icon: Icons.shield_rounded,
      accent: shopBlue,
      name: 'HINT',
      description: 'Reveal one tile in the pattern',
      costLabel: '50',
      ownedCount: 3,
    ),
    ShopPowerUpOffer(
      icon: Icons.bolt_rounded,
      accent: shopPurple,
      name: 'FREEZE OPPONENT',
      description: 'Freeze opponent for 3 seconds',
      costLabel: '100',
      ownedCount: 1,
    ),
    ShopPowerUpOffer(
      icon: Icons.access_time_rounded,
      accent: shopGreen,
      name: 'SLOW TIME',
      description: 'Half speed pattern for 5 seconds',
      costLabel: '150',
    ),
    ShopPowerUpOffer(
      icon: Icons.remove_red_eye,
      accent: shopAmber,
      name: 'PEEK',
      description: 'Sneak a 1s look before the pattern hides',
      costLabel: '200',
      ownedCount: 2,
    ),
    ShopPowerUpOffer(
      icon: Icons.refresh_rounded,
      accent: shopBlue,
      name: 'SECOND CHANCE',
      description: 'Survive one wrong tap per round',
      costLabel: '300',
    ),
  ];
}
