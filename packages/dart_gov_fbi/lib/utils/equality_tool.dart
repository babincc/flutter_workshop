import 'package:collection/collection.dart';

extension EqualityTool on Object? {
  bool equals(Object? other) {
    return ((other == null && this == null) ||
        ((other != null && this != null) && (other == this)));
  }

  bool listEquals(Object? other) {
    return ((other == null && this == null) ||
        ((other != null && this != null) &&
            (const DeepCollectionEquality.unordered().equals(other, this))));
  }
}
