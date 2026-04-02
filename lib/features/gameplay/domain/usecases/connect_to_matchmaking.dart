import '../repositories/gameplay_repository.dart';

class ConnectToMatchmaking {
  const ConnectToMatchmaking(this._repository);

  final GameplayRepository _repository;

  Future<void> call() => _repository.connect();
}
