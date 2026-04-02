import '../entities/gameplay_event.dart';

abstract interface class GameplayRepository {
  Stream<GameplayEvent> watchGameplayEvents();
  Future<void> connect();
  Future<void> disconnect();
  Future<void> submitTileTap(int tileId);
}
