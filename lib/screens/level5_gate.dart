import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import '../core/progress_repository.dart';
import '../ui/nexus_ui.dart';
import 'level5_screen.dart';

/// HU-001 · Acceso al Nivel 5.
/// - Nivel 4 completado  -> muestra la pantalla principal del Nivel 5.
/// - Nivel 4 sin completar -> el Nivel 5 permanece bloqueado.
/// - Error al leer el progreso -> mensaje de error (sin estado incompleto).
class Level5Gate extends StatefulWidget {
  const Level5Gate({super.key, required this.repository});
  final ProgressRepository repository;

  @override
  State<Level5Gate> createState() => _Level5GateState();
}

class _Level5GateState extends State<Level5Gate> {
  late Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<bool> _load() =>
      widget.repository.isLevelCompleted(4).timeout(const Duration(seconds: 8));

  void _retry() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator(color: kCyan));
          }
          if (snap.hasError) {
            return ErrorView(
              message: 'No se pudo comprobar tu progreso.\nRevisa tu conexion e intenta de nuevo.',
              onRetry: _retry,
            );
          }
          if (snap.data == true) return const Level5Screen();
          return _Locked(
            onSimulate: kDebugMode
                ? () async {
                    await widget.repository.setLevelCompleted(4, true);
                    _retry();
                  }
                : null,
          );
        },
      ),
    );
  }
}

class _Locked extends StatelessWidget {
  const _Locked({this.onSimulate});
  final VoidCallback? onSimulate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: NexusPanel(
        color: kRed,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.lock, color: kRed, size: 40),
          const SizedBox(height: 8),
          const Text('NIVEL 5 — EL NÚCLEO',
              style: TextStyle(color: kCyan, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('BLOQUEADO\nCompleta el Nivel 4 para acceder.', textAlign: TextAlign.center),
          if (onSimulate != null) ...[
            const SizedBox(height: 14),
            // Solo aparece en modo debug, para probar el desbloqueo sin servidor.
            NexusButton(label: '(DEV) SIMULAR NIVEL 4 COMPLETADO', onPressed: onSimulate!),
          ],
        ]),
      ),
    );
  }
}
