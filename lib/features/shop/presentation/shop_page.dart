import 'package:flutter/material.dart';

import '../../../shared/widgets/feature_placeholder.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      title: 'Shop',
      description:
          'Cosmetics, boosters, bundles, and live-ops content are isolated in this module.',
      icon: Icons.shopping_bag,
    );
  }
}
