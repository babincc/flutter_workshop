// @author Christian Babin
// @version 1.0.0
// https://github.com/babincc/flutter_workshop/blob/master/plugins/radio_group/lib/radio_group.dart

import 'package:flutter/material.dart';

/// Describes how the radio button list will be layed out on the screen.
enum RadioGroupOrientation {
  /// When this is set as the orientation, the buttons will be layed out on top
  /// of each other in a single stack.
  Vertical,

  /// When this is set as the orientation, the buttons will be layed out side by
  /// side and wrap around to the next line when they reach the edge of the
  /// screen.
  Horizontal,
}

/// A widget that creates a set of radio buttons in a single, interconnected
/// group.
///
/// ### Individual Radio Button
///
/// Each radio button is a [Radio] widget housed inside of a [Row] along with a
/// either the value itself if it is a widget or a [Text] widget with the value
/// as a string as a label for the user to know what the button is representing.
///
/// One of these is created for every value that comes into this builder.
///
/// ### Vertical Layout
///
/// When the [RadioGroupOrientation.Vertical] orientation is selected, this
/// returns a [Column] which contains the [ListTile] widgets described above in
/// the "Individual Radio Button" section.
///
/// {@tool snippet}
///
/// This sample shows the creation of a radio group that is aligned vertically.
///
/// ```dart
/// RadioGroupController myController = RadioGroupController();
///
/// RadioGroup(
///   controller: myController,
///   values: ["Choice1", "Choice2", "Choice3"],
/// )
/// ```
/// {@end-tool}
///
/// ### Horizontal Layout
///
/// When the [RadioGroupOrientation.Horizontal] orientation is selected, this
/// returns a [Wrap] which contains the [ListTile] widgets described above in
/// the "Individual Radio Button" section.
///
/// {@tool snippet}
///
/// This sample shows the creation of a radio group that is aligned
/// horizontally. It also has a real time updating method sent into it which
/// will be called every time the buttons switch.
///
/// ```dart
/// RadioGroupController myController = RadioGroupController();
///
/// RadioGroup(
///   controller: myController,
///   values: ["Choice1", "Choice2", "Choice3"],
///   onChanged: (value) {
///     liveChangeHere();
///   },
///   orientation: RadioListOrientation.Horizontal,
/// )
/// ```
/// {@end-tool}
///
/// ### Retrieving Selected Value
///
/// {@tool snippet}
///
/// This sample shows what to do if you want to see which choice is selected
/// from the two examples above.
///
/// ```dart
/// print("The chosen value is: ${myController.value.toString()}");
/// ```
/// {@end-tool}
///
/// See also:
///
/// * [RadioGroupController] which is used to know which button in the group is
///   selected as well as programmatically select a button.
class RadioGroup extends StatefulWidget {
  /// Creates a widget which contains [Radio] buttons that a user can click to
  /// make selections within the app.
  ///
  /// **Note:** Any value in `values` that is not a [Widget] will be displayed
  /// as a string in a [Text] widget as the label.
  RadioGroup({
    Key? key,
    this.controller,
    required this.values,
    this.onChanged,
    this.indexOfDefault = -1,
    this.orientation = RadioGroupOrientation.Vertical,
    this.decoration,
  })  : assert(
            indexOfDefault < values.length,
            "ERROR: \`indexOfDefault\` is out of bounds for the range of " +
                "\`values\`!"),
        _controller = controller ?? RadioGroupController(),
        super(key: key);

  /// This allows for setting and getting the value of `this` radio group.
  final RadioGroupController? controller;

  /// This allows for setting and getting the value of `this` radio group.
  ///
  /// Note: This is the one that is to be used throughout the code. [controller]
  /// only exists to give programmers a more comfortable coding experience when
  /// using this library as a plug-in.
  final RadioGroupController _controller;

  /// The labels for each of the buttons (in order of how they will be
  /// displayed).
  final List<Object> values;

  /// A function that is called whenever the user clicks a different radio
  /// button than the on that is currently selected.
  ///
  /// `value` is the value that was just selected to trigger this function.
  final void Function(Object value)? onChanged;

  /// The index in the [values] list of the radio button which will start out
  /// selected.
  final int indexOfDefault;

  /// The style and design of the radio group.
  final RadioGroupDecoration? decoration;

  /// How the radio button list will be layed out on the screen.
  final RadioGroupOrientation orientation;

  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  /// The value of the selected element in the radio group.
  Object? _value;

  set value(Object? value) => setState(() => _value = value);

  /// Called when the app creates a radio group. This needs to be called
  /// specifically to set default values in the [RadioGroupController] for this
  /// radio group.
  @override
  void initState() {
    super.initState();

    // Let the controller know who its radio group is.
    widget._controller._myRadioGroup = this;

    // Set default starting value.
    if (widget.indexOfDefault < 0) {
      value = null;
    } else {
      value = widget.values[widget.indexOfDefault];
    }
  }

  /// Build the radio group and send it back to the calling method.
  @override
  Widget build(BuildContext context) {
    // If the orientation of the radio button list is vertical, do this.
    if (widget.orientation == RadioGroupOrientation.Vertical) {
      return Column(
        children: [
          for (Object currValue in widget.values) _radioItemBuilder(currValue),
        ],
      );
    } else {
      // Otherwise, the orientation is horizontal; so, do this.
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: widget.decoration?.spacing ?? 0.0,
        children: [
          for (Object currValue in widget.values)
            IntrinsicWidth(
              child: _radioItemBuilder(currValue),
            ),
        ],
      );
    }
  }

  /// This method builds each radio item, which consists of the button and its
  /// label.
  Row _radioItemBuilder(Object value) {
    return Row(
      children: [
        _buttonBuilder(value),
        _labelBuilder(value),
      ],
    );
  }

  /// This method builds a button with a value that is passed to it. This is
  /// what allows the [RadioGroup] widget to be dynamically sized. It can hold
  /// as many or as few values as it needs.
  Radio _buttonBuilder(Object value) {
    return Radio(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: value,
      groupValue: _value,
      onChanged: (newValue) {
        setState(() {
          _value = newValue;

          if (widget.onChanged != null) {
            widget.onChanged!(newValue);
          }
        });
      },
      toggleable: widget.decoration?.toggleable ?? false,
      activeColor: widget.decoration?.activeColor,
      fillColor: widget.decoration?.fillColor,
      focusColor: widget.decoration?.focusColor,
      hoverColor: widget.decoration?.hoverColor,
      overlayColor: widget.decoration?.overlayColor,
      visualDensity: VisualDensity.compact,
      splashRadius: widget.decoration?.splashRadius,
    );
  }

  /// This method builds the label that is used beside the radio button to let
  /// the user know what the button is for.
  Flexible _labelBuilder(Object value) {
    Text? label;

    // If `value` is not a widget, turn it into a string to be shown as text.
    if (!(value is Widget)) {
      label = Text(
        value.toString(),
        softWrap: true,
        style: widget.decoration?.labelStyle,
      );
    }

    return Flexible(
      child: GestureDetector(
        onTap: () {
          if (_value == value) {
            if (widget.decoration != null) {
              if (widget.decoration!.toggleable) {
                // If `toggleable` is turned on and the same value is clicked,
                // deselect all buttons.
                this.value = null;

                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              }
            }
          } else {
            // Set the new value.
            this.value = value;

            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.only(right: (kMinInteractiveDimension / 3) - 4),
          child: label ?? (value as Widget),
        ),
      ),
    );
  }
}

/// Holds the value of the selected button so parent widgets can know what
/// is selected and also allows parent widgets to set a new selected value.
///
/// {@tool snippet}
///
/// This sample shows how to retrieve the value of the selected button.
///
/// ```dart
/// // First initialize everything
/// RadioGroupController myController = RadioGroupController();
/// List<String> items = ["Choice1", "Choice2", "Choice3"];
/// RadioGroup(
///   controller: myController,
///   values: items,
///   onChanged: (value) {
///     liveChangeHere();
///   },
///   orientation: Horizontal,
/// )
///
/// // This code programmatically sets the last radio button as "selected".
/// myController.value = items.last;
///
/// // This code retrieves the value of the selected button.
/// String selectedValue = myController.value as String;
/// ```
/// {@end-tool}
class RadioGroupController {
  /// This is the state of the radio group that this controller is in charge of.
  _RadioGroupState? _myRadioGroup;

  /// Sets the value of the selected item in `this` controller's radio group.
  ///
  /// @throws [IllegalValueException] If the `value` provided is not a value in
  /// the radio group's values list.
  ///
  /// @throws [ControllerDecoupledException] If the controller cannot access the
  /// value of its radio group.
  set value(Object? value) {
    if (_myRadioGroup != null) {
      if (value != null && !_myRadioGroup!.widget.values.contains(value)) {
        throw IllegalValueException(value: value);
      }

      _myRadioGroup!.value = value;
      return;
    }

    // If it makes it to this point, something has gone wrong.
    throw ControllerDecoupledException(radioGroupController: this);
  }

  /// Returns the value of the selected item in `this` controller's radio group.
  ///
  /// @throws [ControllerDecoupledException] If the controller cannot access the
  /// value of its radio group.
  Object? get value {
    if (_myRadioGroup != null) {
      return _myRadioGroup!._value;
    }

    // If it makes it to this point, something has gone wrong.
    throw ControllerDecoupledException(radioGroupController: this);
  }

  /// Sets the value of the selected item in `this` controller's radio group to
  /// the value of the element at `index` in the radio group's value list.
  ///
  /// **Note:** By setting `index` to `-1`, the radio group will deselect all
  /// options.
  ///
  /// @throws [IndexOutOfBoundsException] If the `index` provided is not within
  /// the range of the radio group's value list.
  ///
  /// @throws [ControllerDecoupledException] If the controller cannot access the
  /// value of its radio group.
  void selectAt(int index) {
    if (_myRadioGroup != null) {
      if (index == -1) {
        value = null;
      } else if (index >= 0 && index < _myRadioGroup!.widget.values.length) {
        value = _myRadioGroup!.widget.values[index];
      } else {
        throw IndexOutOfBoundsException(
          index: index,
          iterable: _myRadioGroup!.widget.values,
        );
      }
    }
  }
}

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
    this.labelStyle,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
  }) : assert(spacing >= 0.0, "ERROR: \`spacing\` cannot be less than 0.0!");

  /// The amount of space between each button.
  final double spacing;

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
  final MaterialStateProperty<Color?>? fillColor;

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
  final MaterialStateProperty<Color?>? overlayColor;

  /// The splash radius of the circular `Material` ink response.
  ///
  /// If `null`, then the value of `RadioThemeData.splashRadius` is used. If
  /// that is also `null`, then `kRadialReactionRadius` is used.
  ///
  /// Comment info copied from:
  /// https://api.flutter.dev/flutter/material/Radio/splashRadius.html
  final double? splashRadius;
}

/// The exception that is thrown when the [RadioGroupController] can no longer
/// see its [RadioGroup].
class ControllerDecoupledException implements Exception {
  /// Throws an exception for a [RadioGroupController] that can no longer see
  /// its [RadioGroup].
  ///
  /// `radioGroupController` is the controller that is throwing the error.
  ControllerDecoupledException({RadioGroupController? radioGroupController}) {
    // Check to see if the radio group controller that caused `this` exception
    // to be thrown was provided.
    if (radioGroupController == null) {
      // If no controller was provided, throw the default error message.
      throw (_cause);
    } else {
      // If the radio group controller was provided, include it in the error
      // message to help with debugging.
      throw ("$_errMsgPt1 " +
          "RadioGroupController:${radioGroupController.toString()} " +
          "$_errMsgPt2");
    }
  }

  /// The first part of the error message.
  static const String _errMsgPt1 = "ERROR:";

  /// The last part of the error message.
  static const String _errMsgPt2 = "has lost track of its \`RadioGroup\`!";

  /// The default error message.
  static const String _cause =
      "$_errMsgPt1 This \`RadioGroupController\` $_errMsgPt2";
}

/// The exception that is thrown when the [RadioGroupController] tries to set a
/// value that is not part of the [RadioGroup]'s value list.
class IllegalValueException implements Exception {
  /// Throws an exception when the [RadioGroupController] tries to set a value
  /// that is not part of the [RadioGroup]'s value list.
  ///
  /// `radioGroupController` is the controller that is throwing the error.
  IllegalValueException({Object? value}) {
    // Check to see if the value that caused `this` exception to be thrown was
    // provided.
    if (value == null) {
      // If no value was provided, throw the default error message.
      throw (_cause);
    } else {
      // If the value was provided, include it in the error message to help with
      // debugging.
      throw ("$_errMsgPt1 ${value.runtimeType}:${value.toString()} $_errMsgPt2");
    }
  }

  /// The first part of the error message.
  static const String _errMsgPt1 = "ERROR:";

  /// The last part of the error message.
  static const String _errMsgPt2 =
      "is not a value in the radio group's values list!";

  /// The default error message.
  static const String _cause = "$_errMsgPt1 This value $_errMsgPt2";
}

/// The exception that is thrown when the [RadioGroupController] tries to set a
/// value at an index that is outside of the [RadioGroup]'s value list's range.
class IndexOutOfBoundsException implements Exception {
  /// Throws an exception when the [RadioGroupController] tries to set a value
  /// at an index that is outside of the [RadioGroup]'s value list's range.
  ///
  /// `index` is the index that is throwing the error.
  ///
  /// `iterable` is the value list for the radio group.
  IndexOutOfBoundsException({int? index, Iterable? iterable}) {
    throw ("$_errMsgPt1 " +
        "${index ?? '[index not provided to exception thrower]'} " +
        "$_errMsgPt2 " +
        "${iterable?.length ?? '[iterable length not provided to exception thrower]'}" +
        "$_errMsgPt3");
  }

  /// The first part of the error message.
  static const String _errMsgPt1 = "ERROR:";

  /// The middle part of the error message.
  static const String _errMsgPt2 = "is out of bounds for iterable of length";

  /// The last part of the error message.
  static const String _errMsgPt3 = "!";
}
