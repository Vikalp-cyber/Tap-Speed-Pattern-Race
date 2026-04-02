abstract interface class ApiClient {
  Future<Map<String, dynamic>> get(String path);
}

class MockApiClient implements ApiClient {
  @override
  Future<Map<String, dynamic>> get(String path) async {
    return <String, dynamic>{'path': path, 'status': 'ok'};
  }
}
