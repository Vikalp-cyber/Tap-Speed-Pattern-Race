class ValidationSystem {
  bool validate({required int tileId, required int? expectedTileId}) {
    return expectedTileId != null && tileId == expectedTileId;
  }
}
