import 'package:example/lists.dart';
import 'package:flutter/material.dart';
import 'package:n_dimensional_array/n_dimensional_array.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
///
/// There is not a good way to visually display the n-dimensional array, so
/// this example is just to show how to use the library.
///
////////////////////////////////////////////////////////////////////////////////

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    NdArray ndArray1d = NdArray.fromList(list1d);
    NdArray ndArray2d = NdArray.fromList(list2d);
    NdArray ndArray3d = NdArray.fromList(list3d);
    NdArray ndArray4d = NdArray.fromList(list4d);

    // Original shape == [4]
    ndArray1d.reshape([5]); // Add a level in the 1st dimension

    // Original shape == [2, 2]
    ndArray2d.reshape([2, 4]); // Add 2 levels in the 2nd dimension

    // Original shape == [2, 2, 2]
    ndArray3d.reshape([-1, -1, -1]); // Don't change the shape

    // Original shape == [4, 2, 2, 2]
    ndArray4d.reshape([2, 2, 2, 2]); // Remove 2 levels in the 1st dimension

    /// A copy of the original 3D array is returned.
    ///
    /// This is useful if you want to keep the original array intact. Any
    /// changes made to the copy will not affect the original array; and vice
    /// versa.
    NdArray ndArray3dCopy = ndArray3d.copy();

    ndArray3d == ndArray3dCopy; // true

    /// The original array is modified.
    ndArray3d[0][0][0] = 100;

    ndArray3d == ndArray3dCopy; // false

    return Scaffold(
      appBar: AppBar(
        title: const Text('n-Dimensional Array Demo'),
      ),
      body: const Center(
        child: Text(
          'Howdy! Check out the ../test/domain/models/nd_array_test.dart file '
          'to really see how to use the n-dimensional array.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
