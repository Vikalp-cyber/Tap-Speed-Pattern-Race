class PatternSystem {
  List<int> _pattern = const <int>[];
  int _currentStep = 0;

  List<int> get pattern => List<int>.unmodifiable(_pattern);
  int get currentStep => _currentStep;
  int get totalSteps => _pattern.length;
  int? get expectedTileId =>
      _currentStep < _pattern.length ? _pattern[_currentStep] : null;

  void loadPattern(List<int> pattern) {
    _pattern = List<int>.unmodifiable(pattern);
    _currentStep = 0;
  }

  void advance() {
    if (_currentStep < _pattern.length) {
      _currentStep += 1;
    }
  }

  void syncProgress(int matchedTiles) {
    _currentStep = matchedTiles.clamp(0, _pattern.length);
  }
}
