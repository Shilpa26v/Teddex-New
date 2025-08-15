library helpers;

export 'src/after_layout_mixin.dart';
export 'src/connectivity_helper.dart';
export 'src/event_bus.dart';
export 'src/extensions.dart';
export 'src/input_formatters.dart';
export 'src/logger.dart';
export 'src/storage_helper.dart';
export 'src/url_helper.dart';
export 'src/url_helper.dart';

const serverDateTimeFormat = "yyyy-MM-dd HH:mm:ss";
const serverDateFormat = "yyyy-MM-dd";
const serverTimeFormat = "HH:mm:ss";
const localDateFormat = "MM/dd/yyyy";
const localTimeFormat = "hh:mm a";

enum Gender { male, female }

extension $GenderExt on Gender {
  int get value {
    switch (this) {
      case Gender.male:
        return 1;
      case Gender.female:
        return 0;
    }
  }
}
