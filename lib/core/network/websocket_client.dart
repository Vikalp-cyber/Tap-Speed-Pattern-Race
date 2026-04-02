import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants/app_constants.dart';
import '../utils/app_logger.dart';

abstract interface class WebSocketClient {
  Stream<Map<String, dynamic>> get messages;

  Future<void> connect();
  Future<void> disconnect();
  Future<void> send(Map<String, dynamic> event);
}

class SocketChannelWebSocketClient implements WebSocketClient {
  SocketChannelWebSocketClient({required this.uri});

  final Uri uri;
  final StreamController<Map<String, dynamic>> _messages =
      StreamController<Map<String, dynamic>>.broadcast();

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;

  @override
  Stream<Map<String, dynamic>> get messages => _messages.stream;

  @override
  Future<void> connect() async {
    if (_channel != null) {
      return;
    }

    _channel = WebSocketChannel.connect(uri);
    _subscription = _channel!.stream.listen(
      (dynamic message) {
        if (message is String) {
          _messages.add(jsonDecode(message) as Map<String, dynamic>);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.info('WebSocket error: $error');
      },
      onDone: () {
        _channel = null;
      },
    );
  }

  @override
  Future<void> disconnect() async {
    await _subscription?.cancel();
    await _channel?.sink.close();
    _subscription = null;
    _channel = null;
  }

  @override
  Future<void> send(Map<String, dynamic> event) async {
    _channel?.sink.add(jsonEncode(event));
  }
}

class MockWebSocketClient implements WebSocketClient {
  final StreamController<Map<String, dynamic>> _messages =
      StreamController<Map<String, dynamic>>.broadcast();

  final List<int> _pattern = <int>[0, 2, 1, 3, 0, 1, 3, 2];

  Timer? _matchFoundTimer;
  Timer? _patternTimer;
  Timer? _opponentTicker;
  bool _isConnected = false;
  bool _resultSent = false;
  int _localMatchedTiles = 0;
  int _opponentMatchedTiles = 0;

  @override
  Stream<Map<String, dynamic>> get messages => _messages.stream;

  @override
  Future<void> connect() async {
    if (_isConnected) {
      return;
    }

    _isConnected = true;
    _resultSent = false;
    _localMatchedTiles = 0;
    _opponentMatchedTiles = 0;

    _matchFoundTimer?.cancel();
    _patternTimer?.cancel();

    _matchFoundTimer = Timer(const Duration(milliseconds: 450), () {
      _emit(<String, dynamic>{
        'type': 'match_found',
        'matchId': 'match-neon-2048',
        'opponentName': 'Neon Lynx',
        'queueMs': 450,
      });
    });

    _patternTimer = Timer(const Duration(milliseconds: 1100), () {
      _emit(<String, dynamic>{
        'type': 'pattern_received',
        'pattern': _pattern,
        'round': 1,
      });
      _startOpponentSimulation();
    });
  }

  @override
  Future<void> disconnect() async {
    _matchFoundTimer?.cancel();
    _patternTimer?.cancel();
    _opponentTicker?.cancel();
    _isConnected = false;
  }

  @override
  Future<void> send(Map<String, dynamic> event) async {
    if (!_isConnected || _resultSent) {
      return;
    }

    final String type = event['type'] as String? ?? '';
    if (type != 'tile_tapped') {
      return;
    }

    final int tileId = event['tileId'] as int? ?? -1;
    final bool isValidTap =
        _localMatchedTiles < _pattern.length &&
        _pattern[_localMatchedTiles] == tileId;

    if (isValidTap) {
      _localMatchedTiles += 1;
    }

    _emit(<String, dynamic>{
      'type': 'progress_update',
      'playerId': 'local',
      'matchedTiles': _localMatchedTiles,
      'totalTiles': _pattern.length,
      'lastTapValid': isValidTap,
    });

    if (_localMatchedTiles == _pattern.length) {
      Future<void>.delayed(const Duration(milliseconds: 350), () {
        _emitResult(localWon: true);
      });
    }
  }

  void _startOpponentSimulation() {
    _opponentTicker?.cancel();
    _opponentTicker = Timer.periodic(const Duration(milliseconds: 1600), (_) {
      if (!_isConnected || _resultSent) {
        return;
      }

      if (_opponentMatchedTiles < _pattern.length - 1) {
        _opponentMatchedTiles += 1;
        _emit(<String, dynamic>{
          'type': 'progress_update',
          'playerId': 'opponent',
          'matchedTiles': _opponentMatchedTiles,
          'totalTiles': _pattern.length,
          'lastTapValid': true,
        });
      }
    });
  }

  void _emitResult({required bool localWon}) {
    if (!_isConnected || _resultSent) {
      return;
    }

    _resultSent = true;
    _opponentTicker?.cancel();

    _emit(<String, dynamic>{
      'type': 'game_result',
      'winnerId': localWon ? 'local' : 'opponent',
      'winnerName': localWon ? 'Guest Racer' : 'Neon Lynx',
      'localScore': _localMatchedTiles,
      'opponentScore': _opponentMatchedTiles,
      'summary': localWon
          ? 'You locked the pattern before your rival could finish.'
          : 'Neon Lynx edged ahead at the final split.',
    });
  }

  void _emit(Map<String, dynamic> event) {
    if (!_isConnected) {
      return;
    }

    AppLogger.info('Mock socket -> $event');
    _messages.add(event);
  }
}

WebSocketClient buildDefaultWebSocketClient() {
  return MockWebSocketClient();
}

Uri buildProductionSocketUri() {
  return Uri.parse(AppConstants.mockSocketUrl);
}
