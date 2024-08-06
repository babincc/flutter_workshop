import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_skeleton/utils/my_file_explorer/my_file_explorer.dart';
import 'package:provider/provider.dart';

class MyFileExplorerProvider extends ChangeNotifier {
  /// Creates a new [MyFileExplorerProvider].
  ///
  /// PRO TIP: Call and `await` [ensureInitialized] before using this provider.
  MyFileExplorerProvider();

  /// Makes sure that the provider is initialized.
  ///
  /// Throws a [FileSystemException] if the instance is not initialized in time.
  Future<void> ensureInitialized() async {
    await myFileExplorer.ensureInitialized();
  }

  /// The file explorer.
  MyFileExplorer myFileExplorer = MyFileExplorer();

  static MyFileExplorerProvider of(BuildContext context,
          {bool listen = false}) =>
      Provider.of<MyFileExplorerProvider>(context, listen: listen);
}
