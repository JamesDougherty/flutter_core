enum CsValveEvb034RegenState {
  idle(0),
  movingToNextPosition(1),
  movingToFinalPosition(2),
  twedoWaitingForMotorState(3),
  waitingForTwedoState(4),
  waitingInPosition(5),
  movingToService(6),
  movingToBypass(7),
  inBypass(8),
  movingToBrineSoak(9),
  waitingInBrineSoak(10),
  movingToCreepPosition(11),
  creepingToPosition(12);

  const CsValveEvb034RegenState(this.value);
  final int value;

  static CsValveEvb034RegenState fromInt(int value) {
    return CsValveEvb034RegenState.values.firstWhere((e) => e.value == value, orElse: () => idle);
  }
}
