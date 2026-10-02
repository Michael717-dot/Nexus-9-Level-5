import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import 'nexus_game.dart';

enum LunaState { idle, walk, run, jumpUp, jumpTop, jumpDown }

/// Luna: usa el spritesheet (frames de 112x96, 8 columnas).
/// Filas: 0 IDLE, 1 WALK, 2 RUN, 3 JUMP, 4 INTERACT, 5 INVESTIGATE, 6 DAMAGE, 7 VICTORY, 8 DEFEAT.
class Luna extends SpriteAnimationGroupComponent<LunaState> with HasGameReference<NexusGame> {
  Luna()
      : super(
          size: Vector2(112, 96),
          anchor: const Anchor(0.5, 0.875), // punto de referencia = pies (56, 84)
          scale: Vector2.all(2),
        );

  double vy = 0, hold = 0;
  bool onGround = true;
  int facing = 1;

  @override
  Future<void> onLoad() async {
    final image = await game.images.load('luna_spritesheet.png');
    final sheet = SpriteSheet(image: image, srcSize: Vector2(112, 96));
    SpriteAnimation jumpFrame(int f) =>
        sheet.createAnimation(row: 3, stepTime: 1, from: f, to: f + 1, loop: false);
    animations = {
      LunaState.idle: sheet.createAnimation(row: 0, stepTime: 1 / 8, to: 6),
      LunaState.walk: sheet.createAnimation(row: 1, stepTime: 1 / 10, to: 8),
      LunaState.run: sheet.createAnimation(row: 2, stepTime: 1 / 14, to: 8),
      LunaState.jumpUp: jumpFrame(1),
      LunaState.jumpTop: jumpFrame(2),
      LunaState.jumpDown: jumpFrame(3),
    };
    current = LunaState.idle;
  }

  @override
  void update(double dt) {
    super.update(dt);
    final g = game;
    final dir = (g.right ? 1 : 0) - (g.left ? 1 : 0);
    if (dir != 0) {
      facing = dir;
      hold += dt;
    } else {
      hold = 0;
    }
    final run = hold > 0.55;
    x += dir * (run ? 330 : 190) * dt;

    if (g.jump && onGround) {
      vy = -650;
      onGround = false;
    }
    final prevY = y;
    vy += 1700 * dt;
    y += vy * dt;
    onGround = false;
    if (y >= kGround) {
      y = kGround;
      vy = 0;
      onGround = true;
    }
    for (final p in kPlatforms) {
      if (vy >= 0 && prevY <= p.top + 1 && y >= p.top && x > p.left - 6 && x < p.right + 6) {
        y = p.top;
        vy = 0;
        onGround = true;
      }
    }
    x = math.min(math.max(x, 40.0), kWorldW - 40.0);

    scale.x = 2.0 * facing; // voltea a Luna segun la direccion
    if (!onGround) {
      current = vy < -250 ? LunaState.jumpUp : (vy < 150 ? LunaState.jumpTop : LunaState.jumpDown);
    } else if (dir == 0) {
      current = LunaState.idle;
    } else {
      current = run ? LunaState.run : LunaState.walk;
    }
  }
}
