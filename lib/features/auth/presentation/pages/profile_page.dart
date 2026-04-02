import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';
import '../models/profile_showcase_data.dart';
import '../widgets/profile_background.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_panel.dart';
import '../widgets/profile_showcase_sections.dart';
import '../widgets/profile_tokens.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authControllerProvider);
    final String displayName = authState.session?.displayName ?? 'Player_X1';
    final String providerLabel =
        authState.session?.providerLabel ?? 'Guest Access';
    final ProfileShowcaseData data = ProfileShowcaseData.demo(
      displayName: displayName,
      providerLabel: providerLabel,
    );

    return ColoredBox(
      color: profileBg,
      child: Stack(
        children: <Widget>[
          const Positioned.fill(child: ProfileBackground()),
          Column(
            children: <Widget>[
              ProfileHeader(
                onBackTap: () {
                  Navigator.of(context).maybePop();
                },
                onSettingsTap: () {
                  _showAccountActions(context, ref, authState);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ProfileHeroSection(data: data),
                          ProfileXpCard(data: data),
                          const SizedBox(height: 16),
                          ProfileQuickStatsSection(data: data),
                          const SizedBox(height: 16),
                          ProfileBestPerformanceSection(data: data),
                          const SizedBox(height: 20),
                          ProfileAchievementsSection(data: data),
                          const SizedBox(height: 20),
                          ProfileRecentMatchesSection(data: data),
                          const SizedBox(height: 8),
                        ],
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

  void _showAccountActions(
    BuildContext context,
    WidgetRef ref,
    AuthState authState,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: profilePanelElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        final String displayName =
            authState.session?.displayName ?? 'Player_X1';
        final String providerLabel =
            authState.session?.providerLabel ?? 'Guest Access';

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: profileBorder,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: profileWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  providerLabel,
                  style: const TextStyle(fontSize: 12, color: profileMuted),
                ),
                const SizedBox(height: 18),
                const ProfilePanel(
                  accentColor: profileBlue,
                  child: Text(
                    'Profile stats are currently mocked for UI development. Real account progression and match history can plug into this screen later without changing the layout.',
                    style: TextStyle(
                      fontSize: 12,
                      color: profileMuted,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ref.read(authControllerProvider.notifier).signOut();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: profileRed.withValues(alpha: 0.45),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'SIGN OUT',
                      style: TextStyle(
                        color: profileRed,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
