import 'package:n_dimensional_array/n_dimensional_array.dart';

class ListTools {
  /// Returns the number of dimensions in a list.
  ///
  /// For example, a 1D list returns 1, a 2D list returns 2, etc.
  ///
  /// * [1, 2, 3] returns 1
  /// * [[1, 2], [3, 4]] returns 2
  static int countDimensions(List list) {
    int numDimensions = 0;

    bool reachedEnd = false;
    List nestedList = list;
    while (!reachedEnd) {
      numDimensions++;

      if (nestedList.isNotEmpty && nestedList[0] is List) {
        nestedList = nestedList[0];
      } else {
        reachedEnd = true;
      }
    }

    return numDimensions;
  }

  /// Returns a list of each chunk at the given `dimension`.
  ///
  /// The array `[[[1, 2], [3, 4]], [[5, 6], [7, 8]]]` creates a 2x2 cube.
  ///
  /// ```dart
  /// extractDimension(dimension: 1);
  /// ```
  ///
  /// The above example returns two 2x2 planes:
  /// * `[[1, 2], [3, 4]]`
  /// * `[[5, 6], [7, 8]]`
  ///
  /// Note: The returned list is a list of [NdArray]s.
  static List<NdArray> extractDimension(
      {required int dimension, required List<dynamic> list}) {
    int numDimensions = countDimensions(list);

    if (dimension <= 0 || dimension > numDimensions) {
      throw ArgumentError('dimension must be between 0 and $numDimensions\n'
          'Actual: $dimension');
    }

    return _extractDimension(dimension, list, 1);
  }

  /// Recursive helper function for [extractDimension].
  static List<NdArray> _extractDimension(
      int dimension, List<dynamic> list, int currentDimension) {
    List<NdArray> extractedDimension = [];

    for (var element in list) {
      if (dimension == currentDimension) {
        if (element is List) {
          int elementDimensions = countDimensions(element);
          NdArray ndArray = NdArray(elementDimensions);
          ndArray.data = element;

          extractedDimension.add(ndArray);
        } else {
          NdArray ndArray = NdArray(1);
          ndArray.data = [element];

          extractedDimension.add(ndArray);
        }
      } else {
        if (element is List) {
          extractedDimension.addAll(
              _extractDimension(dimension, element, currentDimension + 1));
        } else {
          extractedDimension.addAll(
              _extractDimension(dimension, [element], currentDimension + 1));
        }
      }
    }

    return extractedDimension;
  }

  /// Returns the shape of a list.
  ///
  /// The shape is a list of the number of elements in each dimension.
  static List<int> getShape(List list) {
    List<int> shape = [];

    bool reachedEnd = false;
    List nestedList = list;
    while (!reachedEnd) {
      shape.add(nestedList.length);

      if (nestedList.isNotEmpty && nestedList[0] is List) {
        nestedList = nestedList[0];
      } else {
        reachedEnd = true;
      }
    }

    return shape;
  }
}
