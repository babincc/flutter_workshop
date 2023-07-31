# n-Dimensional Array

<img src="https://raw.githubusercontent.com/babincc/flutter_workshop/master/packages/resources/demos/nd_array_image.png" alt="Flutter Hue logo" height="250">

The n-Dimensional Array package is a powerful tool that empowers Flutter developers to create and work with multi-dimensional arrays. With this package, developers can easily define and manipulate n-dimensional arrays in their applications. This package offers a simple and intuitive interface to handle arrays of various dimensions efficiently.

## Installation

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  n_dimensional_array: ^1.0.1
```

Import it to each file you use it in:

```dart
import 'package:n_dimensional_array/n_dimensional_array.dart';
```

## Usage

### Example 1 - Create multi-dimensional array

This example shows how to create a multi-dimensional array using three different methods.

Note: Each method creates the same end product.

```dart
List myList = [[[1, 2], [3, 4]], [[5, 6], [7, 8]], [[9, 10], [11, 12]]];

// Method 1
NdArray ndArray1 = NdArray.fromList(myList);

// Method 2
NdArray ndArray2 = NdArray(3);

ndArray2.data = myList;

// Method 3
NdArray ndArray3 = NdArray(3);

ndArray3.reshape([3, 2, 2]);

ndArray3[0][0][0] = 1;
ndArray3[0][0][1] = 2;
ndArray3[0][1][0] = 3;
ndArray3[0][1][1] = 4;
ndArray3[1][0][0] = 5;
ndArray3[1][0][1] = 6;
ndArray3[1][1][0] = 7;
ndArray3[1][1][1] = 8;
ndArray3[2][0][0] = 9;
ndArray3[2][0][1] = 10;
ndArray3[2][1][0] = 11;
ndArray3[2][1][1] = 12;
```

### Example 2 - Reshape

Just like with a normal list in Dart, you cannot add elements beyond the length of the list. For a list, you would you the `add()` method. Expanding a multi-dimensional list is a bit more complicated; so, the `reshape` method was created.

```dart
// The list from Example 1
List myList = [[[1, 2], [3, 4]], [[5, 6], [7, 8]], [[9, 10], [11, 12]]];

NdArray ndArray = NdArray.fromList(myList);

// The current shape is [3, 2, 2]
List<int> shape = ndArray.shape;

// Add one more element to the 3rd dimension
ndArray.reshape([3, 2, 3]);

// Note: Since we are only changing the third
// dimension, we could alternatively call:
// ndArray.reshape([-1, -1, 3]);
// The `-1` counts as a placeholder, and the
// original shape value is used.

// The list now looks like:
// [[[1, 2, null], [3, 4, null]], [[5, 6, null], [7, 8, null]], [[9, 10, null], [11, 12, null]]];

// Shrink the array down.
ndArray.reshape([1, 1, 2]);

// The list now looks like:
// [[[1, 2]]]
// Note: The truncated data is lost. Be careful
// when shrinking your arrays. Make sure that is
// really what you want to do.
```

### Example 3 - Getting and Setting values

You can get or set a value very much like a normal list, where you would call `myList[i]`.

```dart
// 2D list is easier to follow
List myList = [[1, 2], [3, 4]];

NdArray ndArray = NdArray.fromList(myList);

// Some current values
int value1 = ndArray[0][1]; // 2
int value2 = ndArray[1][1]; // 4

// Set a value
ndArray[0][1] = 8;

value1 = ndArray[0][1]; // 8

// The list now looks like:
// [[1, 8], [3, 4]]
```

### Example 4 - Copy

When you use the `copy()` method, you create a new `NdArray` that is identical to the original. Any modifications to one does not affect the other.

Note: A non-primitive data types that use references (like custom objects) might not create new versions of themselves when copied. If this is the case, changes to one of those objects will appear in both `NdArray`s.

```dart
// 2D list is easier to follow
List myList = [[1, 2], [3, 4]];

NdArray ndArray = NdArray.fromList(myList);
NdArray ndArrayCopy = ndArray.copy();

// Change only the copy
ndArrayCopy[0][0] = 99;

// The lists now look like:
// ndArray.data == [[1, 2], [3, 4]]
// ndArrayCopy.data == [[99, 2], [3, 4]]
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
