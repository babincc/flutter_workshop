import 'package:collection/collection.dart';
import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_channel/entertainment_configuration_channel_member.dart';
import 'package:flutter_hue/domain/models/entertainment_configuration/entertainment_configuration_position.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// An entertainment configuration's channel.
class EntertainmentConfigurationChannel {
  /// Creates a [EntertainmentConfigurationChannel] object.
  EntertainmentConfigurationChannel({
    required this.channelId,
    required this.position,
    required this.members,
  }) : assert(channelId >= 0 && channelId <= 255,
            "`channelId` must be between 0 and 255 (inclusive)");

  /// Creates a [EntertainmentConfigurationChannel] object from the JSON
  /// response to a GET request.
  factory EntertainmentConfigurationChannel.fromJson(
      Map<String, dynamic> dataMap) {
    return EntertainmentConfigurationChannel(
      channelId: dataMap[ApiFields.channelId] ?? 0,
      position: EntertainmentConfigurationPosition.fromJson(
          Map<String, dynamic>.from(dataMap[ApiFields.position] ?? {})),
      members: (dataMap[ApiFields.members] as List<dynamic>?)
              ?.map((memberMap) =>
                  EntertainmentConfigurationChannelMember.fromJson(
                      Map<String, dynamic>.from(memberMap)))
              .toList() ??
          [],
    );
  }

  /// Creates an empty [EntertainmentConfigurationChannel] object.
  EntertainmentConfigurationChannel.empty()
      : channelId = 0,
        position = EntertainmentConfigurationPosition.empty(),
        members = [];

  /// Bridge assigns a number upon creation.
  ///
  /// This is the number to be used by the HueStream API when addressing the
  /// channel.
  final int channelId;

  /// xyz position of this channel. It is the average position of its members.
  final EntertainmentConfigurationPosition position;

  /// List that references segments that are members of this channel.
  final List<EntertainmentConfigurationChannelMember> members;

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  EntertainmentConfigurationChannel copyWith({
    int? channelId,
    EntertainmentConfigurationPosition? position,
    List<EntertainmentConfigurationChannelMember>? members,
    bool copyOriginalValues = true,
  }) {
    return EntertainmentConfigurationChannel(
      channelId: channelId ?? this.channelId,
      position: position ??
          this.position.copyWith(copyOriginalValues: copyOriginalValues),
      members: members ??
          this
              .members
              .map((member) =>
                  member.copyWith(copyOriginalValues: copyOriginalValues))
              .toList(),
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
      ApiFields.channelId: channelId,
      ApiFields.position: position.toJson(),
      ApiFields.members: members
          .map((member) => member.toJson(
              optimizeFor: identical(optimizeFor, OptimizeFor.dontOptimize)
                  ? optimizeFor
                  : OptimizeFor.putFull))
          .toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is EntertainmentConfigurationChannel &&
        other.channelId == channelId &&
        other.position == position &&
        const DeepCollectionEquality.unordered().equals(other.members, members);
  }

  @override
  int get hashCode => Object.hash(
        channelId,
        position,
        Object.hashAllUnordered(members),
      );

  @override
  String toString() =>
      "Instance of 'EntertainmentConfigurationChannel' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
