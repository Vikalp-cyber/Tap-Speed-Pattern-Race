import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/controllers/auth_controller.dart';
import '../../gameplay/presentation/pages/gameplay_page.dart';
import 'matchmaking_tokens.dart';
import 'widgets/matchmaking_grid_background.dart';
import 'widgets/matchmaking_radar.dart';

class MatchmakingPage extends ConsumerStatefulWidget {
  const MatchmakingPage({super.key});

  @override
  ConsumerState<MatchmakingPage> createState() => _MatchmakingPageState();
}

class _MatchmakingPageState extends ConsumerState<MatchmakingPage>
    with TickerProviderStateMixin {
  late final AnimationController _sweepCtrl;
  late final List<AnimationController> _pulseCtrs;
  late final List<Animation<double>> _pulseScales;
  late final List<Animation<double>> _pulseOpacities;
  late final AnimationController _timerCtrl;
  final List<Timer> _pulseStartTimers = <Timer>[];
  Timer? _mockMatchFoundTimer;

  int _seconds = 8;

  @override
  void initState() {
    super.initState();

    _sweepCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pulseCtrs = List<AnimationController>.generate(3, (_) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
      );
    });

    _pulseScales = _pulseCtrs.map((AnimationController controller) {
      return Tween<double>(
        begin: 1.0,
        end: 4.5,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }).toList();

    _pulseOpacities = _pulseCtrs.map((AnimationController controller) {
      return Tween<double>(
        begin: 0.7,
        end: 0.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    }).toList();

    for (int index = 0; index < _pulseCtrs.length; index += 1) {
      final Timer timer = Timer(Duration(milliseconds: index * 600), () {
        if (mounted) {
          _pulseCtrs[index].repeat();
        }
      });
      _pulseStartTimers.add(timer);
    }

    _timerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    _timerCtrl.addListener(_handleTimerTick);
    _timerCtrl.forward();

    // Demo handoff until the real backend emits a match-found event.
    _mockMatchFoundTimer = Timer(
      const Duration(seconds: 5),
      navigateToGameplay,
    );
  }

  @override
  void dispose() {
    _mockMatchFoundTimer?.cancel();
    _sweepCtrl.dispose();
    for (final Timer timer in _pulseStartTimers) {
      timer.cancel();
    }
    for (final AnimationController controller in _pulseCtrs) {
      controller.dispose();
    }
    _timerCtrl
      ..removeListener(_handleTimerTick)
      ..dispose();
    super.dispose();
  }

  String get _waitLabel {
    final int total = _seconds;
    final String minutes = (total ~/ 60).toString().padLeft(2, '0');
    final String seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final AuthState authState = ref.watch(authControllerProvider);
    final String playerName = authState.session?.displayName ?? 'Player_X1';

    return Scaffold(
      backgroundColor: matchmakingBg,
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: MatchmakingGridBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 40,
                        maxWidth: 560,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _MatchmakingHeader(waitLabel: _waitLabel),
                          SizedBox(
                            height: constraints.maxHeight > 760 ? 28 : 18,
                          ),
                          MatchmakingRadar(
                            sweepTurns: _sweepCtrl,
                            pulseScales: _pulseScales,
                            pulseOpacities: _pulseOpacities,
                            playerName: playerName,
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'SEARCHING...',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: matchmakingWhite,
                                  letterSpacing: 4,
                                  shadows: <Shadow>[
                                    Shadow(
                                      color: matchmakingBlue.withValues(
                                        alpha: 0.6,
                                      ),
                                      blurRadius: 16,
                                    ),
                                  ],
                                ),
                          ),
                          const SizedBox(height: 10),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontSize: 13,
                                    color: matchmakingMuted,
                                  ),
                              children: <InlineSpan>[
                                const TextSpan(text: 'Estimated wait:  '),
                                TextSpan(
                                  text: _waitLabel,
                                  style: const TextStyle(
                                    color: matchmakingWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Calibrating ping, balancing skill, and locking the cleanest three-player room.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: matchmakingDim,
                                  height: 1.6,
                                  fontSize: 11,
                                ),
                          ),
                          const SizedBox(height: 20),
                          const _QueueInsightCard(),
                          SizedBox(
                            height: constraints.maxHeight > 760 ? 36 : 24,
                          ),
                          _CancelButton(
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleTimerTick() {
    final int elapsed = (_timerCtrl.value * 60).round();
    final int nextSeconds = math.max(0, 8 + elapsed);
    if (!mounted || nextSeconds == _seconds) {
      return;
    }
    setState(() => _seconds = nextSeconds);
  }

  void navigateToGameplay() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const GameplayPage(),
      ),
    );
  }
}

class _MatchmakingHeader extends StatelessWidget {
  const _MatchmakingHeader({required this.waitLabel});

  final String waitLabel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 10,
      spacing: 10,
      children: <Widget>[
        _HeaderChip(
          label: 'QUEUE',
          value: 'RANKED SOLO',
          accent: matchmakingBlue,
        ),
        _HeaderChip(
          label: 'ROOM',
          value: '3 PLAYERS',
          accent: matchmakingPurple,
        ),
        _HeaderChip(label: 'WAIT', value: waitLabel, accent: matchmakingGreen),
      ],
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: ShapeDecoration(
        gradient: matchmakingPanelGradient,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: accent.withValues(alpha: 0.25)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 9,
              color: matchmakingDim,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 11,
              color: accent,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _QueueInsightCard extends StatelessWidget {
  const _QueueInsightCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        gradient: matchmakingPanelGradient,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: matchmakingBlue.withValues(alpha: 0.22)),
        ),
        shadows: <BoxShadow>[
          BoxShadow(
            color: matchmakingBlue.withValues(alpha: 0.10),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Row(
        children: <Widget>[
          Expanded(
            child: _SignalColumn(
              label: 'REGION',
              value: 'AUTO',
              accent: matchmakingBlue,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _SignalColumn(
              label: 'MATCH TYPE',
              value: 'PATTERN RACE',
              accent: matchmakingPurple,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _SignalColumn(
              label: 'STATUS',
              value: 'SYNCING',
              accent: matchmakingGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalColumn extends StatelessWidget {
  const _SignalColumn({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 9,
            color: matchmakingDim,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 11,
            color: accent,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 292,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: matchmakingPanel,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: matchmakingRed, width: 1.6),
          ),
          shadows: <BoxShadow>[
            BoxShadow(
              color: matchmakingRed.withValues(alpha: 0.22),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'CANCEL',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: matchmakingRed,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
