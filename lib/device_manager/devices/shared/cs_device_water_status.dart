
enum CsDeviceWaterStatus {
  unknown(-1),
  waterOn(0),
  waterOff(1);

  const CsDeviceWaterStatus(this.value);
  final int value;

  static CsDeviceWaterStatus fromInt(int value) {
    return CsDeviceWaterStatus.values.firstWhere((e) => e.value == value, orElse: () => unknown);
  }
}
