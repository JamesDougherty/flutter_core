enum CsValveEvb034Series {
  ///
  /// Unknown series.
  ///
  unknown(0),

  ///
  /// Series 2 (D12)
  ///
  series2(2),

  ///
  /// Series 3 (D15)
  ///
  series3(3),

  ///
  /// Series 4 (CS125)
  ///
  series4(4),

  ///
  /// Series 5 (CS150)
  ///
  series5(5),

  ///
  /// Series 6 (CS121)
  ///
  series6(6);

  const CsValveEvb034Series(this.value);
  final int value;

  static CsValveEvb034Series fromInt(int value) {
    return CsValveEvb034Series.values.firstWhere((e) => e.value == value, orElse: () => unknown);
  }
}
