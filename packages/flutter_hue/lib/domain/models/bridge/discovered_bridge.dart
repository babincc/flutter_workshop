/// A class that represents a bridge that has been discovered but not yet
/// connected to the app.
class DiscoveredBridge {
  /// Creates a new [DiscoveredBridge] instance.
  DiscoveredBridge({
    this.rawIdFromEndpoint,
    this.rawIdFromMdns,
    required this.ipAddress,
  });

  /// Creates a new [DiscoveredBridge] instance when using the endpoint bridge
  /// discovery method.
  DiscoveredBridge.fromEndpoint({
    required this.rawIdFromEndpoint,
    required this.ipAddress,
  });

  /// Creates a new [DiscoveredBridge] instance when using the mDNS bridge
  /// discovery method.
  DiscoveredBridge.fromMdns({
    required this.rawIdFromMdns,
    required this.ipAddress,
  });

  /// Creates an empty [DiscoveredBridge] instance.
  DiscoveredBridge.empty() : ipAddress = "";

  /// Whether or not this user object is empty.
  bool get isEmpty =>
      rawIdFromEndpoint == null && rawIdFromMdns == null && ipAddress.isEmpty;

  /// Whether or not this user object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// This should be the full ID of the bridge.
  ///
  /// This is found using the endpoint bridge discovery method.
  String? rawIdFromEndpoint;

  /// This is still a partial ID for the bridge; however, id does contain more
  /// data than [id].
  ///
  /// This is found using the mDNS bridge discovery method.
  String? rawIdFromMdns;

  /// This is a partial ID of the bridge.
  ///
  /// Since the bridge is not yet connected to the app, the full ID is not
  /// known.
  ///
  /// Returns `null` if the ID is not known.
  String? get id {
    if (rawIdFromEndpoint != null) {
      return rawIdFromEndpoint!.substring(rawIdFromEndpoint!.length - 6);
    }

    if (rawIdFromMdns != null) {
      return rawIdFromMdns!.substring(rawIdFromMdns!.length - 6);
    }

    return null;
  }

  /// The IP address of the bridge.
  final String ipAddress;

  /// Returns a copy of this object.
  DiscoveredBridge copy() => copyWith();

  /// Used in the [copyWith] method to check if nullable values are meant to be
  /// copied over.
  static const sentinelValue = Object();

  /// Returns a copy of this object with its field values replaced by the ones
  /// provided to this method.
  ///
  /// Since [rawIdFromEndpoint] and [rawIdFromMdns] are nullable, they are
  /// defaulted to empty objects in this method. If left as empty objects, their
  /// current values in this [DiscoveredBridge] object will be used. This way,
  /// if they are `null`, the program will know that they are intentionally
  /// being set to `null`.
  DiscoveredBridge copyWith({
    Object? rawIdFromEndpoint = sentinelValue,
    Object? rawIdFromMdns = sentinelValue,
    String? ipAddress,
  }) {
    if (!identical(rawIdFromEndpoint, sentinelValue)) {
      assert(
        rawIdFromEndpoint is String?,
        "`rawIdFromEndpoint` must be an `String?` object",
      );
    }
    if (!identical(rawIdFromMdns, sentinelValue)) {
      assert(
        rawIdFromMdns is String?,
        "`rawIdFromMdns` must be an `String?` object",
      );
    }

    return DiscoveredBridge(
      rawIdFromEndpoint: identical(rawIdFromEndpoint, sentinelValue)
          ? this.rawIdFromEndpoint
          : rawIdFromEndpoint as String?,
      rawIdFromMdns: identical(rawIdFromMdns, sentinelValue)
          ? this.rawIdFromMdns
          : rawIdFromMdns as String?,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is DiscoveredBridge &&
        ((other.rawIdFromEndpoint == null && rawIdFromEndpoint == null) ||
            ((other.rawIdFromEndpoint != null && rawIdFromEndpoint != null) &&
                identical(other.rawIdFromEndpoint, rawIdFromEndpoint))) &&
        ((other.rawIdFromMdns == null && rawIdFromMdns == null) ||
            ((other.rawIdFromMdns != null && rawIdFromMdns != null) &&
                identical(other.rawIdFromMdns, rawIdFromMdns))) &&
        other.ipAddress == ipAddress;
  }

  @override
  int get hashCode => Object.hash(
        rawIdFromEndpoint,
        rawIdFromMdns,
        ipAddress,
      );

  @override
  String toString() => 'Instance of DiscoveredBridge: {rawIdFromEndpoint: '
      '$rawIdFromEndpoint, rawIdFromMdns: $rawIdFromMdns, id: $id, ipAddress: '
      '$ipAddress}';
}
