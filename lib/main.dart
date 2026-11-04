import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'constants/rutas.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';
import 'constants/tema.dart';
import 'viewmodels/finanzas_provider.dart';
import 'views/ajustes.dart';
import 'views/alertas.dart';
import 'views/login.dart';
import 'views/registro.dart';
import 'views/edicion.dart';
import 'views/categorias.dart';
import 'views/subir.dart';
import 'views/views_layout.dart'; // layout carga las pantallas inicio, movimientos, presupuestos y registros

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) {
        final provider = FinanzasProvider();
        // Sesión restaurada por Firebase: muestra el nombre real del usuario.
        final u = AuthService.usuario;
        if (u != null) provider.iniciarSesion(AuthService.nombreDe(u));
        return provider;
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    return MaterialApp(
      title: 'Saldo',
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'MX'),
      supportedLocales: const [Locale('es', 'MX')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: crearTema(Brightness.light),
      darkTheme: crearTema(Brightness.dark),
      themeMode: datos.modoOscuro ? ThemeMode.dark : ThemeMode.light,
      // Si ya hay sesión guardada en Firebase, entra directo a la app.
      initialRoute: AuthService.usuario == null ? Rutas.login : Rutas.inicio,

      // diccionario de rutas nombradas
      routes: {
        Rutas.login: (context) => const LoginView(),
        Rutas.registro: (context) => const RegistroView(),
        Rutas.edicion: (context) => const EdicionView(),
        Rutas.categorias: (context) => const CategoriasView(),
        Rutas.subir: (context) => const SubirView(),
        Rutas.ajustes: (context) => const AjustesView(),
        Rutas.alertas: (context) => const AlertasView(),

        // pantallas del mismo layout con distinto indice
        Rutas.inicio: (context) => const ViewsLayout(initialIndex: 0),
        Rutas.movimientos: (context) => const ViewsLayout(initialIndex: 1),
        Rutas.presupuestos: (context) => const ViewsLayout(initialIndex: 2),
        Rutas.reportes: (context) => const ViewsLayout(initialIndex: 3),
      },
    );
  }
}
