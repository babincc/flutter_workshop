import 'package:collection/collection.dart';
import 'package:n_dimensional_array/utils/list_tools.dart';

/// A multi-dimensional array.
class NdArray extends Iterable {
  /// Creates an array with `numDimensions` dimensions.
  NdArray(this.numDimensions) {
    if (numDimensions < 1) {
      throw ArgumentError('numDimensions must be greater than 0\n'
          'Actual: $numDimensions');
    }

    _data = List<dynamic>.filled(1, null, growable: true);

    for (int i = 1; i < numDimensions; i++) {
      _data = [_data];
    }
  }

  /// Creates an array from `list`.
  factory NdArray.fromList(List list) {
    final int numDimensions = ListTools.countDimensions(list);

    NdArray ndArray = NdArray(numDimensions);

    ndArray._data = list;

    // Makes the lists growable.
    ndArray = ndArray.copy();

    return ndArray;
  }

  /// The number of dimensions in the array.
  final int numDimensions;

  /// The shape of the array.
  ///
  /// The shape is a list of the number of elements in each dimension.
  List<int> get shape => ListTools.getShape(_data);

  /// The data in the array.
  late List<dynamic> _data;

  /// The data in the array.
  ///
  /// When setting to a new value, it will throw an [ArgumentError] if the
  /// number of dimensions in `data` does not match the number of dimensions in
  /// the array it is replacing.
  List<dynamic> get data => _data;
  set data(List<dynamic> data) {
    final int numDimensions = ListTools.countDimensions(data);

    if (numDimensions != this.numDimensions) {
      throw ArgumentError('new data must have the same number of dimensions '
          'as the original data\n'
          'Expected: ${this.numDimensions}\n'
          'Actual: $numDimensions');
    }

    _data = data;
  }

  /// Returns the value at `index`.
  ///
  /// Throws a [RangeError] if `index` is out of bounds.
  dynamic operator [](int index) {
    _checkRange(index);

    if (numDimensions == 1) {
      return _data[index];
    }

    final NdArray ndArray = NdArray(numDimensions - 1);

    if (_data[index] is List) {
      ndArray._data = _data[index];
    } else {
      ndArray._data = [_data[index]];
    }

    return ndArray;
  }

  /// Sets the value at `index` to `value`.
  ///
  /// Throws a [RangeError] if `index` is out of bounds.
  void operator []=(int index, dynamic value) {
    _checkRange(index);

    if (numDimensions != 1) {
      int? valueNumDimensions;

      if (value is NdArray) {
        valueNumDimensions = value.numDimensions;
      } else if (value is List) {
        valueNumDimensions = ListTools.countDimensions(value);
      }

      if (valueNumDimensions == null || valueNumDimensions != numDimensions) {
        throw ArgumentError('value must have the same number of dimensions as '
            'the original array\n'
            'Expected: ${numDimensions - 1}\n'
            'Actual: $valueNumDimensions');
      }
    }

    _data[index] = value;
  }

  /// Throws a [RangeError] if `index` is out of bounds.
  void _checkRange(int index) {
    if (index < 0 || index >= _data.length) {
      throw RangeError(
          'index $index out of bounds for range 0..${_data.length - 1}');
    }
  }

  /// Reshapes the array to `shape`.
  ///
  /// Note: If you want the number of elements in the new shape to be the same
  /// as the number of elements in the original array, then you can use `-1` as
  /// a placeholder for the number of elements in the new shape.
  ///
  /// For example, if you have a 2x2 array, then you can reshape it to a 2x3
  /// array by doing:
  ///
  /// ```dart
  /// reshape([-1, 3]);
  /// ```
  ///
  /// Warning: If the number of elements in the new shape is less than the
  /// number of elements in the original array, then the extra elements will be
  /// lost.
  ///
  /// If the number of elements in the new shape is greater than the number of
  /// elements in the original array, then the extra elements will be filled
  /// with `null`.
  ///
  /// Throws an [ArgumentError] if the length of `shape` does not match the
  /// number of dimensions in the array.
  ///
  /// Throws an [ArgumentError] if `shape` contains any negative integers other
  /// than `-1` or if it contains 0.
  void reshape(List<int> shape) {
    // Check that shape has the same number of dimensions as the array.
    if (shape.length != numDimensions) {
      throw ArgumentError('shape must have the same number of dimensions as '
          'the original array\n'
          'Expected: $numDimensions\n'
          'Actual: ${shape.length}');
    }

    // Check that shape only contains positive integers.
    for (int element in shape) {
      if (element < 1 && element != -1) {
        throw ArgumentError('shape must only contain positive integers\n'
            'Actual: $shape');
      }
    }

    /// The shape of the array before reshaping.
    final List<int> currentShape = ListTools.getShape(_data);

    // Replace -1 with the correct value.
    for (int i = 0; i < shape.length; i++) {
      if (shape[i] == -1) {
        shape[i] = currentShape[i];
      }
    }

    // If the shape is the same, then do nothing.
    if (const DeepCollectionEquality().equals(currentShape, shape)) return;

    // Go through each dimension and add or remove elements as needed.
    for (int i = 0; i < shape.length; i++) {
      // If the shape is the same, then do nothing.
      if (shape[i] == currentShape[i]) continue;

      /// The chunks of the array at the current dimension.
      late List<NdArray> chunks;
      try {
        chunks = extractDimension(i);
      } catch (e) {
        chunks = [this];
      }

      /// The desired length of the current chunks.
      final int desiredLength = shape[i];

      for (NdArray chunk in chunks) {
        // The actual length of the current chunk.
        int actualLength = chunk.shape.first;

        if (actualLength < desiredLength) {
          // Grow the chunk.
          while (actualLength < desiredLength) {
            // Build the injection.
            dynamic injection;
            for (int k = 0; k < numDimensions - (i + 1); k++) {
              injection = [injection];
            }

            if (injection == null) {
              chunk._data.add(null);
            } else {
              chunk._data.add(List<dynamic>.from(injection, growable: true));
            }

            actualLength++;
          }
        } else {
          // Shrink the chunk.
          chunk._data.length = desiredLength;
        }
      }
    }
  }

  /// Returns a list of each chunk at the given `dimension`.
  ///
  /// This **does not** affect the original array.
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
  List<NdArray> extractDimension(int dimension) =>
      ListTools.extractDimension(dimension: dimension, list: _data);

  /// Returns a copy of this array.
  ///
  /// The copy is a deep copy. This means you are creating a new [NdArray] that is
  /// identical to `this` one. Any modifications to one does not affect the
  /// other.
  ///
  /// Note: A non-primitive data types that use references (like custom objects)
  /// might not create new versions of themselves when copied. If this is the
  /// case, changes to one of those objects will appear in both [NdArray]s.
  NdArray copy() {
    final List<dynamic> copy = _copy(_data);

    return NdArray(numDimensions).._data = copy;
  }

  /// Returns a copy of `iterable`.
  List<dynamic> _copy(List iterable) {
    final List<dynamic> copy = List<dynamic>.filled(0, null, growable: true);

    for (var element in iterable) {
      if (element is Iterable) {
        copy.add(_copy(element as List<dynamic>));
      } else {
        dynamic elementCopy;

        // Try to copy deepest elements so they are not references.
        try {
          elementCopy = element.deepCopy();
        } catch (e) {
          try {
            elementCopy = element.deepcopy();
          } catch (e) {
            try {
              elementCopy = element.copy();
            } catch (e) {
              try {
                elementCopy = element.copyWith();
              } catch (e) {
                try {
                  elementCopy = element.clone();
                } catch (e) {
                  try {
                    elementCopy = element.cloneWith();
                  } catch (e) {
                    try {
                      elementCopy = element.duplicate();
                    } catch (e) {
                      elementCopy = element;
                    }
                  }
                }
              }
            }
          }
        }

        copy.add(elementCopy);
      }
    }

    return copy;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    if (other is! NdArray) return false;

    if (numDimensions != other.numDimensions) return false;

    return const DeepCollectionEquality().equals(other.shape, shape) &&
        const DeepCollectionEquality().equals(other._data, _data);
  }

  @override
  int get hashCode {
    return const DeepCollectionEquality().hash(_data);
  }

  @override
  Iterator get iterator => _data.iterator;

  @override
  String toString() {
    return "Num Dimensions: $numDimensions\n"
        "Shape: $shape\n"
        "Data: ${_data.toString()}";
  }
}
