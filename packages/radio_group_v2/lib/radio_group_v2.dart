// @author Christian Babin
// @version 2.1.2
// https://github.com/babincc/flutter_workshop/blob/master/packages/radio_group_v2/lib/radio_group_v2.dart

import 'package:flutter/material.dart';

import 'exceptions/invalid_key_type_exception.dart';
import 'radio_group_controller.dart';
import 'radio_group_decoration.dart';
export 'radio_group_controller.dart';
export 'radio_group_decoration.dart';

/// A widget that creates a set of radio buttons in a single, interconnected
/// group.
///
/// ### Individual Radio Button
///
/// Each radio button is a [Radio] widget housed inside of a [Row] along with a
/// either the value itself if it is a widget or a [Text] widget with the value
/// as a string to label the button for the user to know what the button is
/// representing.
///
/// One of these is created for every value that comes into this builder.
///
/// ### Vertical Layout
///
/// When the [RadioGroupOrientation.vertical] orientation is selected, this
/// returns a [Column] which contains the [Row] widgets described in the
/// "Individual Radio Button" section above.
///
/// {@tool snippet}
///
/// This example shows the creation of a radio group that is aligned vertically.
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
/// When the [RadioGroupOrientation.horizontal] orientation is selected, this
/// returns a [Wrap] which contains the [Row] widgets described in the
/// "Individual Radio Button" section above.
///
/// {@tool snippet}
///
/// This example shows the creation of a radio group that is aligned
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
/// This example shows what to do if you want to see which choice is selected
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
  /// as a string in a [Text] widget for the button's label.
  RadioGroup({
    GlobalKey<RadioGroupState>? key,
    this.controller,
    required this.values,
    this.onChanged,
    this.indexOfDefault = -1,
    this.orientation = RadioGroupOrientation.vertical,
    this.decoration,
  })  : assert(
            indexOfDefault < values.length,
            "ERROR: `indexOfDefault` is out of bounds for the range of "
            "`values`!"),
        _controller = controller ?? RadioGroupController(),
        super(key: key ?? GlobalKey<RadioGroupState>());

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

  /// How the radio button list will be laid out on the screen.
  final RadioGroupOrientation orientation;

  @override
  RadioGroupState createState() => RadioGroupState();
}

class RadioGroupState extends State<RadioGroup> {
  Object? _value;

  /// The value of the selected element in the radio group.
  Object? get value => _value;
  set value(Object? value) => setState(() => _value = value);

  /// Called when the app creates a radio group. This needs to be called
  /// specifically to set default values in the [RadioGroupController] for this
  /// radio group.
  @override
  void initState() {
    if (widget.key is! GlobalKey<RadioGroupState>) {
      throw InvalidKeyTypeException();
    }

    // Let the controller know who its radio group is.
    widget._controller.myRadioGroupKey =
        widget.key as GlobalKey<RadioGroupState>;

    // Set default starting value.
    if (widget.indexOfDefault < 0) {
      value = null;
    } else {
      value = widget.values[widget.indexOfDefault];
    }

    super.initState();
  }

  /// Build the radio group and send it back to the calling method.
  @override
  Widget build(BuildContext context) {
    // If the orientation of the radio button list is vertical, do this.
    if (widget.orientation == RadioGroupOrientation.vertical) {
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
    if (value is! Widget) {
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

/// Describes how the radio button list will be laid out on the screen.
enum RadioGroupOrientation {
  /// When this is set as the orientation, the buttons will be laid out on top
  /// of each other in a single stack.
  vertical,

  /// When this is set as the orientation, the buttons will be laid out side by
  /// side and wrap around to the next line when they reach the edge of the
  /// screen.
  horizontal,
}
