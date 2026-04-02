import '../repositories/gameplay_repository.dart';

class SubmitTileTap {
  const SubmitTileTap(this._repository);

  final GameplayRepository _repository;

  Future<void> call(int tileId) => _repository.submitTileTap(tileId);
}
