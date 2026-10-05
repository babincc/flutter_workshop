import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_skeleton/constants/theme/my_colors_one_theme.dart';
import 'package:my_skeleton/constants/theme/my_measurements.dart';

class MyTheme {
  /// The theme data for the app.
  static final ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: MyColors.colorScheme,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle(
        // CURRENTLY SET FOR DARK MODE
        statusBarIconBrightness:
            Brightness.light, // For Android (light == light icons)
        statusBarBrightness: Brightness.dark, // For iOS (dark == light icons)
      ),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0.0,
    ),
    canvasColor: MyColors.background,
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: MyMeasurements.textPadding * 2,
        vertical: MyMeasurements.textPadding,
      ),
      hintStyle: const TextStyle(color: MyColors.hint),
      errorStyle: const TextStyle(color: MyColors.error),
      filled: true,
      fillColor: MyColors.textField,
      enabledBorder: border,
      focusedBorder: focusBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusBorder,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: MyColors.onPrimary,
        backgroundColor: MyColors.primary,
        disabledBackgroundColor: MyColors.disabled,
        disabledForegroundColor: MyColors.onDisabled,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    dividerTheme: const DividerThemeData(
      space: MyMeasurements.dividerSpace,
      thickness: MyMeasurements.dividerThickness,
      color: MyColors.divider,
    ),
  );

  /// The border for the text fields.
  static OutlineInputBorder get border => _border(MyColors.border);

  /// The focus border for the text fields.
  static OutlineInputBorder get focusBorder => _border(MyColors.borderFocused);

  /// The error border for the text fields.
  static OutlineInputBorder get errorBorder => _border(MyColors.error);

  /// The border for the text fields.
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: MyMeasurements.borderWidth),
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
    bodyMedium: GoogleFonts.inter().copyWith(
      fontSize: MyMeasurements.defaultFontSizeBodyMedium,
      height: MyMeasurements.defaultHeightBodyMedium,
    ),
    bodySmall: GoogleFonts.inter().copyWith(
      fontSize: MyMeasurements.defaultFontSizeBodySmall,
      height: MyMeasurements.defaultHeightBodySmall,
    ),
    labelLarge: GoogleFonts.inter().copyWith(
      fontSize: MyMeasurements.defaultFontSizeLabelLarge,
      height: MyMeasurements.defaultHeightLabelLarge,
    ),
    labelMedium: GoogleFonts.inter().copyWith(
      fontSize: MyMeasurements.defaultFontSizeLabelMedium,
      height: MyMeasurements.defaultHeightLabelMedium,
    ),
    labelSmall: GoogleFonts.inter().copyWith(
      fontSize: MyMeasurements.defaultFontSizeLabelSmall,
      height: MyMeasurements.defaultHeightLabelSmall,
    ),
  );
}
