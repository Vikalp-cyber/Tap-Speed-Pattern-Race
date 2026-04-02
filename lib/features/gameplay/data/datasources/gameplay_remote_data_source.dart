import '../../../../core/network/websocket_client.dart';
import '../../../../shared/models/socket_event_model.dart';

abstract interface class GameplayRemoteDataSource {
  Stream<GameSocketEventModel> watchEvents();
  Future<void> connect();
  Future<void> disconnect();
  Future<void> submitTileTap(int tileId);
}

class GameplayRemoteDataSourceImpl implements GameplayRemoteDataSource {
  GameplayRemoteDataSourceImpl({required WebSocketClient webSocketClient})
    : _webSocketClient = webSocketClient;

  final WebSocketClient _webSocketClient;

  @override
  Future<void> connect() => _webSocketClient.connect();

  @override
  Future<void> disconnect() => _webSocketClient.disconnect();

  @override
  Future<void> submitTileTap(int tileId) {
    return _webSocketClient.send(<String, dynamic>{
      'type': 'tile_tapped',
      'tileId': tileId,
    });
  }

  @override
  Stream<GameSocketEventModel> watchEvents() {
    return _webSocketClient.messages.map(GameSocketEventModel.fromJson);
  }
}
