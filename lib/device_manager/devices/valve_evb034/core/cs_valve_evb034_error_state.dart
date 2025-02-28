
enum CsValveEvb034ErrorState {
  noError(0),
  lostHome(2),
  notSeeingSlotsNormalMotorCurrent(3),
  unableToFindHomingSlot(4),
  notSeeingSlotsHighMotorCurrent(5),
  notSeeingSlotsNoMotorCurrent(6),
  twedoMotorTimeout(7);

  const CsValveEvb034ErrorState(this.value);
  final int value;

  static CsValveEvb034ErrorState fromInt(int value) {
    return CsValveEvb034ErrorState.values.firstWhere((e) => e.value == value, orElse: () => noError);
  }
}
