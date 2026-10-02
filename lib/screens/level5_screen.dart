import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/nexus_game.dart';
import '../ui/nexus_ui.dart';

/// Pantalla principal del Nivel 5 (HU-001): escenario + Luna + HUD + boton INICIAR.
class Level5Screen extends StatefulWidget {
  const Level5Screen({super.key});

  @override
  State<Level5Screen> createState() => _Level5ScreenState();
}

class _Level5ScreenState extends State<Level5Screen> {
  late NexusGame _game = NexusGame();

  Future<void> _pause() async {
    _game.pauseEngine();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: NexusPanel(
          width: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('PAUSA', style: TextStyle(color: kCyan, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Builder(
              builder: (ctx) => NexusButton(label: 'CONTINUAR', onPressed: () => Navigator.of(ctx).pop()),
            ),
          ]),
        ),
      ),
    );
    _game.resumeEngine();
  }

  void _startNexus() {
    // HU-002 (Introduccion de NEXUS) se implementa despues; aqui solo se inicia la interaccion.
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NexusIntroPlaceholder()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(
        child: GameWidget<NexusGame>(
          game: _game,
          loadingBuilder: (_) => const Center(child: CircularProgressIndicator(color: kCyan)),
          errorBuilder: (_, error) => ErrorView(
            message: 'No se pudo cargar el Nivel 5.\n$error',
            onRetry: () => setState(() => _game = NexusGame()),
          ),
        ),
      ),
      // HUD superior
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: const Color(0xAA050A20),
            child: Column(children: [
              Row(children: [
                const Expanded(
                  child: Text('NEXUS-9 · NVL 5: EL NÚCLEO',
                      style: TextStyle(color: kCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const Text('LLAVES 0/1   DESAFÍOS 0/4   ', style: TextStyle(fontSize: 11)),
                SizedBox(
                  height: 28,
                  child: OutlinedButton(
                    onPressed: _pause,
                    style: OutlinedButton.styleFrom(
                        foregroundColor: kCyan, side: const BorderSide(color: kCyan), shape: const RoundedRectangleBorder()),
                    child: const Text('PAUSA', style: TextStyle(fontSize: 10)),
                  ),
                ),
              ]),
              const Text('Nivel 5 — El Núcleo',
                  style: TextStyle(color: kGold, fontWeight: FontWeight.bold, fontSize: 14)),
            ]),
          ),
        ),
      ),
      // Controles tactiles
      Positioned(
        left: 12,
        bottom: 8,
        child: SafeArea(
          child: Row(children: [
            HoldButton(label: '◀', onDown: () => _game.left = true, onUp: () => _game.left = false),
            HoldButton(label: '▶', onDown: () => _game.right = true, onUp: () => _game.right = false),
          ]),
        ),
      ),
      Positioned(
        right: 12,
        bottom: 8,
        child: SafeArea(
          child: HoldButton(label: '▲', onDown: () => _game.jump = true, onUp: () => _game.jump = false),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: NexusButton(label: 'INICIAR', gold: true, onPressed: _startNexus),
          ),
        ),
      ),
    ]);
  }
}

/// Pantalla temporal: aqui entra la HU-002 (dialogo de NEXUS).
class NexusIntroPlaceholder extends StatelessWidget {
  const NexusIntroPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: NexusPanel(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('NEXUS', style: TextStyle(color: kCyan, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Aquí empieza la introducción de NEXUS (HU-002).', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            NexusButton(label: 'VOLVER', onPressed: () => Navigator.of(context).pop()),
          ]),
        ),
      ),
    );
  }
}
