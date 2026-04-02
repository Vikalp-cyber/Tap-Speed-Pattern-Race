import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/entities/player_progress.dart';
import 'components/input_handler.dart';
import 'components/pattern_player.dart';
import 'components/tile_component.dart';
import 'systems/pattern_system.dart';
import 'systems/progress_system.dart';
import 'systems/validation_system.dart';

typedef ValidatedTapCallback =
    Future<void> Function(int tileId, PlayerProgress progress);

typedef InvalidTapCallback = void Function(int tileId);

class TapSpeedGame extends FlameGame {
  TapSpeedGame({required this.onValidatedTap, required this.onInvalidTap});

  final ValidatedTapCallback onValidatedTap;
  final InvalidTapCallback onInvalidTap;

  late final PatternSystem _patternSystem;
  late final ValidationSystem _validationSystem;
  late final ProgressSystem _progressSystem;
  late final PlayerInputHandler _inputHandler;
  late final PatternPlayer _patternPlayer;

  final Map<int, TileComponent> _tiles = <int, TileComponent>{};

  List<int> _activePattern = const <int>[];
  bool _interactionEnabled = false;
  bool _boardReady = false;

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    _patternSystem = PatternSystem();
    _validationSystem = ValidationSystem();
    _progressSystem = ProgressSystem();
    _inputHandler = PlayerInputHandler(
      patternSystem: _patternSystem,
      validationSystem: _validationSystem,
      progressSystem: _progressSystem,
    );

    _patternPlayer = PatternPlayer();
    add(_patternPlayer);

    for (int index = 0; index < 4; index += 1) {
      final TileComponent tile = TileComponent(
        tileId: index,
        label: '${index + 1}',
        onTileTapped: _handleTileTap,
      );
      _tiles[index] = tile;
      add(tile);
    }

    _boardReady = true;
    _layoutComponents();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _layoutComponents();
  }

  void loadPattern(List<int> pattern) {
    if (listEquals(pattern, _activePattern) || pattern.isEmpty) {
      return;
    }

    _activePattern = List<int>.from(pattern);
    _interactionEnabled = true;
    _inputHandler.resetPattern(pattern);
    _patternPlayer.loadPattern(pattern.length);
    _patternPlayer.updateProgress(0);
    _syncTileHighlights();
  }

  void syncLocalProgress(PlayerProgress progress) {
    if (progress.totalTiles == 0) {
      return;
    }

    _inputHandler.syncProgress(progress);
    _patternPlayer.updateProgress(progress.matchedTiles);
    _interactionEnabled = !progress.isComplete;
    _syncTileHighlights();
  }

  void freezeBoard() {
    _interactionEnabled = false;
  }

  void _layoutComponents() {
    if (!_boardReady) {
      return;
    }

    _patternPlayer
      ..position = Vector2(24, 24)
      ..size = Vector2(size.x - 48, 18);

    const double gap = 16;
    final double availableWidth = size.x - 48;
    final double boardTop = 76;
    final double availableHeight = size.y - boardTop - 24;
    final double tileSize = ((availableWidth - gap) / 2).clamp(
      96,
      availableHeight / 2 - gap,
    );
    final double boardWidth = (tileSize * 2) + gap;
    final double boardHeight = (tileSize * 2) + gap;
    final double startX = (size.x - boardWidth) / 2;
    final double startY = boardTop + ((availableHeight - boardHeight) / 2);

    for (int index = 0; index < 4; index += 1) {
      final int row = index ~/ 2;
      final int column = index % 2;
      _tiles[index]
        ?..position = Vector2(
          startX + (column * (tileSize + gap)),
          startY + (row * (tileSize + gap)),
        )
        ..size = Vector2.all(tileSize);
    }
  }

  void _syncTileHighlights() {
    final int? expectedTileId = _patternSystem.expectedTileId;
    for (final MapEntry<int, TileComponent> entry in _tiles.entries) {
      entry.value.setHighlighted(entry.key == expectedTileId);
    }
  }

  void _handleTileTap(int tileId) {
    unawaited(_processTileTap(tileId));
  }

  Future<void> _processTileTap(int tileId) async {
    if (!_interactionEnabled || _activePattern.isEmpty) {
      return;
    }

    final PlayerInputResolution resolution = _inputHandler.handleTap(tileId);
    _tiles[tileId]?.flash(success: resolution.isValid);
    _patternPlayer.updateProgress(resolution.progress.matchedTiles);
    _syncTileHighlights();

    if (!resolution.isValid) {
      onInvalidTap(tileId + 1);
      return;
    }

    _interactionEnabled = !resolution.progress.isComplete;
    await onValidatedTap(tileId, resolution.progress);
  }
}
