# Add-Ons

Add-ons are basically plug-ins that either aren't finished yet, didn't need to be finished, or aren't high enough quality to be on [pub.dev](https://pub.dev/) (external link). They are just files to add to your project manually.

## Table of Contents
- [alert](#alert)
- [debug_log](#debug_log)
- [tools](#tools)

<!---     TEMPLATE
## class_name

**[source code](class_name.dart)**

Brief summary on the add-on...

Brief explanation of how the add-on works...

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| - item_1<br>-item_2 | *none* |

### Usage

Example explanation...

```dart
code example...
```

<br>

Example explanation...

```dart
code example...
```

[back to top](#table-of-contents)
--->

## alert

**[source code](alert.dart)**

This file allows for the creation of a pop-up that will cover a lot of the screen with an opaque message box and fills the rest of the screen with a translucent overlay to disable touching the page in the background.

This pop-up can be used to give the user warnings, give them information, allow for confirmation before certain actions, etc.

To use it, you must first create an Alert object with all of the parameters for the alert. Then, when you are ready to show it to the user, call that Alert object's .show() method. The alert will automatically be closed when the user clicks any of the buttons or if they click outside of the alert.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | *none* |

### Usage

The example below shows the creation of an alert that is used as a warning. It can explain to the user why they are not being allowed to do a certain thing.

```dart
/// The alert dialog that will be shown to the user.
Alert myAlert = Alert(
  context: context,
  title: "Action Blocked!",
  content: "Your attempt to do this action has been blocked because this "
      "action can not be completed at this time. Thank you!",
  buttons: {
    "ok": () => null,
  },
);

// Show [myAlert] to the user.
myAlert.show();
```

<br>

The example below shows the creation of an alert that is used as a way of giving the user information.

```dart
/// The alert dialog that will be shown to the user.
Alert myAlert = Alert(
  context: context,
  title: "Did you know?",
  content: Text("Flutter was initially released in May of 2017?"),
  buttons: {
    "Now I Know": () => null,
  },
);

// Show [myAlert] to the user.
myAlert.show();
```

<br>

The example below shows the creation of an alert that is used as a way of confirming something with the user.

```dart
/// The alert dialog that will be shown to the user.
Alert myAlert = Alert(
  context: context,
  title: "Are you sure?",
  content: "Are you sure you want to leave this page? Any unsaved data "
      "will be lost.",
  buttons: {
    "leave": () => leavePageAnyway(),
    "cancel": () => null,
  },
);

// Show [myAlert] to the user.
myAlert.show();
```

[back to top](#table-of-contents)

## debug_log

**[source code](debug_log.dart)**

This add-on is a tool designed to assist in the debugging process. Rather than making a bunch of print statements to find an error, use this in their stead.

Print statements can easily be forgotten and left in the code; later on, you'll see print statements coming out when running your program and not be able to find and remove them.

`debug_log` remedies this by getting you to format your print statements in such a way that they can easily be found later on. It also has a feature that makes the `debug_log` statement more prominent in the console than a print statement (set `isImportant` to `true`).

Rather than just being a random print statement, `debug_log` makes a print statement with searchable parts. It formats the statement like so:

ClassName/methodName: Debugging message set by developer

-- or --

ClassName/methodName: !!!!!! IMPORTANT !!!!!!<br>
ClassName/methodName: !!!!!!! IMPORTANT !!!!!!!<br>
ClassName/methodName: !!!!!!!! IMPORTANT !!!!!!!!<br>
ClassName/methodName: Debugging message set by developer<br>
ClassName/methodName: !!!!!!!! IMPORTANT !!!!!!!!<br>
ClassName/methodName: !!!!!!! IMPORTANT !!!!!!!<br>
ClassName/methodName: !!!!!! IMPORTANT !!!!!!

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | *none* |

### Usage

This example below shows the `debug_log` being used make a print statement in a method run.

```dart
void problemMethod(String passedInWord) {
  // Do stuff

  // Print the value of passedInWord to see if it is as expected.
  DebugLog.out("ClassName", "problemMethod", "passedInWord = $passedInWord");

  // Do more stuff
}
```

<br>

This example below shows the `debug_log` being used make a print statement in a method run. The difference between this and the last example; however, is that this one is using the feature that makes the print statement more prominent in the console.

```dart
void problemMethod(String passedInWord) {
  // Do stuff

  // Print the value of passedInWord to see if it is as expected.
  DebugLog.out("ClassName", "problemMethod", "passedInWord = $passedInWord", isImportant = true);

  // Do more stuff
}
```

[back to top](#table-of-contents)

## tools

**[source code](tools.dart)**

This is a collection of generic tools. These range from random number generators to network connection checkers.

This is an add-on because each individual method is too small to be a plug-in, and together they are too unrelated to be a single plug-in.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | *none* |

### Usage

*Examples can be found in the source code.*

[back to top](#table-of-contents)
