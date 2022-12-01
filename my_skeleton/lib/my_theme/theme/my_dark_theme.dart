import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_skeleton/my_theme/colors/my_dark_theme_colors.dart';
import 'package:my_skeleton/my_theme/my_spacing.dart';
import 'package:my_skeleton/my_theme/my_text_theme.dart';
import 'package:my_skeleton/my_theme/theme/my_theme_interface.dart';

/// The stylization of the app.
class MyDarkTheme implements MyThemeInterface {
  /// This is the theme for the app.
  @override
  ThemeData get themeData => ThemeData(
        scaffoldBackgroundColor: MyDarkThemeColors().background,
        primaryColor: MyDarkThemeColors().foreground,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: MyDarkThemeColors().secondary),
        hintColor: MyDarkThemeColors().secondary,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: MyDarkThemeColors().background,
            statusBarIconBrightness:
                Brightness.light, // For Android (light icons)
            statusBarBrightness: Brightness.dark, // For iOS (light icons)
          ),
          color: MyDarkThemeColors().background,
          toolbarTextStyle: MyTextTheme.appBar.copyWith(
            color: MyDarkThemeColors().foreground,
          ),
          iconTheme: IconThemeData(
            color: MyDarkThemeColors().foreground,
          ),
        ),
        textTheme: TextTheme(
          headline6: MyTextTheme.title.copyWith(
            color: MyDarkThemeColors().foreground,
          ),
          subtitle2: MyTextTheme.subTitle.copyWith(
            color: MyDarkThemeColors().secondary,
          ),
          caption: MyTextTheme.caption.copyWith(
            color: MyDarkThemeColors().foreground,
          ),
          bodyText2: MyTextTheme.body.copyWith(
            color: MyDarkThemeColors().foreground,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: MyDarkThemeColors().foreground,
            backgroundColor: MyDarkThemeColors().secondary,
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateColor.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return MyDarkThemeColors()
                    .secondary; // the color when checkbox is selected
              }
              return Colors.grey; //the color when checkbox is unselected
            },
          ),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateColor.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return MyDarkThemeColors()
                    .secondary; // the color when radio button is selected
              }
              return Colors.grey; //the color when radio button is unselected
            },
          ),
        ),
      );

  /// This is the stylization for all of the [TextField] input areas in the app.
  @override
  InputDecoration myInputDecoration(
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
            color: MyDarkThemeColors().failure,
            fontSize: MyTextSize.small,
          ),
      fillColor: MyDarkThemeColors().secondary,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: MySpacing.textPadding * 2,
        vertical: MySpacing.textPadding,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySpacing.borderRadius),
        borderSide: BorderSide(color: MyDarkThemeColors().foreground),
        gapPadding: MySpacing.textPadding,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySpacing.borderRadius),
        borderSide: BorderSide(color: MyDarkThemeColors().foreground),
        gapPadding: MySpacing.textPadding,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySpacing.borderRadius),
        borderSide: BorderSide(color: MyDarkThemeColors().failure),
        gapPadding: MySpacing.textPadding,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySpacing.borderRadius),
        borderSide: BorderSide(color: MyDarkThemeColors().failure),
        gapPadding: MySpacing.textPadding,
      ),
    );
  }

  /// This is the stye for all of the clickable buttons in the app.
  @override
  ButtonStyle get myButtonStyle {
    return _myButtonStyle().copyWith(
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.pressed)
            ? MyDarkThemeColors().secondary
            : MyDarkThemeColors().foreground,
      ),
    );
  }

  /// This is the style for all of the disabled buttons in the app.
  @override
  ButtonStyle get myDisabledButtonStyle {
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
