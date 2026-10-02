import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show Alignment, LinearGradient, RadialGradient;

import 'nexus_game.dart';

const _cyan = Color(0xFF38F2FF);
const _purple = Color(0xFFA06BFF);
const _leds = [Color(0xFF38F2FF), Color(0xFF5BFF9A), Color(0xFFA06BFF), Color(0xFFFFB040)];

Color _a(Color c, double a) => c.withAlpha((a * 255).round().clamp(0, 255).toInt());
void _r(Canvas c, double x, double y, double w, double h, Color col) =>
    c.drawRect(Rect.fromLTWH(x, y, w, h), Paint()..color = col);
void _sr(Canvas c, double x, double y, double w, double h, Color col) => c.drawRect(
    Rect.fromLTWH(x, y, w, h),
    Paint()
      ..color = col
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5);
void _glow(Canvas c, double x, double y, double r, Color col, double a) {
  final rect = Rect.fromCircle(center: Offset(x, y), radius: r);
  c.drawCircle(Offset(x, y), r,
      Paint()..shader = RadialGradient(colors: [_a(col, a), _a(col, 0)]).createShader(rect));
}

/// Instalacion del Nucleo: servidores, tuberias, vapor, tanques, plataformas, terminales, puerta y drones.
class Scenery extends PositionComponent {
  Scenery() : super(size: Vector2(kWorldW, kViewH), priority: -10);
  double t = 0;

  @override
  void update(double dt) => t += dt;

  @override
  void render(Canvas c) {
    const w = kWorldW, h = kViewH;
    final full = Rect.fromLTWH(0, 0, w, h);
    c.drawRect(
        full,
        Paint()
          ..shader = const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF04061A), Color(0xFF111B40)])
              .createShader(full));
    // Racks de servidores con luces parpadeantes
    for (var i = 0; i < 24; i++) {
      final x = i * 110.0 + 8;
      _r(c, x, 62, 92, 258, const Color(0xFF0A1233));
      _sr(c, x, 62, 92, 258, const Color(0xFF1C2C62));
      for (var r = 0; r < 9; r++) {
        _r(c, x + 6, 70 + r * 27, 80, 20, const Color(0xFF0D1A44));
        for (var k = 0; k < 5; k++) {
          final on = math.sin(t * 3 + i * 7 + r * 3 + k) > 0.2;
          _r(c, x + 11 + k * 15, 77 + r * 27, 4, 3, on ? _leds[(r + k + i) % 4] : const Color(0xFF132050));
        }
      }
    }
    // Tuberia superior, bridas, pantallas y vapor
    _r(c, 0, 40, w, 16, const Color(0xFF1A2A5C));
    _r(c, 0, 40, w, 3, const Color(0xFF3A4C8C));
    for (var i = 0; i < 9; i++) {
      final x = 160.0 + i * 290;
      _r(c, x, 36, 12, 24, const Color(0xFF4F66B8));
      _r(c, x + 3, 56, 7, 90, const Color(0xFF16244F));
      for (var k = 0; k < 4; k++) {
        final u = (t * 0.5 + k / 4) % 1;
        c.drawCircle(Offset(x + 6 + math.sin(u * 5 + k) * 6, 150 + u * 50), 4 + u * 10,
            Paint()..color = _a(const Color(0xFFC8E6FF), 0.25 * (1 - u)));
      }
      final mx = 300.0 + i * 290;
      _r(c, mx, 110, 84, 52, const Color(0xFF050A20));
      _sr(c, mx, 110, 84, 52, _cyan);
      for (var k = 0; k < 4; k++) {
        _r(c, mx + 8, 119 + k * 9, 20 + ((t * 20 + k * 13 + i * 7) % 50), 3, k.isOdd ? _cyan : _purple);
      }
    }
    // Suelo con rejilla
    _r(c, 0, kGround, w, 70, const Color(0xFF0E1738));
    _r(c, 0, kGround, w, 2, _cyan);
    for (var x = 0.0; x < w; x += 24) {
      _r(c, x, kGround + 8, 2, 62, const Color(0xFF0A1230));
    }
    // Tanques de energia
    for (final x in const <double>[260, 1000, 1980]) {
      _r(c, x - 22, kGround - 130, 44, 130, const Color(0xFF0A1A3C));
      final l = 0.6 + 0.1 * math.sin(t + x);
      _r(c, x - 18, kGround - 126 + 120 * (1 - l), 36, 120 * l, const Color(0xFF1EC9E6));
      _sr(c, x - 22, kGround - 130, 44, 130, const Color(0xFF5F7FD0));
      _glow(c, x, kGround - 70, 70, _cyan, 0.25);
    }
    // Cajas y barriles
    for (final x in const <double>[350, 1650]) {
      _r(c, x - 24, kGround - 46, 48, 46, const Color(0xFF3A3050));
      _sr(c, x - 24, kGround - 46, 48, 46, const Color(0xFF8A70C0));
    }
    for (final x in const <double>[420, 900, 2100]) {
      _r(c, x - 18, kGround - 46, 36, 46, const Color(0xFF1A2A50));
      _r(c, x - 18, kGround - 38, 36, 3, _cyan);
      _r(c, x - 18, kGround - 16, 36, 3, _cyan);
    }
    // Cristales de energia
    for (final x in const <double>[1720, 2520]) {
      final y = x == 1720 ? 300.0 : kGround;
      _glow(c, x, y - 24, 50, _purple, 0.35);
      final p = Path()
        ..moveTo(x, y - 46)
        ..lineTo(x + 12, y - 20)
        ..lineTo(x, y)
        ..lineTo(x - 12, y - 20)
        ..close();
      c.drawPath(p, Paint()..color = _purple);
    }
    // Plataformas
    for (final p in kPlatforms) {
      _r(c, p.left + 8, p.top + 10, 6, kGround - p.top - 10, const Color(0xFF22336F));
      _r(c, p.left + p.width - 14, p.top + 10, 6, kGround - p.top - 10, const Color(0xFF22336F));
      _r(c, p.left, p.top, p.width, 10, const Color(0xFF1A2A60));
      _r(c, p.left, p.top, p.width, 2, _cyan);
      _r(c, p.left, p.top - 24, 2, 24, const Color(0xFF4F66B8));
      _r(c, p.left + p.width - 2, p.top - 24, 2, 24, const Color(0xFF4F66B8));
      _r(c, p.left, p.top - 24, p.width, 2, const Color(0xFF4F66B8));
    }
    // Terminales (HU-001: la 1 esta activa, las demas bloqueadas)
    const xs = <double>[560, 1150, 1900, 2340];
    for (var i = 0; i < xs.length; i++) {
      final active = i == 0;
      final col = active
          ? (math.sin(t * 6) > 0 ? _cyan : const Color(0xFF1A6A80))
          : const Color(0xFFFF4A5A);
      final x = xs[i];
      _glow(c, x, kGround - 64, 60, col, 0.28);
      _r(c, x - 24, kGround - 90, 48, 90, const Color(0xFF101A44));
      _sr(c, x - 24, kGround - 90, 48, 90, col);
      _r(c, x - 18, kGround - 80, 36, 32, const Color(0xFF050A20));
      for (var k = 0; k < 4; k++) {
        _r(c, x - 14, kGround - 76 + k * 7, 8 + ((k * 11 + t * 10) % 18), 2, col);
      }
    }
    // Puerta (cerrada hasta el Desafio 2)
    const dx = 1400.0;
    _r(c, dx - 52, kGround - 214, 104, 214, const Color(0xFF050A20));
    _r(c, dx - 52, kGround - 224, 104, 8, const Color(0xFFFF3B4A));
    _r(c, dx - 46, kGround - 210, 46, 210, const Color(0xFF17265A));
    _r(c, dx, kGround - 210, 46, 210, const Color(0xFF17265A));
    for (var y = kGround - 190; y < kGround; y += 40) {
      _r(c, dx - 46, y, 92, 6, const Color(0xFFFFB040));
    }
    // Drones decorativos
    for (var i = 0; i < 3; i++) {
      final x = 300 + i * 900 + math.sin(t * 0.5 + i) * 120;
      final y = 200 + math.sin(t * 1.3 + i) * 20;
      c.drawOval(Rect.fromCenter(center: Offset(x, y), width: 32, height: 16), Paint()..color = const Color(0xFF1A2A60));
      _r(c, x - 3, y - 2, 6, 4, _cyan);
      _r(c, x - 22, y - 9, 14, 2, const Color(0xFF7FA0FF));
      _r(c, x + 8, y - 9, 14, 2, const Color(0xFF7FA0FF));
      _glow(c, x, y + 14, 26, _cyan, 0.2);
    }
  }
}
