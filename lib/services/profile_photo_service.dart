import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Guarda la foto de perfil **solo localmente** en el directorio de documentos
/// de la app. El path se guarda en Firestore para recuperarlo en cada sesión.
/// No se usa Firebase Storage por requerimiento explícito.
class ProfilePhotoService {
  static Future<File> guardar(File origen) async {
    final dir = await getApplicationDocumentsDirectory();
    final destino = File(
      '${dir.path}/perfil_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await destino.writeAsBytes(await origen.readAsBytes());
    return destino;
  }

  static Future<void> eliminar(String? path) async {
    if (path == null || path.isEmpty) return;
    final f = File(path);
    if (await f.exists()) {
      try {
        await f.delete();
      } catch (_) {}
    }
  }

  static bool existe(String? path) {
    if (path == null || path.isEmpty) return false;
    return File(path).existsSync();
  }
}
