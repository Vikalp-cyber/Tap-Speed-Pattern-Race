sealed class GameSocketEventModel {
  const GameSocketEventModel();

  factory GameSocketEventModel.fromJson(Map<String, dynamic> json) {
    final String type = json['type'] as String? ?? '';

    switch (type) {
      case 'match_found':
        return MatchFoundModel(
          matchId: json['matchId'] as String? ?? '',
          opponentName: json['opponentName'] as String? ?? 'Unknown Rival',
          queueMs: json['queueMs'] as int? ?? 0,
        );
      case 'pattern_received':
        return PatternReceivedModel(
          pattern: List<int>.from(
            json['pattern'] as List<dynamic>? ?? <dynamic>[],
          ),
          round: json['round'] as int? ?? 1,
        );
      case 'progress_update':
        return ProgressUpdateModel(
          playerId: json['playerId'] as String? ?? 'unknown',
          matchedTiles: json['matchedTiles'] as int? ?? 0,
          totalTiles: json['totalTiles'] as int? ?? 0,
          lastTapValid: json['lastTapValid'] as bool? ?? true,
        );
      case 'game_result':
        return GameResultModel(
          winnerId: json['winnerId'] as String? ?? 'unknown',
          winnerName: json['winnerName'] as String? ?? 'Unknown',
          localScore: json['localScore'] as int? ?? 0,
          opponentScore: json['opponentScore'] as int? ?? 0,
          summary: json['summary'] as String? ?? '',
        );
      default:
        throw UnsupportedError('Unknown socket event type: $type');
    }
  }
}

class MatchFoundModel extends GameSocketEventModel {
  const MatchFoundModel({
    required this.matchId,
    required this.opponentName,
    required this.queueMs,
  });

  final String matchId;
  final String opponentName;
  final int queueMs;
}

class PatternReceivedModel extends GameSocketEventModel {
  const PatternReceivedModel({required this.pattern, required this.round});

  final List<int> pattern;
  final int round;
}

class ProgressUpdateModel extends GameSocketEventModel {
  const ProgressUpdateModel({
    required this.playerId,
    required this.matchedTiles,
    required this.totalTiles,
    required this.lastTapValid,
  });

  final String playerId;
  final int matchedTiles;
  final int totalTiles;
  final bool lastTapValid;
}

class GameResultModel extends GameSocketEventModel {
  const GameResultModel({
    required this.winnerId,
    required this.winnerName,
    required this.localScore,
    required this.opponentScore,
    required this.summary,
  });

  final String winnerId;
  final String winnerName;
  final int localScore;
  final int opponentScore;
  final String summary;
}
