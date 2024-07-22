part of 'util.dart';

class CrashlyticsLogger {
  static var _lastLog = "";

  static void logError(String message) {
    if (_lastLog == message) return;
    _lastLog = message;
    // FirebaseCrashlytics.instance.log(message);
  }
}
