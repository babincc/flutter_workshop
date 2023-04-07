import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// An entertainment configuration channel's member.
class EntertainmentConfigurationChannelMember {
  /// Creates a [EntertainmentConfigurationChannelMember] object.
  EntertainmentConfigurationChannelMember({
    required this.service,
    required this.index,
  });

  /// Creates a [EntertainmentConfigurationChannelMember] object from the JSON
  /// response to a GET request.
  factory EntertainmentConfigurationChannelMember.fromJson(
      Map<String, dynamic> dataMap) {
    return EntertainmentConfigurationChannelMember(
      service: Relative.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.service] ?? {})),
      index: dataMap[ApiFields.index] ?? 0,
    );
  }

  /// Creates an empty [EntertainmentConfigurationChannelMember] object.
  EntertainmentConfigurationChannelMember.empty()
      : service = Relative.empty(),
        index = 0;

  /// The channel member resource.
  final Relative service;

  /// The index of this member.
  final int index;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  EntertainmentConfigurationChannelMember copyWith({
    Relative? service,
    int? index,
    bool copyOriginalValues = true,
  }) {
    return EntertainmentConfigurationChannelMember(
      service: service ??
          this.service.copyWith(copyOriginalValues: copyOriginalValues),
      index: index ?? this.index,
    );
  }

  /// Converts this object into JSON format.
  ///
  /// `optimizeFor` lets the program know what information to include in the
  /// JSON data map.
  /// * [OptimizeFor.put] (the default value) is used when making a data map
  /// that is being placed in a PUT request. This only includes data that has
  /// changed.
  /// * [OptimizeFor.putFull] is used when a parent object updates; so, all of
  /// the children are required to be present for the PUT request.
  /// * [OptimizeFor.post] is used when making a data map for a POST request.
  /// * [OptimizeFor.dontOptimize] is used to get all of the data contained in
  /// this object.
  ///
  /// Throws [InvalidNameException] if `name` does not have a length of 1 - 32
  /// (inclusive), and `optimizeFor` is not set to [OptimizeFor.dontOptimize].
  Map<String, dynamic> toJson({OptimizeFor optimizeFor = OptimizeFor.put}) {
    return {
      ApiFields.service: service.toJson(optimizeFor: optimizeFor),
      ApiFields.index: index,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is EntertainmentConfigurationChannelMember &&
        other.service == service &&
        other.index == index;
  }

  @override
  int get hashCode => Object.hash(service, index);

  @override
  String toString() =>
      "Instance of 'EntertainmentConfigurationChannelMember' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
