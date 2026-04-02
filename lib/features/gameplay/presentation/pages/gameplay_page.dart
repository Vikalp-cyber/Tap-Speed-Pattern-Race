import 'dart:async';

import 'package:flutter/material.dart';

import '../models/game_demo_sequence.dart';
import '../widgets/gameplay_background.dart';
import '../widgets/gameplay_base_ui.dart';
import '../widgets/gameplay_completion_overlays.dart';
import '../widgets/gameplay_countdown_overlay.dart';
import '../widgets/gameplay_failure_overlay.dart';
import '../widgets/gameplay_tokens.dart';

class GameplayPage extends StatefulWidget {
  const GameplayPage({super.key});

  @override
  State<GameplayPage> createState() => _GameplayPageState();
}

class _GameplayPageState extends State<GameplayPage>
    with TickerProviderStateMixin {
  int _stepIndex = 0;
  Timer? _stepTimer;

  late final AnimationController _rippleController;
  late final AnimationController _floatController;
  late final AnimationController _pulseController;
  late final AnimationController _shakeController;
  late final AnimationController _popController;

  late final Animation<double> _floatAnimation;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _shakeAnimation;
  late final Animation<double> _popAnimation;

  @override
  void initState() {
    super.initState();

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: -10),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -10, end: 10),
        weight: 2,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 10, end: -8),
        weight: 2,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -8, end: 6),
        weight: 2,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 6, end: 0),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.linear));

    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _popAnimation = CurvedAnimation(
      parent: _popController,
      curve: Curves.elasticOut,
    );

    _scheduleCurrentStep();
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _rippleController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    _popController.dispose();
    super.dispose();
  }

  GameDemoStep get _step => GameDemoSequence.steps[_stepIndex];

  bool get _showBaseUi {
    return switch (_step.phase) {
      GameDemoPhase.countdown ||
      GameDemoPhase.pattern ||
      GameDemoPhase.input => true,
      _ => false,
    };
  }

  String _tileState(int tileIndex) {
    final GameDemoStep step = _step;

    switch (step.phase) {
      case GameDemoPhase.pattern:
        return step.litTileIndex == tileIndex ? 'active' : 'dim';
      case GameDemoPhase.input:
        final int tapPosition = step.tapPosition ?? -1;
        final GameDemoTapResult? tapResult = step.tapResult;
        if (tapPosition >= 0 && tapResult != null) {
          if (tapResult == GameDemoTapResult.correct &&
              step.pattern[tapPosition] == tileIndex) {
            return 'correct';
          }

          final int wrongTile =
              step.errorTileIndex ?? step.pattern[tapPosition];
          if (tapResult == GameDemoTapResult.wrong && wrongTile == tileIndex) {
            return 'wrong';
          }
        }
        return 'normal';
      case GameDemoPhase.failure:
        return 'dim';
      case GameDemoPhase.levelUp:
      case GameDemoPhase.victory:
        return 'glow';
      case GameDemoPhase.countdown:
        return 'normal';
    }
  }

  void _scheduleCurrentStep() {
    _stepTimer?.cancel();
    final GameDemoStep step = _step;

    if (step.phase == GameDemoPhase.failure) {
      _shakeController.forward(from: 0);
    }
    if (step.phase == GameDemoPhase.countdown) {
      _popController.forward(from: 0);
    }

    _stepTimer = Timer(step.duration, _advanceToNextStep);
  }

  void _advanceToNextStep() {
    if (!mounted) {
      return;
    }

    setState(() {
      _stepIndex = (_stepIndex + 1) % GameDemoSequence.steps.length;
    });
    _scheduleCurrentStep();
  }

  void _jumpToStep(int nextIndex) {
    _stepTimer?.cancel();
    setState(() {
      _stepIndex = nextIndex;
    });
    _scheduleCurrentStep();
  }

  void _continueAfterFailure() {
    _jumpToStep((_stepIndex + 1) % GameDemoSequence.steps.length);
  }

  void _restartDemo() {
    _jumpToStep(0);
  }

  void _returnToLobby() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final GameDemoStep step = _step;

    return Scaffold(
      backgroundColor: gameplayBg,
      body: AnimatedBuilder(
        animation: _shakeController,
        builder: (_, Widget? child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: child,
          );
        },
        child: Stack(
          children: <Widget>[
            const Positioned.fill(child: GameplayGridBackground()),
            Positioned.fill(child: GameplayAmbientGlow(phase: step.phase)),
            if (_showBaseUi)
              Positioned.fill(
                child: GameplayBaseUi(step: step, tileState: _tileState),
              ),
            if (!_showBaseUi)
              const Positioned.fill(child: GameplayDimmedTileGrid()),
            if (step.phase == GameDemoPhase.countdown)
              Positioned.fill(
                child: GameplayCountdownOverlay(
                  step: step,
                  popScale: _popAnimation,
                  rippleController: _rippleController,
                ),
              ),
            if (step.phase == GameDemoPhase.failure)
              Positioned.fill(
                child: GameplayFailureOverlay(
                  step: step,
                  pulseAnimation: _pulseAnimation,
                  onContinue: _continueAfterFailure,
                  onRestart: _restartDemo,
                ),
              ),
            if (step.phase == GameDemoPhase.levelUp)
              Positioned.fill(
                child: GameplayLevelUpOverlay(
                  step: step,
                  floatAnimation: _floatAnimation,
                  pulseAnimation: _pulseAnimation,
                ),
              ),
            if (step.phase == GameDemoPhase.victory)
              Positioned.fill(
                child: GameplayVictoryOverlay(
                  step: step,
                  floatAnimation: _floatAnimation,
                  onPlayAgain: _restartDemo,
                  onReturnToLobby: _returnToLobby,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
