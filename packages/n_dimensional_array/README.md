# n-Dimensional Array

The n-Dimensional Array package is a powerful tool that empowers Flutter developers to create and work with multi-dimensional arrays. With this package, developers can easily define and manipulate n-dimensional arrays in their applications. This package offers a simple and intuitive interface to handle arrays of various dimensions efficiently.

## Installation

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  n_dimensional_array: ^0.1.0
```

Import it to each file you use it in:

```dart
import 'package:n_dimensional_array/n_dimensional_array.dart';
```

## Usage

### Example 1 - Create multi-dimensional array

This example shows how to create a multi-dimensional array using two different methods.

Note: Each method creates the same end product.

```dart
// Method 1
List myList = [[[1, 2], [3, 4]], [[5, 6], [7, 8]], [[9, 10], [11, 12]]];

NdArray ndArray1 = NdArray.fromList(myList);

// Method 2
NdArray ndArray2 = NdArray(3);

ndArray2.reshape([3, 2, 2]);

ndArray2[0][0][0] = 1;
ndArray2[0][0][1] = 2;
ndArray2[0][1][0] = 3;
ndArray2[0][1][1] = 4;
ndArray2[1][0][0] = 5;
ndArray2[1][0][1] = 6;
ndArray2[1][1][0] = 7;
ndArray2[1][1][1] = 8;
ndArray2[2][0][0] = 9;
ndArray2[2][0][1] = 10;
ndArray2[2][1][0] = 11;
ndArray2[2][1][1] = 12;
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
