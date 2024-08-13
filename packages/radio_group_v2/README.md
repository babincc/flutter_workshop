# Radio Group

A widget that groups radio buttons so they can work together to give the user a pleasant experience when making selections within the app.

![A gif demonstrating the radio group in action.](https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/demos/radio_group_demo.gif)

## Installation

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  radio_group_v2: ^3.2.1
```

Import it to each file you use it in:

```dart
import 'package:radio_group_v2/radio_group_v2.dart';
```

## Usage

### Example 1

This example is a very basic, vertical radio group.

```dart
RadioGroupController myController = RadioGroupController();

RadioGroup(
  controller: myController,
  values: ["Choice1", "Choice2", "Choice3"],
)
```

### Example 2

This example is a horizontal radio group with some decoration, and it starts with the first button selected.

```dart
RadioGroupController myController = RadioGroupController();

RadioGroup(
  controller: myController,
  values: ["Choice1", "Choice2", "Choice3"],
  indexOfDefault: 0,
  orientation: RadioGroupOrientation.Horizontal,
  decoration: RadioGroupDecoration(
    spacing: 10.0,
    labelStyle: TextStyle(
      color: Colors.blue,
    ),
    activeColor: Colors.amber,
  ),
)
```

### Example 3

This example shows how to programmatically select an item using two different methods.

```dart
RadioGroupController myController = RadioGroupController();

List<String> items = ["Choice1", "Choice2", "Choice3"];

RadioGroup(
  controller: myController,
  values: items,
)

// Method 1 - Selects a specific item from the list.
myController.value = items[1];

// Method 2 - Selects whatever item is at the given
//            index in the list.
myController.selectAt(2);
```

### Example 4

This example shows how to retrieve the selected value.

```dart
RadioGroupController myController = RadioGroupController();

RadioGroup(
  controller: myController,
  values: ["Choice1", "Choice2", "Choice3"],
)

String selected = myController.value.toString();
```

<hr>

<h3 align="center">If you found this helpful, please consider donating. Thanks!</h3>
<p align="center">
  <a href="https://www.buymeacoffee.com/babincc" target="_blank">
    <img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/donate_icons/buy_me_a_coffee_logo.png" alt="buy me a coffee" height="45">
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://paypal.me/cssbabin" target="_blank">
    <img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/donate_icons/pay_pal_logo.png" alt="paypal" height="45">
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://venmo.com/u/babincc" target="_blank">
    <img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/donate_icons/venmo_logo.png" alt="venmo" height="45">
  </a>
</p>
<br><br>
