import 'package:dart_gov_fbi/constants/api_fields.dart';
import 'package:dart_gov_fbi/utils/equality_tool.dart';

/// Represents image data for an FBI case.
class FbiImage {
  /// Creates an [FbiImage] object.
  const FbiImage({
    this.originalUrl,
    this.thumbUrl,
    this.largeUrl,
    this.caption,
  });

  /// Creates a [FbiImage] object from a JSON object.
  factory FbiImage.fromJson(Map<String, dynamic> json) {
    return FbiImage(
      originalUrl: json[ApiFields.originalUrl],
      thumbUrl: json[ApiFields.thumbUrl],
      largeUrl: json[ApiFields.largeUrl],
      caption: json[ApiFields.caption],
    );
  }

  /// Creates an empty [FbiImage] object.
  FbiImage.empty()
      : originalUrl = null,
        thumbUrl = null,
        largeUrl = null,
        caption = null;

  /// Whether or not this object is empty.
  bool get isEmpty =>
      originalUrl == null &&
      thumbUrl == null &&
      largeUrl == null &&
      caption == null;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The URL of the original image.
  final String? originalUrl;

  /// The URL of the thumbnail image.
  final String? thumbUrl;

  /// The URL of the large image.
  final String? largeUrl;

  /// A caption for the image.
  final String? caption;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.originalUrl: originalUrl,
      ApiFields.thumbUrl: thumbUrl,
      ApiFields.largeUrl: largeUrl,
      ApiFields.caption: caption,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is FbiImage &&
        other.originalUrl.equals(originalUrl) &&
        other.thumbUrl.equals(thumbUrl) &&
        other.largeUrl.equals(largeUrl) &&
        other.caption.equals(caption);
  }

  @override
  int get hashCode => Object.hash(
        originalUrl,
        thumbUrl,
        largeUrl,
        caption,
      );

  @override
  String toString() => "Instance of 'FbiImage' ${toJson().toString()}";
}
