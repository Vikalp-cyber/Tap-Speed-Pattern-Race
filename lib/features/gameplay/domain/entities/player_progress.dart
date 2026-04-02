class PlayerProgress {
  const PlayerProgress({
    required this.matchedTiles,
    required this.totalTiles,
    this.lastTapValid = true,
  });

  const PlayerProgress.empty()
    : matchedTiles = 0,
      totalTiles = 0,
      lastTapValid = true;

  final int matchedTiles;
  final int totalTiles;
  final bool lastTapValid;

  double get completion => totalTiles == 0 ? 0 : matchedTiles / totalTiles;

  bool get isComplete => totalTiles > 0 && matchedTiles >= totalTiles;

  PlayerProgress copyWith({
    int? matchedTiles,
    int? totalTiles,
    bool? lastTapValid,
  }) {
    return PlayerProgress(
      matchedTiles: matchedTiles ?? this.matchedTiles,
      totalTiles: totalTiles ?? this.totalTiles,
      lastTapValid: lastTapValid ?? this.lastTapValid,
    );
  }
}
