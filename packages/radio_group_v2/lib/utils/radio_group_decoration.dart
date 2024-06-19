import 'package:flutter/material.dart';

/// This class is applied to a [RadioGroup] to define the style and design of
/// it.
///
/// {@tool snippet}
///
/// This sample shows the creation of a radio group with some additional spacing
/// and amber colored buttons and blue text labels.
///
/// ```dart
/// RadioGroupController myController = RadioGroupController();
///
/// RadioGroup(
///   controller: myController,
///   values: ["Choice1", "Choice2", "Choice3"],
///   decoration: RadioGroupDecoration(
///     spacing: 10.0,
///     labelStyle: TextStyle(
///       color: Colors.blue,
///     ),
///     activeColor: Colors.amber,
///   ),
/// )
/// ```
/// {@end-tool}
class RadioGroupDecoration {
  /// Creates a decoration object that can be applied to a [RadioGroup] to
  /// define that radio group's style and design.
  const RadioGroupDecoration({
    this.spacing = 0.0,
    this.runSpacing = 0.0,
    this.verticalAlignment = MainAxisAlignment.start,
    this.horizontalAlignment = WrapAlignment.center,
    this.labelStyle,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
  })  : assert(spacing >= 0.0, "ERROR: `spacing` cannot be less than 0.0!"),
        assert(
            runSpacing >= 0.0, "ERROR: `runSpacing` cannot be less than 0.0!");

  /// The amount of space between each button.
  final double spacing;

  /// The amount of space between each row if the radio group is horizontal and
  /// needs to wrap to multiple rows.
  ///
  /// **Note:** This only applies to horizontal radio group elements.
  final double runSpacing;

  /// How the radio buttons should be aligned horizontally in a vertical list.
  ///
  /// **Note:** This only applies to vertical radio group elements.
  final MainAxisAlignment verticalAlignment;

  /// Where the radio buttons should be aligned in the horizontal direction.
  ///
  /// **Note:** This only applies to horizontal radio group elements.
  final WrapAlignment horizontalAlignment;

  /// The text style for the radio buttons labels.
  ///
  /// **Note:** This will only be applied to values in the radio group's
  /// `values` list that are not widgets.
  final TextStyle? labelStyle;

  /// If `true` the selected radio button may be pressed again resulting in it
  /// deselecting and no buttons in the group being selected.
  final bool toggleable;

  /// The color to use when this radio button is selected.
  ///
  /// Defaults to `ThemeData.toggleableActiveColor`.
  ///
  /// If `fillColor` returns a non-null color in the `MaterialState.selected`
  /// state, it will be used instead of this color.
  ///
  /// Comment info copied from:
  /// https://api.flutter.dev/flutter/material/Radio/activeColor.html
  final Color? activeColor;

  /// The color that fills the radio button, in all `MaterialStates`.
  ///
  /// Resolves in the following states:
  /// * `MaterialState.selected`
  /// * `MaterialState.hovered`
  /// * `MaterialState.focused`
  /// * `MaterialState.disabled`
  ///
  /// If `null`, then the value of `activeColor` is used in the selected state.
  /// If that is also `null`, then the value of `RadioThemeData.fillColor` is
  /// used. If that is also `null`, then `ThemeData.disabledColor` is used in
  /// the disabled state, `ThemeData.toggleableActiveColor` is used in the
  /// selected state, and `ThemeData.unselectedWidgetColor` is used in the
  /// default state.
  ///
  /// Comment info copied from:
  /// https://api.flutter.dev/flutter/material/Radio/fillColor.html
  final WidgetStateProperty<Color?>? fillColor;

  /// The color for the radio's `Material` when it has the input focus.
  ///
  /// If `overlayColor` returns a non-null color in the `MaterialState.focused`
  /// state, it will be used instead.
  ///
  /// If `null`, then the value of `RadioThemeData.overlayColor` is used in the
  /// focused state. If that is also `null`, then the value of
  /// `ThemeData.focusColor` is used.
  ///
  /// Comment info copied from:
  /// https://api.flutter.dev/flutter/material/Radio/focusColor.html
  final Color? focusColor;

  /// The color for the radio's `Material` when a pointer is hovering over it.
  ///
  /// If `overlayColor` returns a non-null color in the `MaterialState.hovered`
  /// state, it will be used instead.
  ///
  /// If `null`, then the value of `RadioThemeData.overlayColor` is used in the
  /// hovered state. If that is also `null`, then the value of
  /// `ThemeData.hoverColor` is used.
  ///
  /// Comment info copied from:
  /// https://api.flutter.dev/flutter/material/Radio/hoverColor.html
  final Color? hoverColor;

  /// The color for the checkbox's `Material`.
  ///
  /// Resolves in the following states:
  /// * `MaterialState.pressed`
  /// * `MaterialState.selected`
  /// * `MaterialState.hovered`
  /// * `MaterialState.focused`
  ///
  /// If `null`, then the value of `activeColor` with alpha
  /// `kRadialReactionAlpha`, `focusColor` and `hoverColor` is used in the
  /// pressed, focused and hovered state. If that is also `null`, the value of
  /// `RadioThemeData.overlayColor` is used. If that is also `null`, then the
  /// value of `ThemeData.toggleableActiveColor` with alpha
  /// `kRadialReactionAlpha`, `ThemeData.focusColor` and `ThemeData.hoverColor`
  /// is used in the pressed, focused and hovered state.
  ///
  /// Comment info copied from:
  /// https://api.flutter.dev/flutter/material/Radio/overlayColor.html
  final WidgetStateProperty<Color?>? overlayColor;

  /// The splash radius of the circular `Material` ink response.
  ///
  /// If `null`, then the value of `RadioThemeData.splashRadius` is used. If
  /// that is also `null`, then `kRadialReactionRadius` is used.
  ///
  /// Comment info copied from:
  /// https://api.flutter.dev/flutter/material/Radio/splashRadius.html
  final double? splashRadius;
}
