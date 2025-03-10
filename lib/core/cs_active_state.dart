enum CsActiveState {
  inactive(0),
  active(1);

  const CsActiveState(this.value);
  final int value;

  static CsActiveState fromInt(int value) {
    return CsActiveState.values.firstWhere((e) => e.value == value, orElse: () => inactive);
  }
}
