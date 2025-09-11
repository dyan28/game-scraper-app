import 'package:flutter/material.dart';
import 'package:tap_two_play/env/env_state.dart';
import 'package:tap_two_play/main/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupAndRunApp(env: EnvValue.production);
}
