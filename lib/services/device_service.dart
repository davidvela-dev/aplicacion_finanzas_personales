import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Genera y persiste un token único del dispositivo (UUID v4).
/// El token se guarda una sola vez por instalación en `SharedPreferences`
/// y se sincroniza con el perfil del usuario en Firestore.
class DeviceService {
  static const _key = 'saldo.device_token';
  static String? _cache;

  static Future<String> tokenDispositivo() async {
    if (_cache != null) return _cache!;
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(_key);
    if (token == null || token.isEmpty) {
      token = const Uuid().v4();
      await prefs.setString(_key, token);
    }
    _cache = token;
    return token;
  }
}
