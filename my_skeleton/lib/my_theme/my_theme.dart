import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_skeleton/my_theme/my_colors.dart';
import 'package:my_skeleton/my_theme/my_spacing.dart';
import 'package:my_skeleton/my_theme/my_text_theme.dart';

/// The stylization of the app.
class MyTheme {
  /// This is the theme for the app.
  static final ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: MyColors.background,
    primaryColor: MyColors.primary,
    hintColor: MyColors.secondary,
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: MyColors.background,
        statusBarIconBrightness: Brightness.light, // For Android (light icons)
        statusBarBrightness: Brightness.dark, // For iOS (light icons)
      ),
      color: MyColors.primary,
      toolbarTextStyle: MyTextTheme.appBar.copyWith(
        color: MyColors.background,
      ),
      iconTheme: const IconThemeData(
        color: MyColors.background,
      ),
    ),
    textTheme: TextTheme(
      headline6: MyTextTheme.title.copyWith(
        color: MyColors.primary,
      ),
      subtitle2: MyTextTheme.subTitle.copyWith(
        color: MyColors.secondary,
      ),
      caption: MyTextTheme.caption.copyWith(
        color: MyColors.primary,
      ),
      bodyText2: MyTextTheme.body.copyWith(
        color: MyColors.primary,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: MyColors.secondary,
        primary: MyColors.primary,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return MyColors.secondary; // the color when checkbox is selected
          }
          return Colors.grey; //the color when checkbox is unselected
        },
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return MyColors
                .secondary; // the color when radio button is selected
          }
          return Colors.grey; //the color when radio button is unselected
        },
      ),
    ),
  );

  /// This is the stylization for all of the [TextField] input areas in the app.
  static InputDecoration myInputDecoration(
    BuildContext context,
    TextEditingController controller, {
    String? label,
    String? hint,
    Icon? prefixIcon,
    String? errorText,
    bool hasClearAllBtn = false,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: Theme.of(context).textTheme.bodyText2,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      prefixIcon: prefixIcon,
      suffixIcon: hasClearAllBtn
          ? (controller.text.isEmpty
              ? Container(width: 0)
              : IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    controller.clear();
                  },
                ))
          : null,
      hintText: hint,
      hintStyle: Theme.of(context).textTheme.subtitle2,
      errorText: errorText,
      errorStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
            color: MyColors.failure,
            fontSize: MyTextSize.small,
          ),
      fillColor: MyColors.secondary,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: MySpacing.textPadding * 2,
        vertical: MySpacing.textPadding,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySpacing.borderRadius),
        borderSide: const BorderSide(color: MyColors.primary),
        gapPadding: MySpacing.textPadding,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySpacing.borderRadius),
        borderSide: const BorderSide(color: MyColors.primary),
        gapPadding: MySpacing.textPadding,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySpacing.borderRadius),
        borderSide: const BorderSide(color: MyColors.failure),
        gapPadding: MySpacing.textPadding,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySpacing.borderRadius),
        borderSide: const BorderSide(color: MyColors.failure),
        gapPadding: MySpacing.textPadding,
      ),
    );
  }

  /// This is the stye for all of the clickable buttons in the app.
  static ButtonStyle myButtonStyle() {
    return _myButtonStyle().copyWith(
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.pressed)
            ? MyColors.secondary
            : MyColors.primary,
      ),
    );
  }

  /// This is the style for all of the disabled buttons in the app.
  static ButtonStyle myDisabledButtonStyle() {
    return _myButtonStyle().copyWith(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
    );
  }

  /// This is the base style for all of the buttons in the app.
  ///
  /// Other button types/states will use this to lay their foundation and then
  /// add other details related to their type/state.
  static ButtonStyle _myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MySpacing.borderRadius),
        ),
      ),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: MySpacing.textPadding * 2,
          vertical: MySpacing.textPadding,
        ),
      ),
      elevation: MaterialStateProperty.all(MySpacing.elementElevation),
    );
  }
}
