import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/controllers/auth_controller.dart';

const Color _kBg = Color(0xFF0D0D0D);
const Color _kPanel = Color(0xFF1A1A1A);
const Color _kBorder = Color(0xFF2D2D2D);
const Color _kBlue = Color(0xFF3B82F6);
const Color _kBlueDeep = Color(0xFF1D4ED8);
const Color _kAmber = Color(0xFFF59E0B);
const Color _kBronze = Color(0xFFB45309);
const Color _kSilver = Color(0xFF9CA3AF);
const Color _kMuted = Color(0xFF9CA3AF);
const Color _kWhite = Color(0xFFFFFFFF);

class _Player {
  const _Player({
    required this.rank,
    required this.name,
    required this.score,
    this.isMe = false,
  });

  final int rank;
  final String name;
  final int score;
  final bool isMe;
}

class LeaderboardPage extends ConsumerStatefulWidget {
  const LeaderboardPage({super.key});

  @override
  ConsumerState<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends ConsumerState<LeaderboardPage> {
  int _tabIndex = 0;

  static const List<_Player> _globalPodium = <_Player>[
    _Player(rank: 1, name: 'GodMode', score: 18500),
    _Player(rank: 2, name: 'SniperPro', score: 14200),
    _Player(rank: 3, name: 'FastFingers', score: 12100),
  ];

  static const List<_Player> _friendsPodium = <_Player>[
    _Player(rank: 1, name: 'PulseNova', score: 9800),
    _Player(rank: 2, name: 'SkyArc', score: 9100),
    _Player(rank: 3, name: 'DriftFox', score: 8700),
  ];

  @override
  Widget build(BuildContext context) {
    final AuthState authState = ref.watch(authControllerProvider);
    final String playerName = authState.session?.displayName ?? 'Player_X1';

    final List<_Player> podium = _tabIndex == 0
        ? _globalPodium
        : _friendsPodium;
    final List<_Player> list = _buildRankedList(playerName);

    return ColoredBox(
      color: _kBg,
      child: Column(
        children: <Widget>[
          _Header(
            tabIndex: _tabIndex,
            onTabChanged: (int index) {
              setState(() => _tabIndex = index);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    children: <Widget>[
                      _Podium(players: podium),
                      _RankedList(players: list),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<_Player> _buildRankedList(String playerName) {
    if (_tabIndex == 0) {
      return <_Player>[
        const _Player(rank: 4, name: 'User_004', score: 8000),
        const _Player(rank: 5, name: 'User_005', score: 7500),
        _Player(rank: 6, name: '$playerName (You)', score: 7000, isMe: true),
        const _Player(rank: 7, name: 'User_007', score: 6500),
        const _Player(rank: 8, name: 'User_008', score: 6000),
      ];
    }

    return <_Player>[
      const _Player(rank: 4, name: 'ZeroLag', score: 8400),
      _Player(rank: 5, name: '$playerName (You)', score: 7900, isMe: true),
      const _Player(rank: 6, name: 'ArcByte', score: 7600),
      const _Player(rank: 7, name: 'NexaRush', score: 7150),
      const _Player(rank: 8, name: 'SpeedMint', score: 6900),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.tabIndex, required this.onTabChanged});

  final int tabIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kBg,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'LEADERBOARD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _kWhite,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  _TabPill(
                    label: 'GLOBAL',
                    active: tabIndex == 0,
                    onTap: () => onTabChanged(0),
                  ),
                  const SizedBox(width: 12),
                  _TabPill(
                    label: 'FRIENDS',
                    active: tabIndex == 1,
                    onTap: () => onTabChanged(1),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: _kBlue),
                    ),
                    child: const Text(
                      'ALL TIME',
                      style: TextStyle(
                        color: _kBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? _kBorder : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: active ? _kWhite : _kMuted,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({required this.players});

  final List<_Player> players;

  @override
  Widget build(BuildContext context) {
    final _Player second = players.firstWhere(
      (_Player player) => player.rank == 2,
    );
    final _Player first = players.firstWhere(
      (_Player player) => player.rank == 1,
    );
    final _Player third = players.firstWhere(
      (_Player player) => player.rank == 3,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(child: _PodiumSlot(player: second, bottomPad: 16)),
          Expanded(child: _PodiumSlot(player: first, bottomPad: 0)),
          Expanded(child: _PodiumSlot(player: third, bottomPad: 32)),
        ],
      ),
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  const _PodiumSlot({required this.player, required this.bottomPad});

  final _Player player;
  final double bottomPad;

  Color get _borderColor {
    if (player.rank == 1) {
      return _kAmber;
    }
    if (player.rank == 2) {
      return _kSilver;
    }
    return _kBronze;
  }

  Color get _badgeBg {
    if (player.rank == 1) {
      return _kAmber;
    }
    if (player.rank == 2) {
      return _kSilver;
    }
    return _kBronze;
  }

  Color get _badgeFg => player.rank == 3 ? _kWhite : Colors.black;

  double get _avatarSize {
    if (player.rank == 1) {
      return 80;
    }
    if (player.rank == 2) {
      return 64;
    }
    return 56;
  }

  double get _crownSize {
    if (player.rank == 1) {
      return 28;
    }
    if (player.rank == 2) {
      return 20;
    }
    return 18;
  }

  double get _nameFontSize => player.rank == 1 ? 14 : 12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _CrownIcon(size: _crownSize, color: _borderColor),
          const SizedBox(height: 8),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: _avatarSize,
                height: _avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _kPanel,
                  border: Border.all(color: _borderColor, width: 4),
                  boxShadow: player.rank == 1
                      ? <BoxShadow>[
                          BoxShadow(
                            color: _kAmber.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
              Positioned(
                bottom: -8,
                child: Container(
                  width: player.rank == 1
                      ? 26
                      : player.rank == 2
                      ? 22
                      : 18,
                  height: player.rank == 1
                      ? 26
                      : player.rank == 2
                      ? 22
                      : 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _badgeBg,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${player.rank}',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: player.rank == 1 ? 13 : 10,
                      color: _badgeFg,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            player.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: player.rank == 1 ? _kAmber : _kWhite,
              fontWeight: FontWeight.w700,
              fontSize: _nameFontSize,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatPodiumScore(player.score),
            style: TextStyle(
              fontSize: player.rank == 1 ? 12 : 10,
              fontWeight: FontWeight.w700,
              color: _kBlue,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPodiumScore(int score) {
    final String raw = score.toString();
    final StringBuffer buffer = StringBuffer();
    for (int index = 0; index < raw.length; index += 1) {
      if (index > 0 && (raw.length - index) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(raw[index]);
    }
    return buffer.toString();
  }
}

class _CrownIcon extends StatelessWidget {
  const _CrownIcon({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.workspace_premium_rounded,
      size: size,
      color: color,
      shadows: <Shadow>[
        Shadow(color: color.withValues(alpha: 0.6), blurRadius: 12),
      ],
    );
  }
}

class _RankedList extends StatelessWidget {
  const _RankedList({required this.players});

  final List<_Player> players;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: players.map((_Player player) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _RankRow(player: player),
          );
        }).toList(),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.player});

  final _Player player;

  @override
  Widget build(BuildContext context) {
    final bool isMe = player.isMe;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isMe ? _kBlueDeep.withValues(alpha: 0.2) : _kPanel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMe ? _kBlue : _kBorder,
          width: isMe ? 1.5 : 1,
        ),
        boxShadow: isMe
            ? <BoxShadow>[
                BoxShadow(
                  color: _kBlue.withValues(alpha: 0.12),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
            child: Text(
              '${player.rank}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: _kMuted,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMe ? _kBlue.withValues(alpha: 0.25) : _kBorder,
              border: isMe
                  ? Border.all(color: _kBlue.withValues(alpha: 0.6))
                  : null,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              player.name,
              style: TextStyle(
                color: isMe ? _kBlue : _kWhite,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            _formatRankedScore(player.score),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: _kWhite,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRankedScore(int score) {
    final String raw = score.toString();
    final StringBuffer buffer = StringBuffer();
    for (int index = 0; index < raw.length; index += 1) {
      if (index > 0 && (raw.length - index) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(raw[index]);
    }
    return buffer.toString();
  }
}
