import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_skeleton/constants/theme/my_colors.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';

class MyTheme {
  /// The theme data for the app in light mode.
  static final ThemeData lightThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: MyColors.lightColorScheme,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness:
            Brightness.dark, // For Android (dark == dark icons)
        statusBarBrightness: Brightness.light, // For iOS (light == dark icons)
      ),
    ),
    canvasColor: MyColors.lightBackground,
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: MyMeasurements.textPadding * 2,
        vertical: MyMeasurements.textPadding,
      ),
      hintStyle: const TextStyle(
        color: MyColors.lightHint,
      ),
      errorStyle: const TextStyle(
        color: MyColors.lightError,
      ),
      filled: true,
      fillColor: MyColors.lightTextField,
      enabledBorder: border,
      focusedBorder: border,
      errorBorder: border,
      focusedErrorBorder: border,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: MyColors.onLightPrimary,
        backgroundColor: MyColors.lightPrimary,
        disabledBackgroundColor: MyColors.lightDisabled,
        disabledForegroundColor: MyColors.onLightDisabled,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MyMeasurements.borderRadius),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      space: MyMeasurements.dividerSpace,
      thickness: MyMeasurements.dividerThickness,
      color: MyColors.lightDivider,
    ),
  );

  /// The theme data for the app in dark mode.
  static final ThemeData darkThemeData = ThemeData(
    useMaterial3: true,
    colorScheme: MyColors.darkColorScheme,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness:
            Brightness.light, // For Android (light == light icons)
        statusBarBrightness: Brightness.dark, // For iOS (dark == light icons)
      ),
    ),
    canvasColor: MyColors.darkBackground,
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: MyMeasurements.textPadding * 2,
        vertical: MyMeasurements.textPadding,
      ),
      hintStyle: const TextStyle(
        color: MyColors.darkHint,
      ),
      errorStyle: const TextStyle(
        color: MyColors.darkError,
      ),
      filled: true,
      fillColor: MyColors.darkTextField,
      enabledBorder: border,
      focusedBorder: border,
      errorBorder: border,
      focusedErrorBorder: border,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: MyColors.onDarkPrimary,
        backgroundColor: MyColors.darkPrimary,
        disabledBackgroundColor: MyColors.darkDisabled,
        disabledForegroundColor: MyColors.onDarkDisabled,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MyMeasurements.borderRadius),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      space: MyMeasurements.dividerSpace,
      thickness: MyMeasurements.dividerThickness,
      color: MyColors.darkDivider,
    ),
  );

  /// The border for the text fields.
  static final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(MyMeasurements.borderRadius),
    gapPadding: MyMeasurements.textPadding,
  );

  /// The text theme for the app.
  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.poppins().copyWith(
      fontSize: MyMeasurements.defaultFontSizeDisplayLarge,
      height: MyMeasurements.defaultHeightDisplayLarge,
    ),
    displayMedium: GoogleFonts.poppins().copyWith(
      fontSize: MyMeasurements.defaultFontSizeDisplayMedium,
      height: MyMeasurements.defaultHeightDisplayMedium,
    ),
    displaySmall: GoogleFonts.poppins().copyWith(
      fontSize: MyMeasurements.defaultFontSizeDisplaySmall,
      height: MyMeasurements.defaultHeightDisplaySmall,
    ),
    headlineLarge: GoogleFonts.poppins().copyWith(
      fontSize: MyMeasurements.defaultFontSizeHeadlineLarge,
      height: MyMeasurements.defaultHeightHeadlineLarge,
    ),
    headlineMedium: GoogleFonts.poppins().copyWith(
      fontSize: MyMeasurements.defaultFontSizeHeadlineMedium,
      height: MyMeasurements.defaultHeightHeadlineMedium,
    ),
    headlineSmall: GoogleFonts.poppins().copyWith(
      fontSize: MyMeasurements.defaultFontSizeHeadlineSmall,
      height: MyMeasurements.defaultHeightHeadlineSmall,
    ),
    titleLarge: GoogleFonts.poppins().copyWith(
      fontSize: MyMeasurements.defaultFontSizeTitleLarge,
      height: MyMeasurements.defaultHeightTitleLarge,
    ),
    titleMedium: GoogleFonts.poppins().copyWith(
      fontSize: MyMeasurements.defaultFontSizeTitleMedium,
      height: MyMeasurements.defaultHeightTitleMedium,
    ),
    titleSmall: GoogleFonts.poppins().copyWith(
      fontSize: MyMeasurements.defaultFontSizeTitleSmall,
      height: MyMeasurements.defaultHeightTitleSmall,
    ),
    bodyLarge: GoogleFonts.poppins().copyWith(
      fontSize: MyMeasurements.defaultFontSizeBodyLarge,
      height: MyMeasurements.defaultHeightBodyLarge,
    ),
    bodyMedium: GoogleFonts.openSans().copyWith(
      fontSize: MyMeasurements.defaultFontSizeBodyMedium,
      height: MyMeasurements.defaultHeightBodyMedium,
    ),
    bodySmall: GoogleFonts.openSans().copyWith(
      fontSize: MyMeasurements.defaultFontSizeBodySmall,
      height: MyMeasurements.defaultHeightBodySmall,
    ),
    labelLarge: GoogleFonts.openSans().copyWith(
      fontSize: MyMeasurements.defaultFontSizeLabelLarge,
      height: MyMeasurements.defaultHeightLabelLarge,
    ),
    labelMedium: GoogleFonts.openSans().copyWith(
      fontSize: MyMeasurements.defaultFontSizeLabelMedium,
      height: MyMeasurements.defaultHeightLabelMedium,
    ),
    labelSmall: GoogleFonts.openSans().copyWith(
      fontSize: MyMeasurements.defaultFontSizeLabelSmall,
      height: MyMeasurements.defaultHeightLabelSmall,
    ),
  );
}
