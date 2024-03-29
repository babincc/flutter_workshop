import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_skeleton/firebase_options.dart';
import 'package:my_skeleton/my_app.dart';

Future<void> main() async {
  // Start up Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
