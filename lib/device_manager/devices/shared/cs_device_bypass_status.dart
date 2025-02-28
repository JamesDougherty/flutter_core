
enum CsDeviceBypassStatus {
  unknown(-1),
  bypassOff(0),
  bypassOn(1);

  const CsDeviceBypassStatus(this.value);
  final int value;

  static CsDeviceBypassStatus fromInt(int value) {
    return CsDeviceBypassStatus.values.firstWhere((e) => e.value == value, orElse: () => unknown);
  }
}
