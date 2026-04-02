import 'package:flutter/material.dart';

import '../widgets/profile_tokens.dart';

class ProfileAchievement {
  const ProfileAchievement({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.unlocked,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool unlocked;
  final Color color;
}

class ProfileRecentMatch {
  const ProfileRecentMatch({
    required this.didWin,
    required this.opponent,
    required this.level,
    required this.coinDeltaLabel,
  });

  final bool didWin;
  final String opponent;
  final int level;
  final String coinDeltaLabel;
}

class ProfileStatChip {
  const ProfileStatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;
}

class ProfileShowcaseData {
  const ProfileShowcaseData({
    required this.displayName,
    required this.providerLabel,
    required this.title,
    required this.level,
    required this.matchesPlayed,
    required this.joinedLabel,
    required this.currentXp,
    required this.nextLevelXp,
    required this.quickStats,
    required this.bestPerformance,
    required this.achievements,
    required this.recentMatches,
  });

  final String displayName;
  final String providerLabel;
  final String title;
  final int level;
  final int matchesPlayed;
  final String joinedLabel;
  final int currentXp;
  final int nextLevelXp;
  final List<ProfileStatChip> quickStats;
  final List<ProfileStatChip> bestPerformance;
  final List<ProfileAchievement> achievements;
  final List<ProfileRecentMatch> recentMatches;

  int get unlockedAchievementCount {
    return achievements
        .where((ProfileAchievement item) => item.unlocked)
        .length;
  }

  static ProfileShowcaseData demo({
    required String displayName,
    required String providerLabel,
  }) {
    return ProfileShowcaseData(
      displayName: displayName,
      providerLabel: providerLabel,
      title: 'SPEED DEMON',
      level: 12,
      matchesPlayed: 330,
      joinedLabel: 'JOINED MAR 2024',
      currentXp: 12450,
      nextLevelXp: 15000,
      quickStats: const <ProfileStatChip>[
        ProfileStatChip(label: 'WINS', value: '247', color: profileGreen),
        ProfileStatChip(label: 'LOSSES', value: '83', color: profileRed),
        ProfileStatChip(label: 'WIN RATE', value: '74.8%', color: profileBlue),
      ],
      bestPerformance: const <ProfileStatChip>[
        ProfileStatChip(label: 'BEST STREAK', value: '12', color: profileAmber),
        ProfileStatChip(
          label: 'FASTEST PATTERN',
          value: '0.4s',
          color: profileBlue,
        ),
        ProfileStatChip(
          label: 'HIGHEST LEVEL',
          value: 'LVL 8',
          color: profilePurple,
        ),
      ],
      achievements: const <ProfileAchievement>[
        ProfileAchievement(
          icon: Icons.bolt_rounded,
          title: 'SPEED DEMON',
          subtitle: '< 0.5s tap',
          unlocked: true,
          color: profileAmber,
        ),
        ProfileAchievement(
          icon: Icons.star_rounded,
          title: 'FIRST BLOOD',
          subtitle: 'Win 1st match',
          unlocked: true,
          color: profileGreen,
        ),
        ProfileAchievement(
          icon: Icons.emoji_events_rounded,
          title: 'CENTURY',
          subtitle: '100 wins',
          unlocked: true,
          color: profileBlue,
        ),
        ProfileAchievement(
          icon: Icons.shield_rounded,
          title: 'FLAWLESS',
          subtitle: 'Perfect round',
          unlocked: false,
          color: profileMuted,
        ),
        ProfileAchievement(
          icon: Icons.star_rounded,
          title: 'VETERAN',
          subtitle: '250 matches',
          unlocked: true,
          color: profilePurple,
        ),
        ProfileAchievement(
          icon: Icons.bolt_rounded,
          title: 'UNTOUCHABLE',
          subtitle: '10-win streak',
          unlocked: false,
          color: profileMuted,
        ),
      ],
      recentMatches: const <ProfileRecentMatch>[
        ProfileRecentMatch(
          didWin: true,
          opponent: 'GodMode',
          level: 6,
          coinDeltaLabel: '+120',
        ),
        ProfileRecentMatch(
          didWin: false,
          opponent: 'SniperPro',
          level: 4,
          coinDeltaLabel: '--',
        ),
        ProfileRecentMatch(
          didWin: true,
          opponent: 'FastFingers',
          level: 5,
          coinDeltaLabel: '+85',
        ),
      ],
    );
  }
}
