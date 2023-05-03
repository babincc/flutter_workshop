# Add-Ons

Add-ons are basically plug-ins that aren't high enough quality to be on [pub.dev](https://pub.dev/) (external link). They are just files to add to your project manually.

## Table of Contents
- [debug_log](#debug_log)
- [my_alert](#my_alert)
- [my_file_explorer_sdk](#my_file_explorer_sdk)
- [my_image_cropper](#my_image_cropper)
- [my_image_importer](#my_image_importer)
- [my_tools](#my_tools)

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

## debug_log

**[source code](debug_log.dart)**

This add-on is a tool designed to assist in the debugging process. Rather than making a bunch of print statements to find an error, use this in their stead.

Print statements can easily be forgotten and left in the code; later on, you'll see print statements coming out when running your program and not be able to find and remove them.

`DebugLog` remedies this formatting your print statements in such a way that they can easily be found later on. It also allows you to change the color of the output (if your console supports it), to make your messages more visible.

Rather than just being a random print statement, `DebugLog` makes a print statement with searchable parts. It formats the statement like so:

`ClassName.methodName [file_name.dart:ln#]: Debugging message set by developer`

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | - firebase_crashlytics |

### Usage

```dart
DebugLog.out("Howdy"); // Howdy
DebugLog.out("Howdy", logType: LogType.error); // Howdy (in red)
```

In the above examples, if the app is live, nothing happens. The example below shows how to send to Crashlytics.

```dart
// If live, this will send "Howdy" to Crashlytics.
// If testing, this will print "Howdy" to the console.
DebugLog.out("Howdy", sendToCrashlytics: true);
```

[back to top](#table-of-contents)

## my_alert

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
    title: "Action Blocked!",
    content: "Your attempt to do this action has been blocked because this "
        "action can not be completed at this time. Thank you!",
    buttons: {
      "ok": () {},
    },
  );

 // Show [myAlert] to the user.
 myAlert.show(context);
 ```

<br>

The example below shows the creation of an alert that is used as a way of giving the user information.

```dart
/// The alert dialog that will be shown to the user.
MyAlert myAlert = MyAlert(
  title: "Did you know?",
  content: Text("Flutter was initially released in May of 2017?"),
  buttons: {
    "Now I Know": () => null,
  },
);

// Show [myAlert] to the user.
myAlert.show(context);
```

<br>

The example below shows the creation of an alert that is used as a way of confirming something with the user.

```dart
/// The alert dialog that will be shown to the user.
MyAlert myAlert = MyAlert(
  title: "Are you sure?",
  content: "Are you sure you want to leave this page? Any unsaved data "
      "will be lost.",
  buttons: {
    "leave": () => leavePageAnyway(),
    "cancel": () => null,
  },
);

// Show [myAlert] to the user.
myAlert.show(context);
```

[back to top](#table-of-contents)

## my_file_explorer_sdk

**[source code](my_file_explorer_sdk/my_file_explorer_sdk.dart)**

This allows for the easy exploration of your app's working directory on the device.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| *none* | - path_provider |

### Usage

*Examples can be found in the source code.*

[back to top](#table-of-contents)

## my_image_cropper

**[source code](my_image_cropper.dart)**

This add-on allows users to crop images.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| - my_file_explorer_sdk | - image_cropper |

### Usage

This example shows how to create an image cropper that only allows the user to create a square image.

```dart
/// Original sized image.
File myImage = File("/path/to/image.jpg");

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

## my_image_importer

**[source code](my_image_importer.dart)**

This is used to import an image into the program. It can get an image from the device's default gallery or the camera.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| - my_file_explorer_sdk | - image_picker |

### Usage

This example shows how to get the image from the device's default gallery. This is most useful when you know you will always want to pull from the gallery and not the camera.

```dart
File? myImage = await MyImageImporter.importFromGallery();
```

<br>

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

## my_tools

**[source code](my_tools.dart)**

This is a collection of generic tools. These range from random number generators to network connection checkers.

This is an add-on because each individual method is too small to be a plug-in, and together they are too unrelated to be a single plug-in.

### Dependencies

| Add-ons from this list | .yaml dependencies |
| --- | --- |
| - debug_log | *none* |

### Usage

*Examples can be found in the source code.*

[back to top](#table-of-contents)
