import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/controllers/auth_controller.dart';
import 'matchmaking_page.dart';

const Color _kBg = Color(0xFF040A1A);
const Color _kPanel = Color(0xFF08142D);
const Color _kBorder = Color(0x6616D5FF);
const Color _kBlue = Color(0xFF16D5FF);
const Color _kPurple = Color(0xFF0F55FF);
const Color _kAmber = Color(0xFF3DE3FF);
const Color _kMuted = Color(0xFF6B7280);
const Color _kWhite = Color(0xFFE5EEFF);

const LinearGradient _kGradientBP = LinearGradient(
  colors: <Color>[_kBlue, _kPurple],
);

class LobbyPage extends ConsumerStatefulWidget {
  const LobbyPage({super.key});

  @override
  ConsumerState<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends ConsumerState<LobbyPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(
      begin: 0,
      end: -12,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthState authState = ref.watch(authControllerProvider);
    final String playerName = authState.session?.displayName ?? 'Player_X1';

    return ColoredBox(
      color: _kBg,
      child: Stack(
        children: <Widget>[
          const Positioned.fill(child: _LobbyBackground()),
          Column(
            children: <Widget>[
              _TopBar(playerName: playerName),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: 8),
                          _PlayButton(
                            floatAnim: _floatAnim,
                            onPressed: _openMatchmaking,
                          ),
                          const SizedBox(height: 28),
                          _RoomButtons(
                            onCreateRoom: () {
                              _showComingSoon('Room creation');
                            },
                            onJoinRoom: () {
                              _showComingSoon('Room joining');
                            },
                          ),
                          const SizedBox(height: 24),
                          const _DailyRewardCard(),
                          const SizedBox(height: 24),
                          const _LeaderboardPreview(),
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

  void _openMatchmaking() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return const MatchmakingPage();
        },
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _kPanel,
        content: Text('$feature flow is ready for backend wiring.'),
      ),
    );
  }
}

class _LobbyBackground extends StatelessWidget {
  const _LobbyBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _LobbyBackgroundPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _LobbyBackgroundPainter extends CustomPainter {
  const _LobbyBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = const Color(0xFF16D5FF).withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    const double gap = 32;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final Paint centerGlow = Paint()
      ..shader =
          const RadialGradient(
            colors: <Color>[Color(0x1816D5FF), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.52, size.height * 0.26),
              radius: size.width * 0.6,
            ),
          );
    canvas.drawRect(Offset.zero & size, centerGlow);

    final Paint lowGlow = Paint()
      ..shader =
          const RadialGradient(
            colors: <Color>[Color(0x120B5BFF), Colors.transparent],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.5, size.height * 0.7),
              radius: size.width * 0.8,
            ),
          );
    canvas.drawRect(Offset.zero & size, lowGlow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.playerName});

  final String playerName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: _kGradientBP,
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: _kPanel,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      _kPurple.withValues(alpha: 0.5),
                      _kBlue.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                playerName,
                style: const TextStyle(
                  color: _kWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'LVL 12',
                style: TextStyle(
                  color: _kBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const ShapeDecoration(
              color: _kPanel,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                side: BorderSide(color: _kBorder),
              ),
            ),
            child: const Row(
              children: <Widget>[
                Icon(Icons.monetization_on_rounded, color: _kAmber, size: 16),
                SizedBox(width: 6),
                Text(
                  '2,450',
                  style: TextStyle(
                    color: _kAmber,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.floatAnim, required this.onPressed});

  final Animation<double> floatAnim;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: floatAnim,
        builder: (_, Widget? child) {
          return Transform.translate(
            offset: Offset(0, floatAnim.value),
            child: child,
          );
        },
        child: GestureDetector(
          onTap: onPressed,
          child: SizedBox(
            width: 192,
            height: 192,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 192,
                  height: 192,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: _kBlue.withValues(alpha: 0.35),
                        blurRadius: 60,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 184,
                  height: 184,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _kGradientBP,
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _kBg,
                      border: Border.all(color: _kBlue, width: 3),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: _kBlue.withValues(alpha: 0.4),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: _kBlue.withValues(alpha: 0.15),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return _kGradientBP.createShader(bounds);
                        },
                        blendMode: BlendMode.srcIn,
                        child: const Text(
                          'PLAY',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: _kWhite,
                            letterSpacing: 6,
                            shadows: <Shadow>[
                              Shadow(color: _kBlue, blurRadius: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomButtons extends StatelessWidget {
  const _RoomButtons({required this.onCreateRoom, required this.onJoinRoom});

  final VoidCallback onCreateRoom;
  final VoidCallback onJoinRoom;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _OutlineButton(label: 'CREATE ROOM', onPressed: onCreateRoom),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _OutlineButton(label: 'JOIN ROOM', onPressed: onJoinRoom),
        ),
      ],
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: ShapeDecoration(
          color: _kPanel,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: _kBorder),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: _kWhite,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

class _DailyRewardCard extends StatelessWidget {
  const _DailyRewardCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const ShapeDecoration(
        color: _kPanel,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          side: BorderSide(color: _kBorder),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: _kBorder,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_rounded, color: _kMuted, size: 20),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '[ REWARDS ]',
                  style: TextStyle(
                    color: _kBlue,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'RESETS IN: 23:41:05',
                  style: TextStyle(
                    color: _kMuted,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: _kBorder,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Text(
              'CLAIM',
              style: TextStyle(
                color: _kMuted,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardPreview extends StatelessWidget {
  const _LeaderboardPreview();

  static const List<Map<String, Object>> _players = <Map<String, Object>>[
    <String, Object>{'rank': 1, 'name': 'User_92', 'score': 9550},
    <String, Object>{'rank': 2, 'name': 'User_85', 'score': 9100},
    <String, Object>{'rank': 3, 'name': 'User_78', 'score': 8650},
  ];

  Color _rankColor(int rank) {
    if (rank == 1) {
      return _kAmber;
    }
    if (rank == 2) {
      return _kMuted;
    }
    return _kPurple;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          '[ TOP DRIVERS ]',
          style: TextStyle(
            color: _kBlue,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: const ShapeDecoration(
            color: _kPanel,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              side: BorderSide(color: _kBorder),
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _players.length,
            separatorBuilder: (_, __) {
              return const Divider(height: 1, thickness: 1, color: _kBorder);
            },
            itemBuilder: (_, int index) {
              final Map<String, Object> player = _players[index];
              final int rank = player['rank']! as int;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 24,
                      child: Text(
                        '$rank',
                        style: TextStyle(
                          color: _rankColor(rank),
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: _kBorder,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        player['name']! as String,
                        style: const TextStyle(
                          color: _kWhite,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '${player['score']}',
                      style: const TextStyle(
                        color: _kWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
