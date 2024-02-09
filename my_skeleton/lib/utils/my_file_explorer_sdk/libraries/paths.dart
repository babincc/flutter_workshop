// @author Christian Babin
// @version 1.0.1
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_file_explorer_sdk.dart

// ignore_for_file: always_use_package_imports
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
    '${await appSupportPath}${Platform.pathSeparator}avatars';
