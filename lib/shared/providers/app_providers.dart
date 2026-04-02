import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../core/network/websocket_client.dart';
import '../../core/services/analytics_service.dart';
import '../../core/services/storage_service.dart';
import '../../features/auth/data/auth_repository_impl.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/gameplay/data/datasources/gameplay_remote_data_source.dart';
import '../../features/gameplay/data/repositories/gameplay_repository_impl.dart';
import '../../features/gameplay/domain/repositories/gameplay_repository.dart';
import '../../features/gameplay/domain/usecases/connect_to_matchmaking.dart';
import '../../features/gameplay/domain/usecases/disconnect_matchmaking.dart';
import '../../features/gameplay/domain/usecases/observe_gameplay_events.dart';
import '../../features/gameplay/domain/usecases/submit_tile_tap.dart';

final storageServiceProvider = Provider<StorageService>((Ref ref) {
  return InMemoryStorageService();
});

final analyticsServiceProvider = Provider<AnalyticsService>((Ref ref) {
  return ConsoleAnalyticsService();
});

final apiClientProvider = Provider<ApiClient>((Ref ref) {
  return MockApiClient();
});

final authRepositoryProvider = Provider<AuthRepository>((Ref ref) {
  return AuthRepositoryImpl();
});

final webSocketClientProvider = Provider<WebSocketClient>((Ref ref) {
  return buildDefaultWebSocketClient();
});

final gameplayRemoteDataSourceProvider = Provider<GameplayRemoteDataSource>((
  Ref ref,
) {
  return GameplayRemoteDataSourceImpl(
    webSocketClient: ref.watch(webSocketClientProvider),
  );
});

final gameplayRepositoryProvider = Provider<GameplayRepository>((Ref ref) {
  return GameplayRepositoryImpl(
    remoteDataSource: ref.watch(gameplayRemoteDataSourceProvider),
  );
});

final connectToMatchmakingProvider = Provider<ConnectToMatchmaking>((Ref ref) {
  return ConnectToMatchmaking(ref.watch(gameplayRepositoryProvider));
});

final disconnectMatchmakingProvider = Provider<DisconnectMatchmaking>((
  Ref ref,
) {
  return DisconnectMatchmaking(ref.watch(gameplayRepositoryProvider));
});

final observeGameplayEventsProvider = Provider<ObserveGameplayEvents>((
  Ref ref,
) {
  return ObserveGameplayEvents(ref.watch(gameplayRepositoryProvider));
});

final submitTileTapProvider = Provider<SubmitTileTap>((Ref ref) {
  return SubmitTileTap(ref.watch(gameplayRepositoryProvider));
});
