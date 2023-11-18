import 'package:dart_gov_fbi/constants/api_fields.dart';
import 'package:dart_gov_fbi/utils/equality_tool.dart';

/// Represents a file of a wanted person.
class WantedPersonFile {
  /// Creates a [WantedPersonFile] object.
  const WantedPersonFile({
    this.url,
    this.name,
  });

  /// Creates a [WantedPersonFile] object from a JSON object.
  factory WantedPersonFile.fromJson(Map<String, dynamic> json) {
    return WantedPersonFile(
      url: json[ApiFields.url],
      name: json[ApiFields.name],
    );
  }

  /// Creates an empty [WantedPersonFile] object.
  WantedPersonFile.empty()
      : url = null,
        name = null;

  /// Whether or not this object is empty.
  bool get isEmpty => url == null && name == null;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The url of the file.
  final String? url;

  /// The FBI API doesn't specify what this is, but it appears to be the
  /// language of the file.
  final String? name;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.url: url,
      ApiFields.name: name,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is WantedPersonFile &&
        other.url.equals(url) &&
        other.name.equals(name);
  }

  @override
  int get hashCode => Object.hash(
        url,
        name,
      );

  @override
  String toString() => "Instance of 'WantedPersonFile' ${toJson().toString()}";
}
