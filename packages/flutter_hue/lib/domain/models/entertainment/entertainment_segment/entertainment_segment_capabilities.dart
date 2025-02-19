import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/entertainment/entertainment_segment/entertainment_segment.dart';

/// Represents the capabilities of an entertainment resource segment.
class EntertainmentSegmentCapabilities {
  /// Creates a [EntertainmentSegmentCapabilities] object.
  EntertainmentSegmentCapabilities({
    required this.isConfigurable,
    required this.maxSegments,
    required this.segments,
  }) : assert(maxSegments >= 1, "`maxSegments` must be at least 1");

  /// Creates a [EntertainmentSegmentCapabilities] object from the JSON response
  /// to a GET request.
  factory EntertainmentSegmentCapabilities.fromJson(
      Map<String, dynamic> dataMap) {
    return EntertainmentSegmentCapabilities(
      isConfigurable: dataMap[ApiFields.isConfigurable] ?? false,
      maxSegments: dataMap[ApiFields.maxSegments] ?? 1,
      segments: (dataMap[ApiFields.segments] as List<dynamic>?)
              ?.map((segmentMap) => EntertainmentSegment.fromJson(
                  Map<String, dynamic>.from(segmentMap)))
              .toList() ??
          [],
    );
  }

  /// Creates an empty [EntertainmentSegmentCapabilities] object.
  EntertainmentSegmentCapabilities.empty()
      : isConfigurable = false,
        maxSegments = 1,
        segments = [];

  /// Whether or not the segmentation of the device are configurable.
  final bool isConfigurable;

  /// The maximum number of segments this entertainment resource is capable of
  /// containing.
  final int maxSegments;

  /// Contains the segments configuration of the device for entertainment
  /// purposes.
  ///
  /// A device can be segmented in a single way.
  final List<EntertainmentSegment> segments;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  EntertainmentSegmentCapabilities copyWith({
    bool? isConfigurable,
    int? maxSegments,
    List<EntertainmentSegment>? segments,
  }) {
    return EntertainmentSegmentCapabilities(
      isConfigurable: isConfigurable ?? this.isConfigurable,
      maxSegments: maxSegments ?? this.maxSegments,
      segments: segments ??
          this.segments.map((segment) => segment.copyWith()).toList(),
    );
  }

  /// Converts this object into JSON format.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.isConfigurable: isConfigurable,
      ApiFields.maxSegments: maxSegments,
      ApiFields.segments: segments.map((segment) => segment.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is EntertainmentSegmentCapabilities &&
        other.isConfigurable == isConfigurable &&
        other.maxSegments == maxSegments &&
        const DeepCollectionEquality.unordered()
            .equals(other.segments, segments);
  }

  @override
  int get hashCode => Object.hash(
        isConfigurable,
        maxSegments,
        const DeepCollectionEquality.unordered().hash(segments),
      );

  @override
  String toString() =>
      "Instance of 'EntertainmentSegmentCapabilities' ${toJson().toString()}";
}
