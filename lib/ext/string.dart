import 'package:flutter/material.dart';
import 'package:flutter_core/ext/list.dart';
import 'package:flutter_core/core.dart';

extension StringExt on String? {
  bool get isNullOrEmpty => this?.isEmpty != false;
}

extension StringNonNullExt on String {
  Color toColor() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String appendUrlPath(String path) {
    return ("$this/$path")
        .replaceAll(RegExp(r'\/{2,}'), "/")
        .replaceAll(":/", "://");
  }

  String get splitMoney {
    String getResultWithDot(String result) => result.let(
          call: (value) => result.isEmpty ? result : ".$result",
        );

    final arr = split(".");
    var number = arr.firstOrNull;
    if (number.isNullOrEmpty) return this;
    var result = "";
    while (number!.length >= 3) {
      result =
          "${number.substring(number.length - 3, number.length)}${getResultWithDot(result)}";
      number = number.substring(0, number.length - 3);
    }
    if (number.isNotEmpty) {
      result = "$number${getResultWithDot(result)}";
    }
    result = "$result${arr.getOrNull(1)?.let(
          call: (value) => ",$value",
        ) ?? ""}";
    return result;
  }
}
