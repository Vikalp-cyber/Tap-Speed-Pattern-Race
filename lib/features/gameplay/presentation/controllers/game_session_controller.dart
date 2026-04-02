import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/analytics_service.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../domain/entities/gameplay_event.dart';
import '../../domain/entities/player_progress.dart';
import '../../domain/usecases/connect_to_matchmaking.dart';
import '../../domain/usecases/disconnect_matchmaking.dart';
import '../../domain/usecases/observe_gameplay_events.dart';
import '../../domain/usecases/submit_tile_tap.dart';

enum GameplayStatus {
  idle,
  connecting,
  queueing,
  ready,
  live,
  completed,
  error,
}

class GameSessionState {
  const GameSessionState({
    required this.status,
    required this.headline,
    required this.feedback,
    required this.matchId,
    required this.opponentName,
    required this.pattern,
    required this.round,
    required this.localProgress,
    required this.opponentProgress,
    this.result,
  });

  factory GameSessionState.initial() {
    return const GameSessionState(
      status: GameplayStatus.idle,
      headline: 'Booting neon arena',
      feedback: 'Connecting to live race mesh...',
      matchId: null,
      opponentName: 'Pending rival',
      pattern: <int>[],
      round: 1,
      localProgress: PlayerProgress.empty(),
      opponentProgress: PlayerProgress.empty(),
    );
  }

  final GameplayStatus status;
  final String headline;
  final String feedback;
  final String? matchId;
  final String opponentName;
  final List<int> pattern;
  final int round;
  final PlayerProgress localProgress;
  final PlayerProgress opponentProgress;
  final GameResult? result;

  GameSessionState copyWith({
    GameplayStatus? status,
    String? headline,
    String? feedback,
    String? matchId,
    String? opponentName,
    List<int>? pattern,
    int? round,
    PlayerProgress? localProgress,
    PlayerProgress? opponentProgress,
    GameResult? result,
  }) {
    return GameSessionState(
      status: status ?? this.status,
      headline: headline ?? this.headline,
      feedback: feedback ?? this.feedback,
      matchId: matchId ?? this.matchId,
      opponentName: opponentName ?? this.opponentName,
      pattern: pattern ?? this.pattern,
      round: round ?? this.round,
      localProgress: localProgress ?? this.localProgress,
      opponentProgress: opponentProgress ?? this.opponentProgress,
      result: result ?? this.result,
    );
  }
}

final gameSessionControllerProvider =
    NotifierProvider<GameSessionController, GameSessionState>(
      GameSessionController.new,
    );

class GameSessionController extends Notifier<GameSessionState> {
  late final ConnectToMatchmaking _connectToMatchmaking;
  late final DisconnectMatchmaking _disconnectMatchmaking;
  late final ObserveGameplayEvents _observeGameplayEvents;
  late final SubmitTileTap _submitTileTap;
  late final AnalyticsService _analyticsService;

  StreamSubscription<GameplayEvent>? _eventsSubscription;
  bool _initialized = false;

  @override
  GameSessionState build() {
    _connectToMatchmaking = ref.read(connectToMatchmakingProvider);
    _disconnectMatchmaking = ref.read(disconnectMatchmakingProvider);
    _observeGameplayEvents = ref.read(observeGameplayEventsProvider);
    _submitTileTap = ref.read(submitTileTapProvider);
    _analyticsService = ref.read(analyticsServiceProvider);

    ref.onDispose(() {
      _eventsSubscription?.cancel();
      _disconnectMatchmaking();
    });

    return GameSessionState.initial();
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _initialized = true;
    state = state.copyWith(
      status: GameplayStatus.connecting,
      headline: 'Connecting to arena',
      feedback: 'Negotiating real-time match session...',
    );

    _eventsSubscription = _observeGameplayEvents().listen(_consumeEvent);
    await _connectToMatchmaking();
    await _analyticsService.trackEvent('game_session_connected');

    state = state.copyWith(
      status: GameplayStatus.queueing,
      headline: 'Searching for rival',
      feedback: 'Matchmaking is warming up the next pattern race.',
    );
  }

  Future<void> submitValidatedTap(
    int tileId,
    PlayerProgress localProgress,
  ) async {
    state = state.copyWith(
      localProgress: localProgress,
      feedback: localProgress.isComplete
          ? 'Finish line reached. Waiting for referee confirmation...'
          : 'Perfect tap. Keep the combo alive.',
    );

    await _submitTileTap(tileId);
    await _analyticsService.trackEvent(
      'tile_tapped',
      parameters: <String, Object?>{
        'tileId': tileId,
        'matchedTiles': localProgress.matchedTiles,
      },
    );
  }

  void registerInvalidTap(int tileId) {
    state = state.copyWith(
      feedback: 'Tile $tileId broke the pattern. Follow the highlighted lane.',
    );
  }

  void _consumeEvent(GameplayEvent event) {
    switch (event) {
      case MatchFound():
        state = state.copyWith(
          status: GameplayStatus.ready,
          matchId: event.matchId,
          opponentName: event.opponentName,
          headline: 'Match found',
          feedback:
              'Opponent ${event.opponentName} locked in after ${event.queueDuration.inMilliseconds}ms.',
        );
      case PatternReceived():
        state = state.copyWith(
          status: GameplayStatus.live,
          pattern: event.pattern,
          round: event.round,
          localProgress: PlayerProgress(
            matchedTiles: 0,
            totalTiles: event.pattern.length,
          ),
          opponentProgress: PlayerProgress(
            matchedTiles: 0,
            totalTiles: event.pattern.length,
          ),
          headline: 'Round ${event.round} live',
          feedback:
              'Tap the glowing tiles in order before your rival catches up.',
        );
      case ProgressUpdate():
        if (event.isLocalPlayer) {
          state = state.copyWith(
            localProgress: event.progress,
            feedback: event.progress.lastTapValid
                ? 'Server accepted your input.'
                : 'Server rejected that tap. Recover with the highlighted tile.',
          );
        } else {
          state = state.copyWith(opponentProgress: event.progress);
        }
      case GameResult():
        state = state.copyWith(
          status: GameplayStatus.completed,
          result: event,
          headline: event.didLocalPlayerWin ? 'Victory secured' : 'Round lost',
          feedback: event.summary,
        );
        _analyticsService.trackEvent(
          'game_result',
          parameters: <String, Object?>{
            'winnerId': event.winnerId,
            'localScore': event.localScore,
            'opponentScore': event.opponentScore,
          },
        );
    }
  }
}
