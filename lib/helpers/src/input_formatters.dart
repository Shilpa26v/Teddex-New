import 'package:flutter/services.dart';

class NumberInputFormatter extends TextInputFormatter {
  final int length;
  final bool allowFloating;

  NumberInputFormatter({this.length = 255, this.allowFloating = false});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > length) return oldValue;
    if (newValue.text.length > oldValue.text.length) {
      if (allowFloating) {
        return double.tryParse(newValue.text) != null ? newValue : oldValue;
      } else {
        return int.tryParse(newValue.text) != null ? newValue : oldValue;
      }
    } else {
      return newValue;
    }
  }
}
