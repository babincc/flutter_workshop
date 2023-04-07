import 'package:flutter_hue/constants/api_fields.dart';
import 'package:flutter_hue/domain/models/relative.dart';
import 'package:flutter_hue/exceptions/invalid_name_exception.dart';
import 'package:flutter_hue/utils/json_tool.dart';

/// An entertainment configuration's stream proxy.
class EntertainmentConfigurationStreamProxy {
  /// Creates a [EntertainmentConfigurationStreamProxy] object.
  EntertainmentConfigurationStreamProxy({
    required this.mode,
    required this.node,
  });

  /// Creates a [EntertainmentConfigurationStreamProxy] object from the JSON
  /// response to a GET request.
  factory EntertainmentConfigurationStreamProxy.fromJson(
      Map<String, dynamic> dataMap) {
    return EntertainmentConfigurationStreamProxy(
        mode: dataMap[ApiFields.mode] ?? "",
        node: Relative.fromJson(
            Map<String, dynamic>.from(dataMap[ApiFields.node] ?? {})));
  }

  /// Creates an empty [EntertainmentConfigurationStreamProxy] object.
  EntertainmentConfigurationStreamProxy.empty()
      : mode = "",
        node = Relative.empty();

  /// Proxy mode used for this group.
  ///
  /// * auto – The bridge will select a proxy node automatically.
  /// * manual – The proxy node has been set manually.
  final String mode;

  /// Reference to the device acting as proxy The proxy node relays the
  /// entertainment traffic and should be located in or close to all
  /// entertainment lamps in this group.
  ///
  /// The proxy node set by the application (manual) resp selected by the bridge
  /// (auto). Writing sets proxy mode to "manual". Is not allowed to be combined
  /// with attribute "mode":"auto".
  ///
  /// Can be type BridgeDevice or ZigbeeDevice.
  final Relative node;

  /// Called after a successful PUT request, this method refreshed the
  /// "original" data in this object.
  ///
  /// This way, on the next PUT request, the program will know what data is
  /// actually new.
  void refreshOriginals() {
    node.refreshOriginals();
  }

  /// Returns a copy of this object with its field values replaced by the
  /// ones provided to this method.
  ///
  /// `copyOriginalValues` is true if you want to maintain the original object's
  /// initial values. This is useful if you plan on using this object in a PUT
  /// request.
  EntertainmentConfigurationStreamProxy copyWith({
    String? mode,
    Relative? node,
    bool copyOriginalValues = true,
  }) {
    return EntertainmentConfigurationStreamProxy(
      mode: mode ?? this.mode,
      node: node ?? this.node.copyWith(copyOriginalValues: copyOriginalValues),
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
      ApiFields.mode: mode,
      ApiFields.node: node.toJson(optimizeFor: optimizeFor),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is EntertainmentConfigurationStreamProxy &&
        other.mode == mode &&
        other.node == node;
  }

  @override
  int get hashCode => Object.hash(mode, node);

  @override
  String toString() =>
      "Instance of 'EntertainmentConfigurationStreamProxy' ${toJson(optimizeFor: OptimizeFor.dontOptimize).toString()}";
}
