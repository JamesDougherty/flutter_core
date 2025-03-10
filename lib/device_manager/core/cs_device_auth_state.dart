enum CsDeviceAuthState {
  unauthenticated(0),
  authenticated(1);

  const CsDeviceAuthState(this.value);
  final int value;

  static CsDeviceAuthState fromInt(int value) {
    return CsDeviceAuthState.values.firstWhere((e) => e.value == value, orElse: () => unauthenticated);
  }
}
