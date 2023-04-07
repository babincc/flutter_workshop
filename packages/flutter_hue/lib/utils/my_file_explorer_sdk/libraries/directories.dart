// @author Christian Babin
// @version 1.0.2
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_file_explorer_sdk.dart

import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// {@template myFileExplorerSdk.directories.appDocsDir}
/// The docs directory of this app.
/// {@endtemplate}
Future<Directory> get appDocsDir async =>
    await getApplicationDocumentsDirectory();

/// {@template myFileExplorerSdk.directories.appSupportDir}
/// The files directory of this app.
/// {@endtemplate}
Future<Directory> get appSupportDir async =>
    await getApplicationSupportDirectory();

/// {@template myFileExplorerSdk.directories.tempDir}
/// The temporary directory of this app.
/// {@endtemplate}
Future<Directory> get tempDir async => await getTemporaryDirectory();
