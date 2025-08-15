import 'dart:convert';

import 'package:flutter/material.dart';

class Log {
  static const ansiEsc = '\x1B[';
  static const ansiDefault = '${ansiEsc}0m';
  static const _encoder = JsonEncoder.withIndent("  ");

  static void debug(Object? info) => _print(info, 208);

  static void error(Object? error) => _print(error, 196);

  static void success(Object? info) => _print(info, 77);

  static void _print(Object? object, int foregroundColor) {
    if (object is Map || object is List) {
      _encoder.convert(object).split("\n").forEach((element) {
        debugPrint("${ansiEsc}38;5;${foregroundColor}m$element$ansiDefault");
      });
    } else {
      debugPrint("${ansiEsc}38;5;${foregroundColor}m$object$ansiDefault");
    }
  }
}

extension $ObjectExtension on Object? {
  void debug() => Log.debug(this);

  void error() => Log.error(this);

  void success() => Log.success(this);
}
