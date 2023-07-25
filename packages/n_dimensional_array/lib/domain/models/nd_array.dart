import 'package:collection/collection.dart';
import 'package:n_dimensional_array/utils/list_tools.dart';

class NdArray extends Iterable {
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

  factory NdArray.fromList(List list) {
    int numDimensions = ListTools.countDimensions(list);

    NdArray ndArray = NdArray(numDimensions);

    ndArray._data = list;

    return ndArray;
  }

  /// The number of dimensions in the array.
  final int numDimensions;

  /// The shape of the array.
  ///
  /// The shape is a list of the number of elements in each dimension.
  List get shape => ListTools.getShape(_data);

  /// The data in the array.
  late List _data;

  /// The data in the array.
  ///
  /// When setting to a new value, it will throw an [ArgumentError] if the
  /// number of dimensions in [data] does not match the number of dimensions in
  /// the array it is replacing.
  List get data => _data;
  set data(List data) {
    int numDimensions = ListTools.countDimensions(data);

    if (numDimensions != this.numDimensions) {
      throw ArgumentError('new data must have the same number of dimensions '
          'as the original data\n'
          'Expected: ${this.numDimensions}\n'
          'Actual: $numDimensions');
    }

    _data = data;
  }

  /// Returns the value at [index].
  ///
  /// Throws a [RangeError] if [index] is out of bounds.
  dynamic operator [](int index) {
    try {
      _checkRange(index);
    } on RangeError {
      try {
        _checkRange(index - 1);
      } catch (e) {
        throw RangeError(
            'index $index out of bounds for range 0..${_data.length}');
      }

      _data.add(List<dynamic>.filled(1, null, growable: true));

      for (int i = 1; i < numDimensions; i++) {
        _data.last = [_data.last];
      }
    }

    if (numDimensions == 1) {
      return _data[index];
    }

    NdArray ndArray = NdArray(numDimensions - 1);

    ndArray._data = _data[index];

    return ndArray;
  }

  /// Sets the value at [index] to [value].
  ///
  /// Throws a [RangeError] if [index] is out of bounds.
  void operator []=(int index, dynamic value) {
    try {
      _checkRange(index);
    } on RangeError {
      _data.add(value);
      return;
    }

    _data[index] = value;
  }

  /// Throws a [RangeError] if [index] is out of bounds.
  void _checkRange(int index) {
    if (index < 0 || index >= _data.length) {
      throw RangeError(
          'index $index out of bounds for range 0..${_data.length}');
    }
  }

  /// Returns a copy of this array.
  ///
  /// The copy is a deep copy.
  NdArray copy() {
    List copy = _copy(_data);

    return NdArray(numDimensions).._data = copy;
  }

  /// Returns a copy of [iterable].
  List _copy(List iterable) {
    List copy = [];

    for (var element in iterable) {
      if (element is Iterable) {
        copy.add(_copy(element as List));
      } else {
        copy.add(element);
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

    return const DeepCollectionEquality().equals(other._data, _data);
  }

  @override
  int get hashCode {
    return const DeepCollectionEquality().hash(_data);
  }

  @override
  Iterator get iterator => _data.iterator;

  @override
  String toString() {
    return _data.toString();
  }
}
