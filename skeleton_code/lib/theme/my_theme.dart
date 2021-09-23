import 'package:flutter/material.dart';
import 'package:skeleton_code/theme/my_colors.dart';
import 'package:skeleton_code/theme/my_spacing.dart';
import 'package:skeleton_code/theme/my_text_theme.dart';

/// The stylization of the app.
class MyTheme {
  /// This is the theme for the app.
  static final ThemeData myTheme = ThemeData(
    primaryColor: MyColors.Primary,
    accentColor: MyColors.Secondary,
    hintColor: MyColors.Tertiary,
    appBarTheme: AppBarTheme(
        color: MyColors.Primary,
        textTheme: TextTheme(headline6: MyTextTheme.AppBar),
        iconTheme: IconThemeData(color: Colors.white),
        brightness: Brightness.dark),
    textTheme: TextTheme(
      headline6: MyTextTheme.Title,
      subtitle2: MyTextTheme.SubTitle,
      caption: MyTextTheme.Caption,
      bodyText2: MyTextTheme.Body,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          backgroundColor: MyColors.Secondary, primary: Colors.white),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return MyColors.Secondary; // the color when checkbox is selected
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
                .Secondary; // the color when radio button is selected
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
                  icon: Icon(
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
      errorStyle: Theme.of(context)
          .textTheme
          .subtitle2!
          .copyWith(color: MyColors.Failure, fontSize: MyTextSize.Small),
      fillColor: MyColors.Secondary,
      contentPadding: EdgeInsets.symmetric(
        horizontal: MySpacing.TextPadding * 2,
        vertical: MySpacing.TextPadding,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySpacing.BorderRadius),
        borderSide: BorderSide(color: MyColors.Primary),
        gapPadding: MySpacing.TextPadding,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySpacing.BorderRadius),
        borderSide: BorderSide(color: MyColors.Primary),
        gapPadding: MySpacing.TextPadding,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySpacing.BorderRadius),
        borderSide: BorderSide(color: MyColors.Failure),
        gapPadding: MySpacing.TextPadding,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySpacing.BorderRadius),
        borderSide: BorderSide(color: MyColors.Failure),
        gapPadding: MySpacing.TextPadding,
      ),
    );
  }

  /// This is the stye for all of the clickable buttons in the app.
  static ButtonStyle myButtonStyle() {
    return _myButtonStyle().copyWith(
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.pressed)
            ? MyColors.Secondary
            : MyColors.Primary,
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
          borderRadius: BorderRadius.circular(MySpacing.BorderRadius),
        ),
      ),
      padding: MaterialStateProperty.all(
        EdgeInsets.symmetric(
          horizontal: MySpacing.TextPadding * 2,
          vertical: MySpacing.TextPadding,
        ),
      ),
      elevation: MaterialStateProperty.all(MySpacing.ElementElevation),
    );
  }
}
