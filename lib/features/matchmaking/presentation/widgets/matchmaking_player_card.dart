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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: ShapeDecoration(
        gradient: matchmakingPanelGradient,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: matchmakingBlue.withValues(alpha: 0.38)),
        ),
        shadows: <BoxShadow>[
          BoxShadow(
            color: matchmakingBlue.withValues(alpha: 0.18),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: matchmakingBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: matchmakingBlue.withValues(alpha: 0.28),
              ),
            ),
            child: Text(
              'LOCKED IN',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: matchmakingBlue,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: matchmakingBlue.withValues(alpha: 0.34),
                  blurRadius: 26,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[matchmakingPurple, matchmakingBlueDeep],
                ),
                border: Border.all(color: matchmakingBlue, width: 1.8),
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: matchmakingWhite.withValues(alpha: 0.08),
                    border: Border.all(
                      color: matchmakingWhite.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            playerName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: matchmakingWhite,
              fontWeight: FontWeight.w700,
              fontSize: 15,
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
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: matchmakingGreen,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: matchmakingGreen.withValues(alpha: 0.45),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'LOW LATENCY LINK',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: matchmakingMuted,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
