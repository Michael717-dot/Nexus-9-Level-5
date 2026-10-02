import 'package:flutter/material.dart';

const kBg = Color(0xFF04061A);
const kPanel = Color(0xFF0D1533);
const kCyan = Color(0xFF38F2FF);
const kPurple = Color(0xFFA06BFF);
const kGold = Color(0xFFFFD24A);
const kRed = Color(0xFFFF5A6A);

/// Panel futurista con borde neon.
class NexusPanel extends StatelessWidget {
  const NexusPanel({super.key, required this.child, this.color = kCyan, this.width = 420});
  final Widget child;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kPanel,
        border: Border.all(color: color, width: 2),
        boxShadow: [BoxShadow(color: color.withAlpha(90), blurRadius: 24)],
      ),
      child: child,
    );
  }
}

/// Boton con estilo del juego (cyan o dorado).
class NexusButton extends StatelessWidget {
  const NexusButton({super.key, required this.label, required this.onPressed, this.gold = false});
  final String label;
  final VoidCallback onPressed;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final c = gold ? kGold : kCyan;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: c,
        backgroundColor: const Color(0xFF0A1A3A),
        side: BorderSide(color: c, width: 2),
        shape: const RoundedRectangleBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      child: Text(label, style: const TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold)),
    );
  }
}

/// Pantalla de mensaje de error con opcion de reintentar.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: NexusPanel(
        color: kRed,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('ERROR', style: TextStyle(color: kRed, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          NexusButton(label: 'REINTENTAR', onPressed: onRetry),
        ]),
      ),
    );
  }
}

/// Boton circular que mantiene "presionado" mientras el dedo esta encima.
class HoldButton extends StatelessWidget {
  const HoldButton({super.key, required this.label, required this.onDown, required this.onUp, this.gold = false});
  final String label;
  final VoidCallback onDown;
  final VoidCallback onUp;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final c = gold ? kGold : kCyan;
    return Listener(
      onPointerDown: (_) => onDown(),
      onPointerUp: (_) => onUp(),
      onPointerCancel: (_) => onUp(),
      child: Container(
        width: 64,
        height: 64,
        margin: const EdgeInsets.all(6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xCC0A1A3A),
          border: Border.all(color: c, width: 2),
        ),
        child: Text(label, style: TextStyle(color: c, fontSize: 22, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
