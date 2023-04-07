// @author Christian Babin
// @version 1.0.2
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_file_explorer_sdk.dart

// ignore_for_file: always_use_package_imports
import 'directories.dart';

/// The path to [appDocsDir].
Future<String> get appDocsPath async => (await appDocsDir).path;

/// The path to [appSupportDir].
Future<String> get appSupportPath async => (await appSupportDir).path;

/// The path to [tempDir].
Future<String> get tempPath async => (await tempDir).path;
