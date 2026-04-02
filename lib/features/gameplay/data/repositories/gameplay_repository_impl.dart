import '../../../../shared/models/socket_event_model.dart';
import '../../domain/entities/gameplay_event.dart';
import '../../domain/entities/player_progress.dart';
import '../../domain/repositories/gameplay_repository.dart';
import '../datasources/gameplay_remote_data_source.dart';

class GameplayRepositoryImpl implements GameplayRepository {
  GameplayRepositoryImpl({required GameplayRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final GameplayRemoteDataSource _remoteDataSource;

  @override
  Future<void> connect() => _remoteDataSource.connect();

  @override
  Future<void> disconnect() => _remoteDataSource.disconnect();

  @override
  Future<void> submitTileTap(int tileId) =>
      _remoteDataSource.submitTileTap(tileId);

  @override
  Stream<GameplayEvent> watchGameplayEvents() {
    return _remoteDataSource.watchEvents().map(_mapEvent);
  }

  GameplayEvent _mapEvent(GameSocketEventModel event) {
    return switch (event) {
      MatchFoundModel() => MatchFound(
        matchId: event.matchId,
        opponentName: event.opponentName,
        queueDuration: Duration(milliseconds: event.queueMs),
      ),
      PatternReceivedModel() => PatternReceived(
        pattern: event.pattern,
        round: event.round,
      ),
      ProgressUpdateModel() => ProgressUpdate(
        playerId: event.playerId,
        progress: PlayerProgress(
          matchedTiles: event.matchedTiles,
          totalTiles: event.totalTiles,
          lastTapValid: event.lastTapValid,
        ),
      ),
      GameResultModel() => GameResult(
        winnerId: event.winnerId,
        winnerName: event.winnerName,
        localScore: event.localScore,
        opponentScore: event.opponentScore,
        summary: event.summary,
      ),
    };
  }
}
