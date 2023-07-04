import 'package:sprintf/sprintf.dart';

extension DurationExt on Duration {
  String get toMinuteAndSeconds {
    final seconds = inSeconds;
    return sprintf("%02d:%02d", [seconds ~/ 60, seconds % 60]);
  }
}
