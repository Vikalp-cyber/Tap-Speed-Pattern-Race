import 'package:flutter/material.dart';

import '../models/shop_catalog.dart';
import 'shop_tokens.dart';

class ShopTabBar extends StatelessWidget {
  const ShopTabBar({
    required this.selectedTab,
    required this.onChanged,
    super.key,
  });

  final ShopTabSection selectedTab;
  final ValueChanged<ShopTabSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: shopBorder)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: <Widget>[
          _ShopTab(
            label: 'COINS',
            tab: ShopTabSection.coins,
            selectedTab: selectedTab,
            onTap: onChanged,
          ),
          const SizedBox(width: 24),
          _ShopTab(
            label: 'POWER-UPS',
            tab: ShopTabSection.powerUps,
            selectedTab: selectedTab,
            onTap: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ShopTab extends StatelessWidget {
  const _ShopTab({
    required this.label,
    required this.tab,
    required this.selectedTab,
    required this.onTap,
  });

  final String label;
  final ShopTabSection tab;
  final ShopTabSection selectedTab;
  final ValueChanged<ShopTabSection> onTap;

  bool get _isActive => tab == selectedTab;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(tab),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: ShapeDecoration(
            color: _isActive
                ? shopBlue.withValues(alpha: 0.1)
                : Colors.transparent,
            shape: BeveledRectangleBorder(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              side: BorderSide(
                color: _isActive
                    ? shopBlue.withValues(alpha: 0.5)
                    : Colors.transparent,
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: _isActive ? shopBlue : shopMuted,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
