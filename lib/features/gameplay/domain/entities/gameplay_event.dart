import 'player_progress.dart';

sealed class GameplayEvent {
  const GameplayEvent();
}

class MatchFound extends GameplayEvent {
  const MatchFound({
    required this.matchId,
    required this.opponentName,
    required this.queueDuration,
  });

  final String matchId;
  final String opponentName;
  final Duration queueDuration;
}

class PatternReceived extends GameplayEvent {
  const PatternReceived({required this.pattern, required this.round});

  final List<int> pattern;
  final int round;
}

class ProgressUpdate extends GameplayEvent {
  const ProgressUpdate({required this.playerId, required this.progress});

  final String playerId;
  final PlayerProgress progress;

  bool get isLocalPlayer => playerId == 'local';
}

class GameResult extends GameplayEvent {
  const GameResult({
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

  bool get didLocalPlayerWin => winnerId == 'local';
}
