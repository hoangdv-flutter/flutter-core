part of 'exts.dart';


extension IntExt on int {
  String millisToDateFormat({String format = "dd/MM/yyyy"}) {
    return DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(this));
  }

  String get secondsToTimeCountDown {
    var minute = this ~/ 60;
    var seconds = this % 60;
    return sprintf("%02d : %02d", [minute, seconds]);
  }

  String get toDateTime {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(this);
    return "${sprintf("%02d", [dateTime.day])}/${sprintf("%02d", [
          dateTime.month
        ])}/${sprintf("%02d", [dateTime.year])}";
  }

  String get secondsToTimeFormatter {
    Duration duration = Duration(seconds: this);

    List<int> durations = [];
    if (duration.inHours > 0) {
      durations.add(duration.inHours);
    }
    durations.add(duration.inMinutes);
    durations.add(duration.inSeconds);

    return durations
        .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }
}
