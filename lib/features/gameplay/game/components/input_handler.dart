import '../../domain/entities/player_progress.dart';
import '../systems/pattern_system.dart';
import '../systems/progress_system.dart';
import '../systems/validation_system.dart';

class PlayerInputResolution {
  const PlayerInputResolution({required this.isValid, required this.progress});

  final bool isValid;
  final PlayerProgress progress;
}

class PlayerInputHandler {
  PlayerInputHandler({
    required PatternSystem patternSystem,
    required ValidationSystem validationSystem,
    required ProgressSystem progressSystem,
  }) : _patternSystem = patternSystem,
       _validationSystem = validationSystem,
       _progressSystem = progressSystem;

  final PatternSystem _patternSystem;
  final ValidationSystem _validationSystem;
  final ProgressSystem _progressSystem;

  void resetPattern(List<int> pattern) {
    _patternSystem.loadPattern(pattern);
    _progressSystem.reset(totalTiles: pattern.length);
  }

  void syncProgress(PlayerProgress progress) {
    _patternSystem.syncProgress(progress.matchedTiles);
    _progressSystem.sync(progress);
  }

  PlayerInputResolution handleTap(int tileId) {
    final bool isValid = _validationSystem.validate(
      tileId: tileId,
      expectedTileId: _patternSystem.expectedTileId,
    );

    if (!isValid) {
      return PlayerInputResolution(
        isValid: false,
        progress: _progressSystem.reject(),
      );
    }

    _patternSystem.advance();
    return PlayerInputResolution(
      isValid: true,
      progress: _progressSystem.advance(),
    );
  }
}
