import 'package:flutter/material.dart';

import '../models/game_demo_sequence.dart';
import 'gameplay_panel.dart';
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
    final Color boardAccent = switch (step.phase) {
      GameDemoPhase.input => step.isLeading ? gameplayGreen : gameplayBlue,
      GameDemoPhase.pattern => gameplayBlue,
      GameDemoPhase.countdown => gameplayPurple,
      GameDemoPhase.failure => gameplayRed,
      GameDemoPhase.levelUp => gameplayAmber,
      GameDemoPhase.victory => gameplayAmber,
    };

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
        child: Column(
          children: <Widget>[
            _HudRow(step: step),
            const SizedBox(height: 14),
            GameplayPanel(
              accentColor: step.isLeading ? gameplayGreen : gameplayBlue,
              child: _ProgressBars(step: step),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: GameplayPanel(
                accentColor: boardAccent,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _BoardHeader(step: step),
                    if (showPhaseLabel) ...<Widget>[
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _PhasePill(phase: step.phase),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: AspectRatio(
                            aspectRatio: 1,
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
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SequenceFooter(step: step),
                  ],
                ),
              ),
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 146, 32, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: GameplayPanel(
              accentColor: gameplaySoftBorder,
              padding: const EdgeInsets.all(16),
              child: Opacity(
                opacity: 0.28,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    physics: const NeverScrollableScrollPhysics(),
                    children: GameDemoSequence.tiles.map((GameDemoTile tile) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              tile.color.withValues(alpha: 0.85),
                              tile.color.withValues(alpha: 0.45),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: tile.color.withValues(alpha: 0.35),
                          ),
                        ),
                      );
                    }).toList(),
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
    Color accent = tile.color;
    List<BoxShadow> shadows = <BoxShadow>[];
    Border? border;

    switch (state) {
      case 'active':
        scale = 1.08;
        shadows = <BoxShadow>[
          BoxShadow(color: tile.glow, blurRadius: 34, spreadRadius: 5),
        ];
        border = Border.all(
          color: gameplayWhite.withValues(alpha: 0.4),
          width: 1.8,
        );
        break;
      case 'dim':
        opacity = 0.24;
        scale = 0.96;
        break;
      case 'correct':
        accent = gameplayGreen;
        scale = 1.05;
        shadows = <BoxShadow>[
          BoxShadow(
            color: gameplayGreen.withValues(alpha: 0.45),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ];
        break;
      case 'wrong':
        accent = gameplayRed;
        scale = 0.95;
        shadows = <BoxShadow>[
          BoxShadow(
            color: gameplayRed.withValues(alpha: 0.45),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ];
        break;
      case 'glow':
        shadows = <BoxShadow>[
          BoxShadow(color: tile.glow.withValues(alpha: 0.4), blurRadius: 22),
        ];
        break;
      default:
        shadows = <BoxShadow>[
          BoxShadow(color: tile.glow.withValues(alpha: 0.18), blurRadius: 12),
        ];
    }

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 140),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                accent.withValues(alpha: 0.98),
                accent.withValues(alpha: 0.72),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: border ?? Border.all(color: accent.withValues(alpha: 0.30)),
            boxShadow: shadows,
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 12,
                left: 12,
                right: 52,
                child: Container(
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      colors: <Color>[
                        gameplayWhite.withValues(alpha: 0.26),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: gameplayBg.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: gameplayWhite.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Text(
                    tile.label,
                    style: const TextStyle(
                      color: gameplayWhite,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HudRow extends StatelessWidget {
  const _HudRow({required this.step});

  final GameDemoStep step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GameplayPanel(
            accentColor: gameplayBlue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: gameplayPrimaryGradient,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: gameplayBlue.withValues(alpha: 0.20),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.graphic_eq_rounded,
                    color: gameplayBg,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'LEVEL ${step.level} / ROUND ${step.round}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: gameplayBlue,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Arena sync stable. Pattern feed live.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: gameplayMuted,
                          fontSize: 10,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GameplayPanel(
          accentColor: gameplayBlue,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'TIMER',
                style: TextStyle(
                  fontSize: 9,
                  color: gameplayDim,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                ),
              ),
              SizedBox(height: 6),
              Text(
                '0:45',
                style: TextStyle(
                  fontSize: 18,
                  color: gameplayBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BoardHeader extends StatelessWidget {
  const _BoardHeader({required this.step});

  final GameDemoStep step;

  @override
  Widget build(BuildContext context) {
    final bool isInput = step.phase == GameDemoPhase.input;
    final String headline = switch (step.phase) {
      GameDemoPhase.pattern => 'Memorize the route',
      GameDemoPhase.input => 'Repeat the sequence',
      GameDemoPhase.countdown => 'Stand by',
      GameDemoPhase.failure => 'Sequence broken',
      GameDemoPhase.levelUp => 'System upgrade',
      GameDemoPhase.victory => 'Winner locked',
    };

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                headline,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: gameplayWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isInput
                    ? 'Tap in order before your rivals catch up.'
                    : 'Watch the board carefully before the turn flips.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: gameplayMuted,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _StatusBadge(
          label: step.isLeading ? 'LEADING' : 'LIVE',
          accent: step.isLeading ? gameplayGreen : gameplayBlue,
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
    return Column(
      children: <Widget>[
        const Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'TRACK POSITION',
                style: TextStyle(
                  fontSize: 10,
                  color: gameplayDim,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                ),
              ),
            ),
            Text(
              'MULTIPLAYER FEED',
              style: TextStyle(
                fontSize: 10,
                color: gameplayDim,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _ProgressRow(
          label: 'YOU',
          value: step.yourProgress,
          color: step.isLeading ? gameplayGreen : gameplayBlue,
          isYou: true,
        ),
        const SizedBox(height: 12),
        _ProgressRow(
          label: GameDemoSequence.opponents[0],
          value: step.opponentOneProgress,
          color: gameplayPurple,
        ),
        const SizedBox(height: 12),
        _ProgressRow(
          label: GameDemoSequence.opponents[1],
          value: step.opponentTwoProgress,
          color: gameplayAmber,
        ),
      ],
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
          width: 76,
          child: Row(
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: color.withValues(alpha: 0.42),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    color: isYou ? gameplayWhite : gameplayMuted,
                    fontWeight: isYou ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: gameplayPanelElevated,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Stack(
                children: <Widget>[
                  FractionallySizedBox(
                    widthFactor: value / 100,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[color, color.withValues(alpha: 0.75)],
                        ),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: color.withValues(alpha: 0.28),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 42,
          child: Text(
            '$value%',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w800,
            ),
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
    final Color accent = isPattern ? gameplayBlue : gameplayGreen;
    final IconData icon = isPattern
        ? Icons.visibility_rounded
        : Icons.touch_app_rounded;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Container(
        key: ValueKey<GameDemoPhase>(phase),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: accent.withValues(alpha: 0.28)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 14, color: accent),
            const SizedBox(width: 8),
            Text(
              isPattern ? 'MEMORIZE THE PATTERN' : 'YOUR TURN',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.7,
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SequenceFooter extends StatelessWidget {
  const _SequenceFooter({required this.step});

  final GameDemoStep step;

  @override
  Widget build(BuildContext context) {
    if (step.phase == GameDemoPhase.input) {
      return _StepDots(
        tapPosition: step.tapPosition ?? -1,
        totalSteps: step.pattern.length,
      );
    }

    return Row(
      children: <Widget>[
        const Icon(Icons.bolt_rounded, size: 16, color: gameplayBlue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Pattern length ${step.pattern.length} tiles',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: gameplayMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ),
        _StatusBadge(label: 'ROUND ${step.round}', accent: gameplayBlue),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.26)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: accent,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
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
      children: List<Widget>.generate(totalSteps, (int index) {
        final bool isDone = index < tapPosition;
        final bool isCurrent = index == tapPosition;
        final Color color = isDone
            ? gameplayGreen
            : isCurrent
            ? gameplayBlue
            : gameplayBorder;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 8),
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
              boxShadow: isDone || isCurrent
                  ? <BoxShadow>[
                      BoxShadow(
                        color: color.withValues(alpha: 0.30),
                        blurRadius: 10,
                      ),
                    ]
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
