import 'package:shared_preferences/shared_preferences.dart';

/// Contrato para leer/guardar el progreso del jugador.
///
/// El equipo todavia no definio servidor ni base de datos. Cuando lo hagan,
/// solo hay que crear otra clase que implemente esta interfaz (por ejemplo
/// ApiProgressRepository o FirebaseProgressRepository) y cambiarla en main.dart.
/// El resto del juego no se toca.
abstract class ProgressRepository {
  /// ¿El nivel [level] ya fue completado?
  Future<bool> isLevelCompleted(int level);

  /// Marca un nivel como completado / no completado.
  /// (Lo usaran HU-009 y HU-010; aqui sirve tambien para pruebas.)
  Future<void> setLevelCompleted(int level, bool value);
}

/// Implementacion TEMPORAL: guarda en el celular/navegador. No es compartida con el equipo.
/// Si el almacenamiento falla, usa la memoria para que el juego siga funcionando.
class LocalProgressRepository implements ProgressRepository {
  static final Map<int, bool> _memory = {};
  static String _key(int level) => 'nexus9_level_${level}_completed';

  @override
  Future<bool> isLevelCompleted(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_key(level)) ?? _memory[level] ?? false;
    } catch (_) {
      return _memory[level] ?? false;
    }
  }

  @override
  Future<void> setLevelCompleted(int level, bool value) async {
    _memory[level] = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key(level), value);
    } catch (_) {
      // Se queda solo en memoria.
    }
  }
}
