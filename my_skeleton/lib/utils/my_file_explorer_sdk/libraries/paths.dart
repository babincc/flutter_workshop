import 'dart:io';

import 'directories.dart';

/// The path to [appDocsDir].
Future<String> get appDocsPath async => (await appDocsDir).path;

/// The path to [appSupportDir].
Future<String> get appSupportPath async => (await appSupportDir).path;

/// The path to [tempDir].
Future<String> get tempPath async => (await tempDir).path;

/// The path to the avatar images.
Future<String> get avatarsPath async =>
    "${await appSupportPath}${Platform.pathSeparator}avatars";
