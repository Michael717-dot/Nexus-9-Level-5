import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show KeyEventResult;

import 'luna.dart';
import 'scenery.dart';

const double kViewW = 960, kViewH = 540, kWorldW = 2600, kGround = 470;

/// Plataformas (se pueden pisar desde arriba).
final List<Rect> kPlatforms = [
  Rect.fromLTWH(300, 385, 180, 10),
  Rect.fromLTWH(820, 385, 200, 10),
  Rect.fromLTWH(1560, 385, 220, 10),
  Rect.fromLTWH(1650, 300, 110, 10),
];

class NexusGame extends FlameGame with KeyboardEvents {
  NexusGame()
      : super(camera: CameraComponent.withFixedResolution(width: kViewW, height: kViewH));

  // Entradas (las llenan los botones tactiles o el teclado).
  bool left = false, right = false, jump = false;
  late final Luna luna;

  @override
  Color backgroundColor() => const Color(0xFF04061A);

  @override
  Future<void> onLoad() async {
    world.add(Scenery());
    luna = Luna()..position = Vector2(160, kGround);
    world.add(luna);
    camera.viewfinder.position = Vector2(kViewW / 2, kViewH / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final cx = math.min(math.max(luna.x, kViewW / 2), kWorldW - kViewW / 2);
    camera.viewfinder.position = Vector2(cx, kViewH / 2);
  }

  // Teclado (solo para probar en computador / emulador).
  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keys) {
    left = keys.contains(LogicalKeyboardKey.arrowLeft) || keys.contains(LogicalKeyboardKey.keyA);
    right = keys.contains(LogicalKeyboardKey.arrowRight) || keys.contains(LogicalKeyboardKey.keyD);
    jump = keys.contains(LogicalKeyboardKey.space) ||
        keys.contains(LogicalKeyboardKey.arrowUp) ||
        keys.contains(LogicalKeyboardKey.keyW);
    return KeyEventResult.handled;
  }
}
