import 'package:dtls2/dtls2.dart';

/// DTLS client and connection information.
class DtlsData {
  /// The DTLS client for the connection.
  ///
  /// That would be the user's device that is sending commands to the bridge.
  DtlsClient? dtlsClient;

  /// The DTLS connection between the client and the bridge.
  ///
  /// This is used to stream data to the bridge.
  DtlsConnection? connection;

  /// Whether or not the connection is ready to be used for streaming.
  bool get isReady =>
      connection != null && !connection!.closed && connection!.connected;

  /// If the [dtlsClient] is not `null`, this method will close it.
  ///
  /// If the [dtlsClient] is `null`, there is nothing that can be done anyway;
  /// so, do nothing here.
  Future<void> tryCloseClient() async {
    if (dtlsClient == null) return;

    await dtlsClient!.close();

    dtlsClient = null;
  }

  /// If the [connection] is not `null`, this method will close it.
  ///
  /// If the [connection] is `null`, there is nothing that can be done anyway;
  /// so, do nothing here.
  Future<void> tryDisconnect() async {
    if (connection == null) return;

    await connection!.close();

    connection = null;
  }

  /// Closes the [dtlsClient] and disconnects the [connection].
  ///
  /// This is a convenience method that calls [tryCloseClient] and
  /// [tryDisconnect] in sequence.
  ///
  /// If the [dtlsClient] is `null` or the [connection] is `null`, they will be
  /// ignored.
  Future<void> tryDispose() async {
    await tryDisconnect();
    await tryCloseClient();
  }
}
