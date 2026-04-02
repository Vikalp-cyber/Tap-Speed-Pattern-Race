import '../repositories/gameplay_repository.dart';

class DisconnectMatchmaking {
  const DisconnectMatchmaking(this._repository);

  final GameplayRepository _repository;

  Future<void> call() => _repository.disconnect();
}
