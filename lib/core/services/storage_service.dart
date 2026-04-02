abstract interface class StorageService {
  Future<void> writeString(String key, String value);
  Future<String?> readString(String key);
}

class InMemoryStorageService implements StorageService {
  final Map<String, String> _cache = <String, String>{};

  @override
  Future<String?> readString(String key) async => _cache[key];

  @override
  Future<void> writeString(String key, String value) async {
    _cache[key] = value;
  }
}
