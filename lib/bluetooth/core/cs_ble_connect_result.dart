///
/// The result of a connection attempt.
///
enum CsBleConnectResult {
  ///
  /// The connection was successful.
  ///
  success,

  ///
  /// The device is NULL.
  ///
  invalidDevice,

  ///
  /// The device is already connected.
  ///
  alreadyConnected,
}
