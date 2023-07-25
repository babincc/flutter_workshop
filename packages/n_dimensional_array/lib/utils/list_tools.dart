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

  /// Returns the shape of a list.
  ///
  /// The shape is a list of the number of elements in each dimension.
  static List getShape(List list) {
    List shape = [];

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
