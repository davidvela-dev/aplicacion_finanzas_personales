import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Capa de acceso a Firebase Authentication.
/// Las vistas solo llaman a estos métodos; así la lógica de Firebase
/// queda separada de la interfaz.
class AuthService {
  AuthService._();
  static FirebaseAuth get _auth => FirebaseAuth.instance;

  /// Usuario actual, o null si no hay sesión o Firebase no se inicializó
  /// (por ejemplo, en pruebas de widgets o en la versión de muestra).
  static User? get usuario {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  /// Nombre para mostrar: displayName, o la parte local del correo.
  static String nombreDe(User u) {
    final n = u.displayName?.trim() ?? '';
    if (n.isNotEmpty) return n;
    return (u.email ?? 'Usuario').split('@').first;
  }

  static Future<User> iniciarConCorreo(String correo, String clave) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: correo.trim(),
      password: clave,
    );
    return cred.user!;
  }

  static Future<User> registrar(
    String nombre,
    String correo,
    String clave,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: correo.trim(),
      password: clave,
    );
    final user = cred.user!;
    await user.updateDisplayName(nombre.trim());
    await user.sendEmailVerification(); // Email Verification
    // Recarga para que displayName ya esté actualizado en currentUser.
    await user.reload();
    return _auth.currentUser ?? user;
  }

  static GoogleAuthProvider _proveedorGoogle() =>
      GoogleAuthProvider()..setCustomParameters({'prompt': 'select_account'});

  /// Inicio de sesión con Google mediante el flujo OAuth de Firebase.
  /// En web usa ventana emergente; en Android/iOS el flujo nativo del SDK.
  static Future<User> iniciarConGoogle() async {
    final proveedor = _proveedorGoogle();
    final cred = kIsWeb
        ? await _auth.signInWithPopup(proveedor)
        : await _auth.signInWithProvider(proveedor);
    return cred.user!;
  }

  /// True si la cuenta actual fue creada/vinculada con Google.
  static bool get usaGoogle =>
      usuario?.providerData.any((p) => p.providerId == 'google.com') ?? false;

  /// Vuelve a pedir credenciales de Google (necesario para operaciones
  /// sensibles como eliminar la cuenta cuando la sesión es antigua).
  static Future<void> reautenticarConGoogle() async {
    final proveedor = _proveedorGoogle();
    final user = _auth.currentUser!;
    if (kIsWeb) {
      await user.reauthenticateWithPopup(proveedor);
    } else {
      await user.reauthenticateWithProvider(proveedor);
    }
  }

  static Future<void> recuperarClave(String correo) =>
      _auth.sendPasswordResetEmail(email: correo.trim());

  static Future<void> reenviarVerificacion() async =>
      _auth.currentUser?.sendEmailVerification();

  /// En la versión de muestra (sin Firebase) no hay nada que cerrar.
  static Future<void> cerrarSesion() async {
    if (usuario == null) return;
    await _auth.signOut();
  }

  /// Puede lanzar `requires-recent-login` si la sesión es antigua.
  /// Si la cuenta es de Google, reautentica automáticamente y reintenta.
  static Future<void> eliminarCuenta() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login' && usaGoogle) {
        await reautenticarConGoogle();
        await _auth.currentUser?.delete();
      } else {
        rethrow;
      }
    }
  }

  /// Traduce los códigos de FirebaseAuthException a mensajes claros.
  static String mensaje(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          return 'El correo no es válido.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Correo o contraseña incorrectos.';
        case 'email-already-in-use':
          return 'Ya existe una cuenta con ese correo.';
        case 'weak-password':
          return 'La contraseña es muy débil (mínimo 6 caracteres).';
        case 'requires-recent-login':
          return 'Por seguridad, vuelve a iniciar sesión para continuar.';
        case 'network-request-failed':
          return 'Sin conexión. Revisa tu internet.';
        case 'canceled':
        case 'web-context-canceled':
        case 'popup-closed-by-user':
        case 'cancelled-popup-request':
          return 'Inicio de sesión cancelado.';
        case 'popup-blocked':
          return 'El navegador bloqueó la ventana de Google. Permite ventanas emergentes.';
        case 'account-exists-with-different-credential':
          return 'Ya existe una cuenta con ese correo usando otro método de acceso.';
        case 'user-disabled':
          return 'Esta cuenta fue deshabilitada.';
        case 'too-many-requests':
          return 'Demasiados intentos. Intenta más tarde.';
        case 'operation-not-allowed':
          return 'Este método de acceso no está habilitado en Firebase.';
        default:
          return 'Error de autenticación (${e.code}).';
      }
    }
    return 'Ocurrió un error inesperado.';
  }
}
