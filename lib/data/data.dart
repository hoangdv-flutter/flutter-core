import 'package:flutter/material.dart';
import 'package:flutter_core/core.dart';

part 'equatable.dart';
part 'language.dart';

abstract class Equatable {
  List<dynamic> get properties;

  @override
  bool operator ==(Object other) {
    if (other is Equatable) {
      for (var i = 0; i < properties.length; i++) {
        if (properties[i] != other.properties[i]) {
          return false;
        }
      }
      return true;
    }
    return false;
  }
}
