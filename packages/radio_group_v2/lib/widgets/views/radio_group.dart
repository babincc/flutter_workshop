import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radio_group_v2/exceptions/invalid_key_type_exception.dart';
import 'package:radio_group_v2/utils/radio_group_decoration.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';

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
///
/// ### Horizontal Layout
///
/// When the [RadioGroupOrientation.horizontal] orientation is selected, this
/// returns a [Wrap] which contains the [Row] widgets described in the
/// "Individual Radio Button" section above.
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
///
/// ### Retrieving Selected Value
///
/// This example shows what to do if you want to see which choice is selected
/// from the two examples above.
///
/// ```dart
/// print("The chosen value is: ${myController.value.toString()}");
/// ```
///
/// See also:
///
/// * [RadioGroupController] which is used to know which button in the group is
///   selected as well as programmatically select a button.
class RadioGroup<T> extends StatefulWidget {
  /// Creates a widget which contains [Radio] buttons that a user can click to
  /// make selections within the app.
  ///
  /// **Note:** Any value in `values` that is not a [Widget] will be displayed
  /// as a string in a [Text] widget for the button's label, unless
  /// `labelBuilder` is provided.
  RadioGroup({
    GlobalKey<RadioGroupState<T>>? key,
    this.controller,
    required this.values,
    this.labelBuilder,
    this.onChanged,
    this.indexOfDefault = -1,
    this.orientation = RadioGroupOrientation.vertical,
    this.decoration,
  })  : assert(
            indexOfDefault < values.length,
            "ERROR: `indexOfDefault` is out of bounds for the range of "
            "`values`!"),
        _controller = controller ?? RadioGroupController<T>(),
        super(
            key: key ??
                controller?.myRadioGroupKey ??
                GlobalKey<RadioGroupState<T>>()) {
    if (controller == null && key == null) {
      if (kDebugMode) {
        log(
          'RadioGroup Warning: You have not included a `key` or a `controller` '
          'for this radio group. If the parent state is updated, this could '
          'cause unexpected behavior. To fix this, either include a `key` or a '
          '`controller` for this radio group, and make sure they will not be '
          'updated when the parent state is updated.',
          stackTrace: StackTrace.current,
        );
      }
    }
  }

  /// This allows for setting and getting the value of `this` radio group.
  final RadioGroupController<T>? controller;

  /// This allows for setting and getting the value of `this` radio group.
  ///
  /// Note: This is the one that is to be used throughout the code. [controller]
  /// only exists to give programmers a more comfortable coding experience when
  /// using this library as a plug-in.
  final RadioGroupController<T> _controller;

  /// The labels for each of the buttons (in order of how they will be
  /// displayed).
  final List<T> values;

  /// A builder function to create the label for each radio button.
  final Widget Function(T value)? labelBuilder;

  /// A function that is called whenever the user clicks a different radio
  /// button than the on that is currently selected.
  ///
  /// `value` is the value that was just selected to trigger this function.
  final void Function(T? value)? onChanged;

  /// The index in the [values] list of the radio button which will start out
  /// selected.
  final int indexOfDefault;

  /// The style and design of the radio group.
  final RadioGroupDecoration? decoration;

  /// How the radio button list will be laid out on the screen.
  final RadioGroupOrientation orientation;

  @override
  State<RadioGroup<T>> createState() => RadioGroupState<T>();
}

class RadioGroupState<T> extends State<RadioGroup<T>> {
  T? _value;

  /// The value of the selected element in the radio group.
  T? get value => _value;
  set value(T? value) {
    if (!mounted) return;

    if (value == this.value) return;

    setState(() {
      _value = value;

      if (widget.onChanged == null) return;

      widget.onChanged!(value);
    });
  }

  /// Sets the value of the selected element in the radio group without calling
  /// the `onChanged` callback.
  void setValueSilently(T? value) {
    if (!mounted) return;

    if (value == this.value) return;

    setState(() {
      _value = value;
    });
  }

  /// The index of the selected element in the radio group.
  int get selectedIndex {
    if (_value == null) {
      return -1;
    } else {
      return widget.values.indexOf(_value as T);
    }
  }

  /// Called when the app creates a radio group. This needs to be called
  /// specifically to set default values in the [RadioGroupController] for this
  /// radio group.
  @override
  void initState() {
    super.initState();

    if (widget.key != null) {
      if (widget.key is! GlobalKey<RadioGroupState>) {
        throw InvalidKeyTypeException();
      }

      // Let the controller know who its radio group is.
      widget._controller.myRadioGroupKey =
          widget.key as GlobalKey<RadioGroupState<T>>;
    }

    // Set default starting value.
    if (widget.indexOfDefault < 0) {
      _value = null;
    } else {
      _value = widget.values[widget.indexOfDefault];
    }
  }

  /// Build the radio group and send it back to the calling method.
  @override
  Widget build(BuildContext context) {
    // If the orientation of the radio button list is vertical, do this.
    if (widget.orientation == RadioGroupOrientation.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: _verticalRadioListBuilder(),
      );
    } else {
      // Otherwise, the orientation is horizontal; so, do this.
      return Wrap(
        alignment:
            widget.decoration?.horizontalAlignment ?? WrapAlignment.center,
        spacing: widget.decoration?.spacing ?? 0.0,
        runSpacing: widget.decoration?.runSpacing ?? 0.0,
        children: [
          for (final T currValue in widget.values)
            IntrinsicWidth(
              child: _radioItemBuilder(currValue),
            ),
        ],
      );
    }
  }

  /// This method builds a vertical radio list.
  ///
  /// This method is needed to account for the spacing between each radio
  /// button.
  List<Widget> _verticalRadioListBuilder() {
    // If there is no spacing, just return the radio buttons.
    if (widget.decoration == null || widget.decoration!.spacing == 0.0) {
      return widget.values.map((value) {
        return _radioItemBuilder(value);
      }).toList();
    }

    final List<Widget> radioList = [];

    for (int i = 0; i < widget.values.length; i++) {
      radioList.add(_radioItemBuilder(widget.values[i]));

      if (i < widget.values.length - 1) {
        radioList.add(SizedBox(height: widget.decoration!.spacing));
      }
    }

    return radioList;
  }

  /// This method builds each radio item, which consists of the button and its
  /// label.
  Row _radioItemBuilder(T value) {
    return Row(
      mainAxisAlignment:
          widget.decoration?.verticalAlignment ?? MainAxisAlignment.start,
      children: [
        _buttonBuilder(value),
        _labelBuilder(value),
      ],
    );
  }

  /// This method builds a button with a value that is passed to it. This is
  /// what allows the [RadioGroup] widget to be dynamically sized. It can hold
  /// as many or as few values as it needs.
  Radio _buttonBuilder(T value) {
    return Radio(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: value,
      groupValue: _value,
      onChanged: (newValue) {
        if (!mounted) return;

        setState(
          () {
            _value = newValue;

            if (widget.onChanged != null) {
              widget.onChanged!(newValue);
            }
          },
        );
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
  Flexible _labelBuilder(T value) {
    Widget? label;

    /// If the programmer has provided a label builder, use that.
    if (widget.labelBuilder != null) {
      label = widget.labelBuilder!(value);
    } else if (value is! Widget) {
      // Otherwise, if `value` is not a widget, turn it into a string to be
      // shown as a Text widget.
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
