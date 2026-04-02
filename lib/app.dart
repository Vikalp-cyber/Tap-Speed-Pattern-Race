import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/pages/auth_entry_page.dart';
import 'features/auth/presentation/pages/profile_page.dart';
import 'features/leaderboard/presentation/leaderboard_page.dart';
import 'features/matchmaking/presentation/lobby_page.dart';
import 'features/shop/presentation/shop_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';

class TapSpeedApp extends StatelessWidget {
  const TapSpeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const AppBootstrapPage(),
    );
  }
}

class AppBootstrapPage extends ConsumerStatefulWidget {
  const AppBootstrapPage({super.key});

  @override
  ConsumerState<AppBootstrapPage> createState() => _AppBootstrapPageState();
}

class _AppBootstrapPageState extends ConsumerState<AppBootstrapPage> {
  bool _showSplash = true;

  void _handleSplashCompleted() {
    if (!mounted || !_showSplash) {
      return;
    }

    setState(() => _showSplash = false);
  }

  @override
  Widget build(BuildContext context) {
    final AuthState authState = ref.watch(authControllerProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 650),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.985, end: 1).animate(animation),
            child: child,
          ),
        );
      },
      child: _showSplash
          ? SplashPage(
              key: const ValueKey<String>('splash-page'),
              onCompleted: _handleSplashCompleted,
            )
          : authState.isAuthenticated
          ? const TapSpeedHomeShell(key: ValueKey<String>('home-shell'))
          : const AuthEntryPage(key: ValueKey<String>('auth-entry-page')),
    );
  }
}

class TapSpeedHomeShell extends StatefulWidget {
  const TapSpeedHomeShell({super.key});

  @override
  State<TapSpeedHomeShell> createState() => _TapSpeedHomeShellState();
}

class _TapSpeedHomeShellState extends State<TapSpeedHomeShell> {
  int _currentIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const LobbyPage(),
    const LeaderboardPage(),
    const ShopPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.shellGradient),
        child: SafeArea(
          bottom: false,
          child: IndexedStack(index: _currentIndex, children: _pages),
        ),
      ),
      bottomNavigationBar: _AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}

class _AppBottomNav extends StatelessWidget {
  const _AppBottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<IconData> _icons = <IconData>[
    Icons.home_rounded,
    Icons.emoji_events_rounded,
    Icons.shopping_cart_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFF040A1A),
          border: Border(top: BorderSide(color: Color(0x6616D5FF), width: 1.5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0x2216D5FF),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(_icons.length, (int index) {
            return _NavItem(
              icon: _icons[index],
              active: index == currentIndex,
              onTap: () => onTap(index),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: active
            ? ShapeDecoration(
                color: const Color(0xFF16D5FF).withValues(alpha: 0.15),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(
                    color: const Color(0xFF16D5FF).withValues(alpha: 0.8),
                  ),
                ),
                shadows: <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFF16D5FF).withValues(alpha: 0.5),
                    blurRadius: 14,
                  ),
                ],
              )
            : const ShapeDecoration(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
              ),
        child: Icon(
          icon,
          size: 26,
          color: active ? const Color(0xFFE5EEFF) : const Color(0xFF6B7280),
        ),
      ),
    );
  }
}
