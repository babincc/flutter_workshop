import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/rail_station_info/domain/models/path/path_item.dart';

class Path {
  /// Creates a new [Path] instance.
  Path({
    required this.items,
  })  : numStops = items.length,
        intPathLengthFeet = items.fold<int>(
          0,
          (previousValue, item) => previousValue + item.distanceToPrevFeet,
        ) {
    items.sort();
  }

  /// Creates a new [Path] instance from a JSON object.
  factory Path.fromJson(Map<String, dynamic> json) {
    return Path(
      items: ((json[ApiFields.path] as List?) ?? [])
          .map((shapePoint) => PathItem.fromJson(shapePoint))
          .toList(),
    );
  }

  /// Creates an empty [Path] instance.
  factory Path.empty() => Path(items: const []);

  /// Whether or not this [Path] is empty.
  bool get isEmpty => items.isEmpty;

  /// Whether or not this [Path] is not empty.
  bool get isNotEmpty => items.isNotEmpty;

  /// The path items that make up this path.
  final List<PathItem> items;

  /// The number of stops in this path.
  ///
  /// This includes the start and end stations.
  final int numStops;

  /// The length of the path in feet.
  final int intPathLengthFeet;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() => {
        ApiFields.path: items.map((item) => item.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Path &&
        const DeepCollectionEquality.unordered().equals(other.items, items);
  }

  @override
  int get hashCode => Object.hashAllUnordered(items);

  @override
  String toString() => "Instance of 'Path' ${toJson().toString()}";
}
