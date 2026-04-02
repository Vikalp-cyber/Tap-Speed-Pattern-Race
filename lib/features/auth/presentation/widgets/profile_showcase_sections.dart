import 'package:flutter/material.dart';

import '../models/profile_showcase_data.dart';
import 'profile_panel.dart';
import 'profile_tokens.dart';

class ProfileHeroSection extends StatelessWidget {
  const ProfileHeroSection({required this.data, super.key});

  final ProfileShowcaseData data;

  @override
  Widget build(BuildContext context) {
    final int xpRemaining = data.nextLevelXp - data.currentXp;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: ProfilePanel(
        accentColor: profileBlue,
        gradient: profileHeroGradient,
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool wide = constraints.maxWidth >= 520;
            final Widget summary = _HeroSummary(
              data: data,
              xpRemaining: xpRemaining,
            );

            if (wide) {
              return Row(
                children: <Widget>[
                  _AvatarLockup(data: data, centerAligned: false),
                  const SizedBox(width: 24),
                  Expanded(child: summary),
                ],
              );
            }

            return Column(
              children: <Widget>[
                _AvatarLockup(data: data, centerAligned: true),
                const SizedBox(height: 20),
                summary,
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProfileXpCard extends StatelessWidget {
  const ProfileXpCard({required this.data, super.key});

  final ProfileShowcaseData data;

  @override
  Widget build(BuildContext context) {
    final double progress = data.currentXp / data.nextLevelXp;
    final int remaining = data.nextLevelXp - data.currentXp;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ProfilePanel(
        accentColor: profileBlue,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const _SectionEyebrow('XP PROGRESS'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: profileBlue.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: profileBlue.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Text(
                    '$remaining TO NEXT',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: profileBlue,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${_formatNumber(data.currentXp)} / ${_formatNumber(data.nextLevelXp)}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: profileWhite,
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: profileMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: profileBorder.withValues(alpha: 0.38),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: FractionallySizedBox(
                  widthFactor: progress.clamp(0, 1),
                  alignment: Alignment.centerLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      gradient: const LinearGradient(
                        colors: <Color>[profileBlue, profilePurple],
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: profileBlue.withValues(alpha: 0.45),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'LVL ${data.level}',
                  style: const TextStyle(
                    fontSize: 9,
                    color: profileBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'LVL ${data.level + 1}',
                  style: const TextStyle(
                    fontSize: 9,
                    color: profileDim,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileQuickStatsSection extends StatelessWidget {
  const ProfileQuickStatsSection({required this.data, super.key});

  final ProfileShowcaseData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool wrapCards = constraints.maxWidth < 420;

          if (wrapCards) {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: data.quickStats.map((ProfileStatChip stat) {
                return SizedBox(
                  width: (constraints.maxWidth - 10) / 2,
                  child: _QuickStatCard(stat: stat),
                );
              }).toList(),
            );
          }

          return Row(
            children: List<Widget>.generate(data.quickStats.length, (
              int index,
            ) {
              final ProfileStatChip stat = data.quickStats[index];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 5,
                    right: index == data.quickStats.length - 1 ? 0 : 5,
                  ),
                  child: _QuickStatCard(stat: stat),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class ProfileBestPerformanceSection extends StatelessWidget {
  const ProfileBestPerformanceSection({required this.data, super.key});

  final ProfileShowcaseData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(label: 'BEST PERFORMANCE'),
          const SizedBox(height: 10),
          ProfilePanel(
            accentColor: profilePurple,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool compact = constraints.maxWidth < 420;

                if (compact) {
                  return Column(
                    children: List<Widget>.generate(
                      data.bestPerformance.length,
                      (int index) {
                        final ProfileStatChip stat =
                            data.bestPerformance[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == data.bestPerformance.length - 1
                                ? 0
                                : 14,
                          ),
                          child: _PerformanceItem(stat: stat, compact: true),
                        );
                      },
                    ),
                  );
                }

                return Row(
                  children: List<Widget>.generate(data.bestPerformance.length, (
                    int index,
                  ) {
                    final ProfileStatChip stat = data.bestPerformance[index];
                    return Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(child: _PerformanceItem(stat: stat)),
                          if (index <
                              data.bestPerformance.length - 1) ...<Widget>[
                            const SizedBox(width: 16),
                            Container(
                              width: 1,
                              height: 42,
                              color: profileBorder.withValues(alpha: 0.65),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileAchievementsSection extends StatelessWidget {
  const ProfileAchievementsSection({required this.data, super.key});

  final ProfileShowcaseData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionHeader(
            label: 'ACHIEVEMENTS',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: profileBlue.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: profileBlue.withValues(alpha: 0.28)),
              ),
              child: Text(
                '${data.unlockedAchievementCount} / ${data.achievements.length}',
                style: const TextStyle(
                  fontSize: 10,
                  color: profileBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final int crossAxisCount = constraints.maxWidth < 420 ? 2 : 3;
              final double aspectRatio = constraints.maxWidth < 420
                  ? 1.35
                  : 1.05;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.achievements.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: aspectRatio,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _AchievementCard(
                    achievement: data.achievements[index],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProfileRecentMatchesSection extends StatelessWidget {
  const ProfileRecentMatchesSection({required this.data, super.key});

  final ProfileShowcaseData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionHeader(label: 'RECENT MATCHES'),
          const SizedBox(height: 10),
          ProfilePanel(
            accentColor: profileBlue,
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.recentMatches.length,
              separatorBuilder: (_, __) {
                return Divider(
                  height: 1,
                  color: profileBorder.withValues(alpha: 0.55),
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return _RecentMatchRow(match: data.recentMatches[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarLockup extends StatelessWidget {
  const _AvatarLockup({required this.data, required this.centerAligned});

  final ProfileShowcaseData data;
  final bool centerAligned;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centerAligned
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: profileBlue.withValues(alpha: 0.30),
                    blurRadius: 34,
                    spreadRadius: 6,
                  ),
                ],
              ),
            ),
            Container(
              width: 102,
              height: 102,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: profileAvatarGradient,
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: profileBg,
                  border: Border.all(
                    color: profileBlue.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      profileBlue.withValues(alpha: 0.38),
                      profilePurple.withValues(alpha: 0.38),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: <Color>[profileBlue, profileBlueDeep],
                  ),
                  border: Border.all(color: profileBg, width: 2),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: profileBlue.withValues(alpha: 0.65),
                      blurRadius: 12,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '${data.level}',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: profileWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          data.displayName,
          textAlign: centerAligned ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: profileWhite,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: profilePurple.withValues(alpha: 0.10),
            border: Border.all(color: profilePurple.withValues(alpha: 0.45)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.bolt_rounded, color: profilePurple, size: 12),
              const SizedBox(width: 5),
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: profilePurple,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroSummary extends StatelessWidget {
  const _HeroSummary({required this.data, required this.xpRemaining});

  final ProfileShowcaseData data;
  final int xpRemaining;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            _InfoChip(
              label: 'RACER STATUS',
              color: profileBlue,
              icon: Icons.speed_rounded,
            ),
            _InfoChip(
              label: data.providerLabel.toUpperCase(),
              color: profilePurple,
              icon: Icons.verified_user_rounded,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          '${data.matchesPlayed} MATCHES - ${data.joinedLabel}',
          style: const TextStyle(
            fontSize: 10,
            color: profileMuted,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool wrap = constraints.maxWidth < 320;

            if (wrap) {
              return Column(
                children: <Widget>[
                  _HeroMetric(
                    label: 'LEVEL',
                    value: '${data.level}',
                    accent: profileBlue,
                  ),
                  const SizedBox(height: 10),
                  _HeroMetric(
                    label: 'BADGES',
                    value: '${data.unlockedAchievementCount}',
                    accent: profileAmber,
                  ),
                  const SizedBox(height: 10),
                  _HeroMetric(
                    label: 'NEXT XP',
                    value: _formatNumber(xpRemaining),
                    accent: profileGreen,
                  ),
                ],
              );
            }

            return Row(
              children: <Widget>[
                Expanded(
                  child: _HeroMetric(
                    label: 'LEVEL',
                    value: '${data.level}',
                    accent: profileBlue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _HeroMetric(
                    label: 'BADGES',
                    value: '${data.unlockedAchievementCount}',
                    accent: profileAmber,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _HeroMetric(
                    label: 'NEXT XP',
                    value: _formatNumber(xpRemaining),
                    accent: profileGreen,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: profileMuted,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.9,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({required this.stat});

  final ProfileStatChip stat;

  @override
  Widget build(BuildContext context) {
    return ProfilePanel(
      accentColor: stat.color,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 26,
            height: 4,
            decoration: BoxDecoration(
              color: stat.color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            stat.value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: stat.color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            stat.label,
            style: const TextStyle(
              fontSize: 8,
              color: profileDim,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceItem extends StatelessWidget {
  const _PerformanceItem({required this.stat, this.compact = false});

  final ProfileStatChip stat;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: compact
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          stat.value,
          textAlign: compact ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: stat.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label,
          textAlign: compact ? TextAlign.left : TextAlign.center,
          style: const TextStyle(
            fontSize: 8,
            color: profileDim,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final ProfileAchievement achievement;

  @override
  Widget build(BuildContext context) {
    final Color accent = achievement.unlocked ? achievement.color : profileDim;

    return ProfilePanel(
      accentColor: achievement.unlocked ? accent : null,
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: <Widget>[
          if (achievement.unlocked)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.12),
                ),
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: achievement.unlocked
                      ? accent.withValues(alpha: 0.15)
                      : profileBorder.withValues(alpha: 0.40),
                  border: Border.all(
                    color: achievement.unlocked
                        ? accent.withValues(alpha: 0.50)
                        : const Color(0xFF374151),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  achievement.unlocked ? achievement.icon : Icons.lock_rounded,
                  color: achievement.unlocked ? accent : profileDim,
                  size: achievement.unlocked ? 20 : 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 8.5,
                  color: achievement.unlocked ? profileWhite : profileDim,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                achievement.subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 8, color: profileDim),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentMatchRow extends StatelessWidget {
  const _RecentMatchRow({required this.match});

  final ProfileRecentMatch match;

  @override
  Widget build(BuildContext context) {
    final Color accent = match.didWin ? profileGreen : profileRed;

    return Container(
      decoration: BoxDecoration(
        gradient: match.didWin
            ? LinearGradient(
                colors: <Color>[
                  profileGreen.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: <Widget>[
            Container(
              width: 40,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: accent.withValues(alpha: 0.15),
                border: Border.all(color: accent.withValues(alpha: 0.35)),
              ),
              alignment: Alignment.center,
              child: Text(
                match.didWin ? 'WIN' : 'LOSS',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 8,
                  color: accent,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: profileBlue.withValues(alpha: 0.08),
                border: Border.all(color: profileBorder),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    match.opponent,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: profileWhite,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'LVL ${match.level} PATTERN',
                    style: const TextStyle(
                      fontSize: 9,
                      color: profileDim,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  match.coinDeltaLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: match.didWin ? profileAmber : profileDim,
                  ),
                ),
                if (match.didWin) ...<Widget>[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.monetization_on_rounded,
                    color: profileAmber,
                    size: 13,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, this.trailing});

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            color: profileMuted,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            color: profileBorder.withValues(alpha: 0.55),
          ),
        ),
        if (trailing != null) ...<Widget>[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}

class _SectionEyebrow extends StatelessWidget {
  const _SectionEyebrow(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 10,
        color: profileMuted,
        letterSpacing: 2,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

String _formatNumber(int value) {
  final String raw = value.toString();
  final StringBuffer buffer = StringBuffer();

  for (int index = 0; index < raw.length; index += 1) {
    if (index > 0 && (raw.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(raw[index]);
  }

  return buffer.toString();
}
