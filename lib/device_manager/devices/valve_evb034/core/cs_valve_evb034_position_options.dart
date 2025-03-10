
enum CsValveEvb034PositionOptions {
  none(0x0000),
  forwardOnly(0x0001),
  aerationPosition(0x0002),
  openTwedoValve(0x0004),
  timeIsSeconds(0x0008),
  timeNotAdjustable(0x0010),
  recoveryPosition(0x0020),
  creepIntoPosition(0x0040),
  edgeCreepIntoPosition(0x0080),
  timeIsSaltPounds(0x0100),
  brineFillPosition(0x0200),
  airCycle(0x0400),
  commercialBrineLineFlowControl(0x0800),
  turnOnPowerOutput1(0x1000),
  turnOnPowerOutput2(0x2000),
  skipForwardOnly(0x4000);

  const CsValveEvb034PositionOptions(this.value);
  final int value;

  static CsValveEvb034PositionOptions fromInt(int value) {
    return CsValveEvb034PositionOptions.values.firstWhere((e) => e.value == value, orElse: () => none);
  }
}
