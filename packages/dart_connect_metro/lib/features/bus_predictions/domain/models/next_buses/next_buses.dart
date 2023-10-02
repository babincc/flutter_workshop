import 'package:collection/collection.dart';
import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/bus_predictions/domain/models/next_buses/prediction.dart';

/// Contains a set of predictions for the next buses at a stop.
class NextBuses {
  /// Creates a new [NextBuses] instance.
  const NextBuses({
    required this.stopName,
    required this.predictions,
  });

  /// Creates a new [NextBuses] instance from a JSON object.
  factory NextBuses.fromJson(Map<String, dynamic> json) {
    return NextBuses(
      stopName: json[ApiFields.stopName] ?? '',
      predictions: ((json[ApiFields.predictions] as List?) ?? [])
          .map((prediction) => Prediction.fromJson(prediction))
          .toList(),
    );
  }

  /// Creates an empty [NextBuses] instance.
  const NextBuses.empty()
      : stopName = '',
        predictions = const [];

  /// Whether or not this [NextBuses] is empty.
  bool get isEmpty => stopName.isEmpty && predictions.isEmpty;

  /// Whether or not this [NextBuses] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Full name of the bus stop.
  final String stopName;

  /// List of [Prediction]s for the next buses.
  final List<Prediction> predictions;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.stopName: stopName,
      ApiFields.predictions:
          predictions.map((prediction) => prediction.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is NextBuses &&
        other.stopName == stopName &&
        const DeepCollectionEquality.unordered()
            .equals(other.predictions, predictions);
  }

  @override
  int get hashCode => Object.hash(
        stopName,
        Object.hashAllUnordered(predictions),
      );

  @override
  String toString() => "Instance of 'NextBuses' ${toJson().toString()}";
}
