import '../../domain/entities/player_progress.dart';

class ProgressSystem {
  PlayerProgress _progress = const PlayerProgress.empty();

  PlayerProgress get progress => _progress;

  void reset({required int totalTiles}) {
    _progress = PlayerProgress(matchedTiles: 0, totalTiles: totalTiles);
  }

  PlayerProgress advance() {
    final int nextStep = (_progress.matchedTiles + 1).clamp(
      0,
      _progress.totalTiles,
    );
    _progress = _progress.copyWith(matchedTiles: nextStep, lastTapValid: true);
    return _progress;
  }

  PlayerProgress reject() {
    _progress = _progress.copyWith(lastTapValid: false);
    return _progress;
  }

  void sync(PlayerProgress progress) {
    _progress = progress;
  }
}
