import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/progress_repository.dart';
import 'screens/level5_gate.dart';
import 'ui/nexus_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Juego para celular en horizontal y a pantalla completa.
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const Nexus9App());
}

class Nexus9App extends StatelessWidget {
  const Nexus9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEXUS-9',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBg,
        fontFamily: 'monospace',
      ),
      // HU-001: la puerta de entrada al Nivel 5 revisa el progreso.
      home: Level5Gate(repository: LocalProgressRepository()),
    );
  }
}
