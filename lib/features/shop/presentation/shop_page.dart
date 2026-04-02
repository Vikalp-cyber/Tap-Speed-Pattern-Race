import 'package:flutter/material.dart';

import 'models/shop_catalog.dart';
import 'widgets/shop_background.dart';
import 'widgets/shop_header.dart';
import 'widgets/shop_tab_bar.dart';
import 'widgets/shop_tab_content.dart';
import 'widgets/shop_tokens.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  ShopTabSection _selectedTab = ShopTabSection.coins;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: shopBg,
      child: Stack(
        children: <Widget>[
          const Positioned.fill(child: ShopBackground()),
          Column(
            children: <Widget>[
              const ShopHeader(),
              ShopTabBar(
                selectedTab: _selectedTab,
                onChanged: (ShopTabSection tab) {
                  setState(() => _selectedTab = tab);
                },
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: SingleChildScrollView(
                    key: ValueKey<ShopTabSection>(_selectedTab),
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: _selectedTab == ShopTabSection.coins
                            ? CoinsTabContent(
                                onBuyCoinPack: _handleCoinPackTap,
                                onBuyPowerUp: _handlePowerUpTap,
                                onBuyRemoveAds: _handleRemoveAdsTap,
                              )
                            : PowerUpsTabContent(
                                onBuyPowerUp: _handlePowerUpTap,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleCoinPackTap(ShopCoinOffer offer) {
    final String action = offer.isFree
        ? 'Free starter coins'
        : '${offer.amountLabel} coin pack';
    _showStoreMessage('$action checkout is ready for billing integration.');
  }

  void _handlePowerUpTap(ShopPowerUpOffer offer) {
    _showStoreMessage('${offer.name} purchase is ready for inventory wiring.');
  }

  void _handleRemoveAdsTap() {
    _showStoreMessage('Remove Ads checkout is ready for billing integration.');
  }

  void _showStoreMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: shopPanel, content: Text(message)),
    );
  }
}
