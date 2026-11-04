# Integración de Firebase Auth en "Saldo"

1. flutterfire configure   (genera lib/firebase_options.dart; ya incluido el de la clase)
2. flutter pub add firebase_core firebase_auth
3. Firebase Console > Authentication > Sign-in method: habilitar Correo/contraseña y Google.
4. Android: en android/app/build.gradle usa minSdk 23 como mínimo.
5. El package name debe coincidir con el registrado en Firebase.
6. flutter run

Archivos nuevos/modificados: services/auth_service.dart (nuevo), main.dart, views/login.dart,
views/registro.dart, views/ajustes.dart. El resto del proyecto no cambia.
Nota: este código no pudo compilarse en el entorno donde se generó (sin SDK de Flutter);
ejecuta `flutter analyze` y corrige cualquier detalle menor.
