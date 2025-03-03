class CsBleRssiAverage {
  final List<int> _window = List<int>.filled(12, 0);
  int _numberOfElements = 0;
  int _average = 0;
  int _index = 0;
  int _sum = 0;

  ///
  /// Get the average RSSI value.
  ///
  int get average => _average;

  ///
  /// Method to compute and update the average RSSI value.
  ///
  void update(int value) {
    _average = _next(value);
  }

  ///
  /// Method to calculate the next average RSSI value.
  ///
  int _next(int value) {
    if (_numberOfElements < _window.length) {
      _numberOfElements++;
    }

    _sum -= _window[_index];
    _sum += value;
    _window[_index] = value;
    _index = (_index + 1) % _window.length;

    return (_sum / _numberOfElements).toInt();
  }
}
