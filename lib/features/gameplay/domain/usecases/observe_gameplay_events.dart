import '../entities/gameplay_event.dart';
import '../repositories/gameplay_repository.dart';

class ObserveGameplayEvents {
  const ObserveGameplayEvents(this._repository);

  final GameplayRepository _repository;

  Stream<GameplayEvent> call() => _repository.watchGameplayEvents();
}
