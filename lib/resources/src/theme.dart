import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teddex/resources/resources.dart';

abstract class AppTheme {
  static ThemeData get theme => ThemeData(
        primaryColor: AppColor.primary,
        primaryColorDark: AppColor.primaryDark,
        cardTheme: cardTheme,
        dividerTheme: dividerTheme,
        fontFamily: kFontFamily,
        colorScheme: const ColorScheme.light(
          brightness: Brightness.light,
          primary: AppColor.primary,
          background: AppColor.white,
          onPrimary: AppColor.white,
          onError: AppColor.red,
          secondary: AppColor.secondary,
          onSecondary: AppColor.white,
          error: AppColor.red,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColor.primary,
          selectionColor: AppColor.primary.withOpacity(0.3),
          selectionHandleColor: AppColor.primary,
        ),
        elevatedButtonTheme: elevatedButtonTheme,
        outlinedButtonTheme: outlinedButtonThemeData,
        scaffoldBackgroundColor: AppColor.scaffoldBackground,
        shadowColor: AppColor.shadowColor.withOpacity(0.5),
        dialogTheme: dialogTheme,
        bottomSheetTheme: bottomSheetTheme,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            color: AppColor.textPrimaryMedium,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            fontFamily: kFontFamily,
          ),
          errorStyle: const TextStyle(
            color: AppColor.red,
            fontWeight: FontWeight.w500,
            fontSize: 12,
            fontFamily: kFontFamily,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColor.textPrimaryLight),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColor.textPrimaryLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColor.textPrimaryLight),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColor.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColor.primary),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColor.red),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          fillColor: AppColor.transparent,
          filled: true,
        ),
        radioTheme: radioTheme,
        checkboxTheme: checkBoxTheme,
        bottomAppBarTheme: const BottomAppBarTheme(elevation: 4, color: AppColor.white),
        popupMenuTheme: PopupMenuThemeData(
          color: AppColor.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          textStyle: const TextStyle(
            color: AppColor.textPrimary,
            fontSize: 14,
            fontFamily: kFontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColor.primary,
          foregroundColor: AppColor.white,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColor.white,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          actionTextColor: AppColor.primary,
          elevation: 4,
          contentTextStyle: const TextStyle(
            color: AppColor.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: kFontFamily,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.transparent,
          elevation: 0,
          titleSpacing: 8,
          centerTitle: true,
          shadowColor: AppColor.greyLight,
          foregroundColor: AppColor.primaryDark,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          ),
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: AppColor.textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: kFontFamily,
          ),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: AppColor.primary,
          unselectedLabelColor: AppColor.textPrimaryLight,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: kFontFamily),
          unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: kFontFamily),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColor.greyLight,
          disabledColor: AppColor.grey.withAlpha(150),
          selectedColor: AppColor.primary,
          secondarySelectedColor: AppColor.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: const TextStyle(
            fontFamily: kFontFamily,
            fontSize: 12,
            color: AppColor.textPrimaryLight,
            fontWeight: FontWeight.w500,
          ),
          secondaryLabelStyle: const TextStyle(
            fontFamily: kFontFamily,
            fontSize: 12,
            color: AppColor.white,
            fontWeight: FontWeight.w500,
          ),
          brightness: Brightness.light,
        ),
        bottomNavigationBarTheme: bottomNavigationBarTheme,
      );

  static const BottomNavigationBarThemeData bottomNavigationBarTheme = BottomNavigationBarThemeData(
    backgroundColor: AppColor.white,
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(fontSize: 12),
    elevation: 8,
    selectedItemColor: AppColor.primary,
    unselectedItemColor: AppColor.grey,
    landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
  );

  static const BottomSheetThemeData bottomSheetTheme = BottomSheetThemeData(
    backgroundColor: AppColor.white,
    clipBehavior: Clip.hardEdge,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
    modalElevation: 8,
    modalBackgroundColor: AppColor.white,
  );

  static RadioThemeData radioTheme = RadioThemeData(
    fillColor: MaterialStateProperty.all(AppColor.primary),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );

  static CheckboxThemeData checkBoxTheme = CheckboxThemeData(
    fillColor: MaterialStateProperty.all(AppColor.primary),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );

  static CardTheme cardTheme = CardTheme(
    elevation: 8,
    shadowColor: AppColor.greyLight.withOpacity(0.5),
    clipBehavior: Clip.hardEdge,
    color: AppColor.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    margin: EdgeInsets.zero,
  );

  static DialogTheme dialogTheme = DialogTheme(
    elevation: 16,
    backgroundColor: AppColor.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    titleTextStyle: const TextStyle(fontSize: 16, color: AppColor.textPrimary, fontWeight: FontWeight.w600),
    contentTextStyle: const TextStyle(fontSize: 14, color: AppColor.textPrimaryLight, fontWeight: FontWeight.w500),
  );

  static DividerThemeData dividerTheme = const DividerThemeData(color: AppColor.greyLight, space: 1, thickness: 1);

  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) return 4;
        return 0;
      }),

      padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColor.primary.withAlpha(150);
        }
        return AppColor.primary;
      }),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColor.white.withOpacity(0.2);
        } else if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
          return AppColor.white.withOpacity(0.1);
        } else {
          return AppColor.transparent;
        }
      }),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      )),
    ),
  );

  static OutlinedButtonThemeData outlinedButtonThemeData = OutlinedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return AppColor.primary.withOpacity(0.2);
        } else if (states.contains(MaterialState.hovered) || states.contains(MaterialState.focused)) {
          return AppColor.primary.withOpacity(0.1);
        } else {
          return AppColor.transparent;
        }
      }),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColor.primary, width: 2),
      )),
      side: MaterialStateProperty.all(const BorderSide(color: AppColor.primary, width: 2)),
    ),
  );
}
