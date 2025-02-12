# Add-Ons

Add-ons are basically plug-ins that aren't high enough quality to be on [pub.dev](https://pub.dev/) (external link). They are just files to add to your project manually.

## Table of Contents
- [DbTools](#DbTools)
- [DebugLog](#DebugLog)
- [MyAlert](#MyAlert)
- [MyFileExplorer](#MyFileExplorer)
- [MyImageCropper](#MyImageCropper)
- [MyImageImporter](#MyImageImporter)
- [MyLoadingOverlay](#MyLoadingOverlay)
- [MyRichText](#MyRichText)
- [MyScaffold](#MyScaffold)
- [MyText](#MyText)
- [MyTextField](#MyTextField)
- [MyTools](#MyTools)
- [MyValidator](#MyValidator)

<!---     TEMPLATE
## ClassName

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

Example explanation...

```dart
code example...
```

[back to top](#table-of-contents)
--->

## DbTools

**[source code](db_tools.dart)**

These are database tools. There are encryptors and decryptors to store data in the database safely.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| - my_tools | *none* |


[back to top](#table-of-contents)

## DebugLog

**[source code](debug_log.dart)**

This add-on is a tool designed to assist in the debugging process. Rather than making a bunch of print statements to find an error, use this in their stead.

Print statements can easily be forgotten and left in the code; later on, you'll see print statements coming out when running your program and not be able to find and remove them.

`DebugLog` remedies this formatting your print statements in such a way that they can easily be found later on. It also allows you to change the color of the output (if your console supports it), to make your messages more visible.

Rather than just being a random print statement, `DebugLog` makes a print statement with searchable parts. It formats the statement like so:

`ClassName.methodName [file_name.dart:ln#]: Debugging message set by developer`

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | - collection<br>- firebase_crashlytics<br>-stack_trace |

### Usage

```dart
DebugLog.out('Howdy'); // Howdy
DebugLog.out('Howdy', logType: LogType.error); // Howdy (in red)
```

In the above examples, if the app is live, nothing happens. The example below shows how to send to Crashlytics.

```dart
// If live, this will send "Howdy" to Crashlytics.
// If testing, this will print "Howdy" to the console.
DebugLog.out('Howdy', sendToCrashlytics: true);
```

[back to top](#table-of-contents)

## MyAlert

**[source code](my_alert.dart)**

This file allows for the creation of a pop-up that will cover a lot of the screen with an opaque message box and fills the rest of the screen with a translucent overlay to disable touching the page in the background.

This pop-up can be used to give the user warnings, give them information, allow for confirmation before certain actions, etc.

To use it, you must first create a MyAlert object with all of the parameters for the alert. Then, when you are ready to show it to the user, call that MyAlert object's `show` method. The alert will automatically be closed when the user clicks any of the buttons or if they click outside of the alert.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | *none* |

### Usage

The example below shows the creation of an alert that is used as a warning. It can explain to the user why they are not being allowed to do a certain thing.

```dart
/// The alert dialog that will be shown to the user.
MyAlert myAlert = MyAlert(
  title: 'Action Blocked!',
  content: 'Your attempt to do this action has been blocked because this '
      'action can not be completed at this time. Thank you!',
  buttons: {
    'ok': () {},
  },
);

// Show [myAlert] to the user.
myAlert.show(context);
```

The example below shows the creation of an alert that is used as a way of giving the user information.

```dart
/// The alert dialog that will be shown to the user.
MyAlert myAlert = MyAlert(
  title: 'Did you know?',
  content: Text('Flutter was initially released in May of 2017?'),
  buttons: {
    'Now I Know': () => null,
  },
);

// Show [myAlert] to the user.
myAlert.show(context);
```

The example below shows the creation of an alert that is used as a way of confirming something with the user.

```dart
/// The alert dialog that will be shown to the user.
MyAlert myAlert = MyAlert(
  title: 'Are you sure?',
  content: 'Are you sure you want to leave this page? Any unsaved data '
      'will be lost.',
  buttons: {
    'leave': () => leavePageAnyway(),
    'cancel': () => null,
  },
);

// Show [myAlert] to the user.
myAlert.show(context);
```

[back to top](#table-of-contents)

## MyFileExplorer

**[source code](my_file_explorer.dart)**

This allows for the easy exploration of your app's working directory on the device.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | - path_provider |

### Usage

*Examples can be found in the source code.*

[back to top](#table-of-contents)

## MyImageCropper

**[source code](my_image_cropper.dart)**

This add-on allows users to crop images.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| - my_file_explorer | - image_cropper |

### Usage

This example shows how to create an image cropper that only allows the user to create a square image.

```dart
/// Original sized image.
File myImage = File('/path/to/image.jpg');

// Crop the image.
File? croppedImage = MyImageCropper.crop(
  image: myImage,
  aspectRatioPresets: [CropAspectRatioPreset.square],
  uiSettings: [
    AndroidUiSettings(
      initAspectRatio: CropAspectRatioPreset.square,
      lockAspectRatio: true,
    ),
    IOSUiSettings(
      minimumAspectRatio: 1.0,
      aspectRatioLockEnabled: true,
    ),
    WebUiSettings(
      context: context,
    ),
  ],
);
```

[back to top](#table-of-contents)

## MyImageImporter

**[source code](my_image_importer.dart)**

This is used to import an image into the program. It can get an image from the device's default gallery or the camera.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| - my_file_explorer | - image_picker |

### Usage

This example shows how to get the image from the device's default gallery. This is most useful when you know you will always want to pull from the gallery and not the camera.

```dart
File? myImage = await MyImageImporter.importFromGallery();
```

This is an example of the generic `import` method. This method is most useful when you don't know if the user will want an image from their gallery or from the camera.

```dart
/// Whether the user wants the image to come from the camera or not.
bool isCamera;

// ...
// Something sets [isCamera]
// ...

/// The location the image will be coming from.
ImageOrigin imageOrigin = isCamera ? ImageOrigin.camera : ImageOrigin.gallery;

/// The imported image.
File? myImage = await MyImageImporter.import(imageOrigin);
```

[back to top](#table-of-contents)

## MyLoadingOverlay

**[source code](my_loading_overlay.dart)**

A loading overlay that shows a circular progress indicator or a user defined widget.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | *none* |

### Usage

This is just a simple loading overlay with a circular progress indicator. This example also demonstrates how to show and close the overlay.

```dart
final MyLoadingOverlay myLoadingOverlay = MyLoadingOverlay();
await myLoadingOverlay.show(context);
// Do some work here.
if (closeNow) {
  await myLoadingOverlay.close(); // To close immediately
}
// Do more work here.
if(wasSuccessful) {
  await myLoadingOverlay.closeWithSuccess();
} else {
  await myLoadingOverlay.closeWithFailure();
}
// Alternatively
await myLoadingOverlay.closeWithCustomMessage(child: 
  Text('Custom widget here'),
);
```

This example shows how to use a custom widget for the loading overlay. This custom widget will be displayed instead of the default circular progress indicator.

Note: For Columns, be sure to set the `mainAxisSize` to `MainAxisSize.min` if you want this widget to be centered.

```dart
MyLoadingOverlay(
  child: const Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CircularProgressIndicator(),
      Text('Loading...'),
    ],
  ),
);
```

[back to top](#table-of-contents)

## MyRichText

**[source code](my_rich_text.dart)**

A widget that displays text with the ability to only emphasize certain parts of the text.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | *none* |

### Usage

This will display "Hello, **world**!" with "world" being the emphasized text, thus it takes on the characteristics of the provided style (in this case, bold).

```dart
MyRichText(
  style: TextStyle(fontWeight: FontWeight.bold),
  children: [
    MyNormalText('Hello, '),
    MyEmphasizedText('world'),
    MyNormalText('!'),
  ],
)
```

[back to top](#table-of-contents)

## MyScaffold

**[source code](my_scaffold.dart)**

This scaffold is a group of foundational widgets, put together to eliminate boilerplate and make the code cleaner. Since almost every screen and page is built with these at their core, it has been placed in one convenient widget.

`Scaffold` > `SafeArea` > `Padding`

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | *none* |

### Usage

Takes the place of Flutter's `Scaffold`.

```dart
@override
Widget build(BuildContext context) {
  return MyScaffold(
    appBar: AppBar(title: const Text('Page Title')),
    builder: (context) => MyPage(), // Your page code here
  );
}
```

[back to top](#table-of-contents)

## MyText

**[source code](my_text.dart)**

Just like Flutter's `Text` widget. This just adds the abiltity to more easily and cleanly change the color and size of the text.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | *none* |

### Usage

Example explanation...

```dart
MyText('Howdy'); // Howdy
MyText('Howdy', color: Colors.red); // Howdy (in red)
MyText('Howdy', myTextStyle: MyTextStyle.title); // Howdy (big)
```

[back to top](#table-of-contents)

## MyTextField

**[source code](my_text_field.dart)**

A custom text field very similar to Flutter's `TextField`. The main difference is that this one has custom validators/input testers.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | *none* |

### Usage

Set up your key and your controller.

```dart
final GlobalKey<MyTextFieldState> messageFieldKey = GlobalKey();
final TextEditingController messageController = TextEditingController();
```

Create your tests. This example shows two tests. The first is a default test that makes sure the field is not left empty. The second is a custom test that makes sure the field does not have more than 250 characters.

```dart
List<MyTextFieldValidator> get messageValidators => [
  const MyTextFieldValidator.testEmpty(testTrigger: TestTrigger.never),
  MyTextFieldValidator(
    test: (value) => value.length <= 250,
    expected: true,
    errorText: 'Too long - 250 characters max',
  ),
];
```

Build the widget.

```dart
MyTextField(
  key: messageFieldKey,
  controller: messageController,
  hint: 'Message',
  minLines: 5,
  maxLines: 250,
  validators: messageValidators,
  isLastField: true,
),
```

Check for errors before subitting form.

```dart
/// This method checks to see if there are any formatting errors in the user's
/// input in the form.
///
/// If `displayErrorMsg` is true, then the error messages assigned to the
/// text field controllers will be displayed to the user.
///
/// Returns `true` if there are any errors.
Future<bool> hasInputError({bool displayErrorMsg = false}) async {
  // Check the message.
  bool messageHasError = false;
  if (messageFieldKey.currentState != null) {
    messageHasError = await messageFieldKey.currentState!.hasErrors(
      displayErrorMsg: displayErrorMsg,
    );
  }

  return messageHasError;
}
```

[back to top](#table-of-contents)

## MyTools

**[source code](my_tools.dart)**

This is a collection of generic tools. These range from random number generators to network connection checkers.

This is an add-on because each individual method is too small to be a plug-in, and together they are too unrelated to be a single plug-in.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| - debug_log | - intl |

### Usage

*Examples can be found in the source code.*

[back to top](#table-of-contents)

## MyValidator

**[source code](my_validator.dart)**

A collection of validators to check user input.

These validators compare the inputs to specified regex patterns to see if they are valid.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | *none* |

### Usage

This example shows how to use the email validator.

```dart
String goodEmail = 'test@email.com';
String badEmail = 'test@com';

MyValidator.isValidEmail(goodEmail); // true
MyValidator.isValidEmail(badEmail); // false
```

[back to top](#table-of-contents)