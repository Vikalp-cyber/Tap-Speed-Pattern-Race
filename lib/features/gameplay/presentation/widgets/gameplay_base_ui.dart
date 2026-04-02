import 'package:flutter/material.dart';

import '../models/game_demo_sequence.dart';
import 'gameplay_tokens.dart';

class GameplayBaseUi extends StatelessWidget {
  const GameplayBaseUi({
    required this.step,
    required this.tileState,
    super.key,
  });

  final GameDemoStep step;
  final String Function(int tileIndex) tileState;

  @override
  Widget build(BuildContext context) {
    final bool showPhaseLabel =
        step.phase == GameDemoPhase.pattern ||
        step.phase == GameDemoPhase.input;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          children: <Widget>[
            _HeaderRow(step: step),
            const SizedBox(height: 16),
            _ProgressBars(step: step),
            const SizedBox(height: 16),
            if (showPhaseLabel) ...<Widget>[
              _PhasePill(phase: step.phase),
              const SizedBox(height: 16),
            ] else
              const SizedBox(height: 32),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List<Widget>.generate(
                    GameDemoSequence.tiles.length,
                    (int index) => GameplayAnimatedTile(
                      tile: GameDemoSequence.tiles[index],
                      state: tileState(index),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (step.phase == GameDemoPhase.input)
              _StepDots(
                tapPosition: step.tapPosition ?? -1,
                totalSteps: step.pattern.length,
              ),
          ],
        ),
      ),
    );
  }
}

class GameplayDimmedTileGrid extends StatelessWidget {
  const GameplayDimmedTileGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.15,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(44, 200, 44, 0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            physics: const NeverScrollableScrollPhysics(),
            children: GameDemoSequence.tiles.map((GameDemoTile tile) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: tile.color,
                  borderRadius: BorderRadius.circular(22),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class GameplayAnimatedTile extends StatelessWidget {
  const GameplayAnimatedTile({
    required this.tile,
    required this.state,
    super.key,
  });

  final GameDemoTile tile;
  final String state;

  @override
  Widget build(BuildContext context) {
    double scale = 1;
    double opacity = 1;
    Color color = tile.color;
    List<BoxShadow> shadows = <BoxShadow>[];
    Border? border;

    switch (state) {
      case 'active':
        scale = 1.08;
        shadows = <BoxShadow>[
          BoxShadow(color: tile.glow, blurRadius: 40, spreadRadius: 8),
        ];
        border = Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 2,
        );
        break;
      case 'dim':
        opacity = 0.28;
        scale = 0.95;
        break;
      case 'correct':
        color = gameplayGreen;
        scale = 1.07;
        shadows = <BoxShadow>[
          BoxShadow(
            color: gameplayGreen.withValues(alpha: 0.9),
            blurRadius: 40,
            spreadRadius: 8,
          ),
        ];
        break;
      case 'wrong':
        color = gameplayRed;
        scale = 0.94;
        shadows = <BoxShadow>[
          BoxShadow(
            color: gameplayRed.withValues(alpha: 0.9),
            blurRadius: 40,
            spreadRadius: 8,
          ),
        ];
        break;
      case 'glow':
        shadows = <BoxShadow>[
          BoxShadow(color: tile.glow, blurRadius: 20, spreadRadius: 2),
        ];
        break;
      default:
        shadows = <BoxShadow>[
          BoxShadow(color: tile.glow.withValues(alpha: 0.15), blurRadius: 6),
        ];
    }

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 120),
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(22),
            border: border,
            boxShadow: shadows,
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                tile.label,
                style: const TextStyle(
                  color: gameplayWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.step});

  final GameDemoStep step;

  @override
  Widget build(BuildContext context) {
    final String roundLabel = '${step.round} / 3';

    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: gameplayPanel,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: gameplayBorder),
          ),
          child: Text(
            'LEVEL ${step.level} - ROUND $roundLabel',
            style: const TextStyle(
              fontSize: 11,
              color: gameplayBlue,
              letterSpacing: 1,
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: gameplayPanel,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: gameplayBlue),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: gameplayBlue.withValues(alpha: 0.2),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Text(
            '0:45',
            style: TextStyle(
              fontSize: 18,
              color: gameplayBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressBars extends StatelessWidget {
  const _ProgressBars({required this.step});

  final GameDemoStep step;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gameplayPanel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: gameplayBorder),
      ),
      child: Column(
        children: <Widget>[
          _ProgressRow(
            label: 'YOU',
            value: step.yourProgress,
            color: step.isLeading ? gameplayGreen : gameplayBlue,
            isYou: true,
          ),
          const SizedBox(height: 8),
          _ProgressRow(
            label: GameDemoSequence.opponents[0],
            value: step.opponentOneProgress,
            color: gameplayPurple,
          ),
          const SizedBox(height: 8),
          _ProgressRow(
            label: GameDemoSequence.opponents[1],
            value: step.opponentTwoProgress,
            color: gameplayAmber,
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
    required this.color,
    this.isYou = false,
  });

  final String label;
  final int value;
  final Color color;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 58,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1,
              color: isYou ? gameplayWhite : gameplayMuted,
              fontWeight: isYou ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: gameplayBorder,
              color: color,
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$value%',
          style: TextStyle(
            fontSize: 9,
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PhasePill extends StatelessWidget {
  const _PhasePill({required this.phase});

  final GameDemoPhase phase;

  @override
  Widget build(BuildContext context) {
    final bool isPattern = phase == GameDemoPhase.pattern;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Container(
        key: ValueKey<GameDemoPhase>(phase),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isPattern
              ? gameplayBlue.withValues(alpha: 0.12)
              : gameplayGreen.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isPattern
                ? gameplayBlue.withValues(alpha: 0.4)
                : gameplayGreen.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          isPattern ? 'MEMORIZE THE PATTERN' : 'YOUR TURN',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 2,
            color: isPattern ? gameplayBlue : gameplayGreen,
          ),
        ),
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.tapPosition, required this.totalSteps});

  final int tapPosition;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(totalSteps, (int index) {
        Color color;
        if (index < tapPosition) {
          color = gameplayGreen;
        } else if (index == tapPosition) {
          color = gameplayBlue;
        } else {
          color = gameplayBorder;
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        );
      }),
    );
  }
}
