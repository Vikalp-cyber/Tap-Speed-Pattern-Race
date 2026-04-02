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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MatchmakingRadar(
                      sweepTurns: _sweepCtrl,
                      pulseScales: _pulseScales,
                      pulseOpacities: _pulseOpacities,
                      playerName: playerName,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'SEARCHING...',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: matchmakingWhite,
                            letterSpacing: 4,
                            shadows: <Shadow>[
                              Shadow(
                                color: matchmakingBlue.withValues(alpha: 0.6),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          color: matchmakingMuted,
                        ),
                        children: <InlineSpan>[
                          const TextSpan(text: 'Estimated wait:  '),
                          TextSpan(
                            text: _waitLabel,
                            style: const TextStyle(color: matchmakingWhite),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 96),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 292,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: matchmakingRed, width: 2),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: matchmakingRed.withValues(alpha: 0.3),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'CANCEL',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: matchmakingRed,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
              ),
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
