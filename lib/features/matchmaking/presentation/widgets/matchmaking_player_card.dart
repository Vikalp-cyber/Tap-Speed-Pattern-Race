import 'package:flutter/material.dart';

import '../matchmaking_tokens.dart';

class MatchmakingPlayerCard extends StatelessWidget {
  const MatchmakingPlayerCard({
    required this.playerName,
    this.levelLabel = 'LVL 12',
    super.key,
  });

  final String playerName;
  final String levelLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: matchmakingPanel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: matchmakingBlue, width: 1.5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: matchmakingBlue.withValues(alpha: 0.3),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[matchmakingPurple, matchmakingBlue],
              ),
              border: Border.all(color: matchmakingBg, width: 2),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            playerName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: matchmakingWhite,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            levelLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: matchmakingBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
