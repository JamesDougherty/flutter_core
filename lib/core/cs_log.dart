import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

///
/// Logging class that will log messages to the console in debug mode only.
///
class CsLog {
  static final Logger _logger = Logger(
    level: kReleaseMode ? Level.off : Level.all,
    printer: kReleaseMode ? null : PrettyPrinter(),
    output: kReleaseMode ? null : ConsoleOutput(),
  );

  ///
  /// Info log message.
  ///
  /// **Parameters**
  /// - `message` - Log message.
  /// - `time` - Time of the log message.
  /// - `error` - Error object.
  /// - `stackTrace` - Stack trace of the error.
  static void i(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _logger.i(message, time: time, error: error, stackTrace: stackTrace);
  }

  ///
  /// Debug log message.
  ///
  /// **Parameters**
  /// - `message` - Log message.
  /// - `time` - Time of the log message.
  /// - `error` - Error object.
  /// - `stackTrace` - Stack trace of the error.
  ///
  static void d(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _logger.d(message, time: time, error: error, stackTrace: stackTrace);
  }

  ///
  /// Warning log message.
  ///
  /// **Parameters**
  /// - `message` - Log message.
  /// - `time` - Time of the log message.
  /// - `error` - Error object.
  /// - `stackTrace` - Stack trace of the error.
  ///
  static void w(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _logger.w(message, time: time, error: error, stackTrace: stackTrace);
  }

  ///
  /// Error log message.
  ///
  /// **Parameters**
  /// - `message` - Log message.
  /// - `time` - Time of the log message.
  /// - `error` - Error object.
  /// - `stackTrace` - Stack trace of the error.
  ///
  static void e(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _logger.e(message, time: time, error: error, stackTrace: stackTrace);
  }

  ///
  /// Fatal error log message.
  ///
  /// **Parameters**
  /// - `message` - Log message.
  /// - `time` - Time of the log message.
  /// - `error` - Error object.
  /// - `stackTrace` - Stack trace of the error.
  ///
  static void f(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _logger.f(message, time: time, error: error, stackTrace: stackTrace);
  }

  ///
  /// Trace / Verbose log message.
  ///
  /// **Parameters**
  /// - `message` - Log message.
  /// - `time` - Time of the log message.
  /// - `error` - Error object.
  /// - `stackTrace` - Stack trace of the error.
  ///
  static void t(dynamic message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _logger.t(message, time: time, error: error, stackTrace: stackTrace);
  }
}
