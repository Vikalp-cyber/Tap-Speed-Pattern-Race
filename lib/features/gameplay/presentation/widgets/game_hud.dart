import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/neon_panel.dart';
import '../../domain/entities/player_progress.dart';
import '../controllers/game_session_controller.dart';
import 'status_chip.dart';

class GameHud extends StatelessWidget {
  const GameHud({required this.state, super.key});

  final GameSessionState state;

  @override
  Widget build(BuildContext context) {
    return NeonPanel(
      accentColor: AppTheme.neonGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            state.headline,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(state.feedback, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              StatusChip(
                label: 'Opponent',
                value: state.opponentName,
                accent: AppTheme.neonCyan,
              ),
              StatusChip(
                label: 'Round',
                value: state.round.toString(),
                accent: AppTheme.neonOrange,
              ),
              StatusChip(
                label: 'Match',
                value: state.matchId ?? 'Queueing',
                accent: AppTheme.neonPink,
              ),
            ],
          ),
          const SizedBox(height: 18),
          _ProgressLane(
            label: 'You',
            progress: state.localProgress,
            accent: AppTheme.neonGreen,
          ),
          const SizedBox(height: 12),
          _ProgressLane(
            label: state.opponentName,
            progress: state.opponentProgress,
            accent: AppTheme.neonPink,
          ),
          if (state.result != null) ...<Widget>[
            const SizedBox(height: 18),
            Text(
              '${state.result!.winnerName} won ${state.result!.localScore}-${state.result!.opponentScore}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgressLane extends StatelessWidget {
  const _ProgressLane({
    required this.label,
    required this.progress,
    required this.accent,
  });

  final String label;
  final PlayerProgress progress;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final int safeTotal = progress.totalTiles == 0 ? 1 : progress.totalTiles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(label, style: Theme.of(context).textTheme.titleMedium),
            Text(
              '${progress.matchedTiles}/$safeTotal',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            minHeight: 12,
            value: progress.completion,
            backgroundColor: const Color(0xFF112439),
            color: accent,
          ),
        ),
      ],
    );
  }
}
