import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:teddex/helpers/helpers.dart';

extension $KotlinStyleExtension<T> on T {
  @pragma("vm:prefer-inline")
  T let(void Function(T it) func) {
    func(this);
    return this;
  }

  @pragma("vm:prefer-inline")
  T apply(void Function() func) {
    func();
    return this;
  }

  @pragma("vm:prefer-inline")
  R also<R>(R Function(T it) func) {
    return func(this);
  }

  @pragma("vm:prefer-inline")
  R run<R>(R Function() func) {
    return func();
  }
}

extension $ListExtension<T> on List<T> {
  T? get firstOrNull {
    return isEmpty ? null : first;
  }
}

extension $NullableListExtension<T> on List<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNullOrNotEmpty => this != null && this!.isNotEmpty;
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E element, int index) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void Function(E element, int index) f) {
    var i = 0;
    forEach((e) => f(e, i++));
  }
}

extension $BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  EdgeInsets get mediaQueryPadding => MediaQuery.of(this).padding;

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;

  double get topPadding => mediaQuery.padding.top;

  double get bottomPadding => mediaQuery.padding.bottom;

  double get topInset => mediaQuery.viewInsets.top;

  double get bottomInset => mediaQuery.viewInsets.bottom;

  Object? get args => ModalRoute.of(this)?.settings.arguments;

  TextDirection get textDirection => Directionality.of(this);

  hideKeyboard() {
    final currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}

extension $StringExtension on String {
  DateTime parseUtcDateTime([String format = serverDateTimeFormat]) {
    var time = DateFormat(format).parseUTC(replaceAll("T", " ").replaceAll("Z", " "));
    return time;
  }

  DateTime parseLocalDateTime([String format = serverDateTimeFormat]) {
    var time = DateFormat(format).parse(replaceAll("T", " ").replaceAll("Z", " "));
    return time;
  }

  String toFormattedPrice() {
    int number = double.parse(this).toInt();
    if (number > -1000 && number < 1000) return number.toStringAsFixed(2);
    final String digits = number.abs().toString();
    final StringBuffer result = StringBuffer(number < 0 ? '-' : '');
    final int maxDigitIndex = digits.length - 1;
    for (int i = 0; i <= maxDigitIndex; i += 1) {
      result.write(digits[i]);
      if (i < maxDigitIndex && (maxDigitIndex - i) % 3 == 0) result.write(',');
    }
    return result.toString() + "." + (double.parse(this) - number).toStringAsFixed(2).substring(2);
  }
}

extension $NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  int toInt() {
    return this == null ? 0 : int.tryParse(this!) ?? 0;
  }

  double toDouble() {
    return this == null ? 0 : double.tryParse(this!) ?? 0.0;
  }
}

extension $DateTimeExtension on DateTime {
  String toLocalString([String format = "yyyy-MM-dd HH:mm:ss"]) {
    var strDate = DateFormat(format).format(toLocal());
    return strDate;
  }

  String toUtcString([String format = "yyyy-MM-dd HH:mm:ss"]) {
    var strDate = DateFormat(format).format(toUtc());
    return strDate;
  }

  bool get isToday {
    var now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  bool isSameDay(DateTime dateTime) {
    return day == dateTime.day && month == dateTime.month && year == dateTime.year;
  }
}
