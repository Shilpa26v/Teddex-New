library country_picker;

import 'package:country_picker/src/country_model.dart';
import 'package:flutter/material.dart';

import 'src/widgets/widgets.dart';

export 'src/country_list.dart';
export 'src/country_model.dart';
export 'src/utils.dart';
export 'src/widgets/widgets.dart';

Future<Country?> showCountryPickerSheet(BuildContext context) {
  final mediaQuery = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
  return showModalBottomSheet<Country>(
    context: context,
    builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      return Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              width: 64,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colorScheme.onSurface.withAlpha(120),
              ),
            ),
          ),
          const Expanded(
            child: CountryPickerView(),
          ),
        ],
      );
    },
    constraints: BoxConstraints(
      maxHeight: mediaQuery.size.height - mediaQuery.padding.top - 8,
    ),
    routeSettings: const RouteSettings(name: "/country_picker"),
    isScrollControlled: true,
  );
}

showCountryPickerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const Dialog(
        insetPadding: EdgeInsets.all(16),
        child: CountryPickerView(),
      );
    },
    routeSettings: const RouteSettings(name: "/country_picker"),
  );
}
