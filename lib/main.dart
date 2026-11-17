import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'constants/rutas.dart';
import 'constants/tema.dart';
import 'firebase_options.dart';
import 'viewmodels/finanzas_provider.dart';
import 'views/ajustes.dart';
import 'views/alertas.dart';
import 'views/categorias.dart';
import 'views/edicion.dart';
import 'views/login.dart';
import 'views/registro.dart';
import 'views/subir.dart';
import 'views/views_layout.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SaldoApp());
}

class SaldoApp extends StatelessWidget {
  const SaldoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinanzasProvider(),
      child: Consumer<FinanzasProvider>(
        builder: (context, finanzas, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Saldo',
            debugShowCheckedModeBanner: false,
            theme: crearTema(Brightness.light),
            darkTheme: crearTema(Brightness.dark),
            themeMode: finanzas.modoOscuro ? ThemeMode.dark : ThemeMode.light,
            locale: const Locale('es', 'MX'),
            supportedLocales: const [
              Locale('es', 'MX'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routes: {
              Rutas.login: (_) => const LoginView(),
              Rutas.registro: (_) => const RegistroView(),
              Rutas.edicion: (_) => const EdicionView(),
              Rutas.categorias: (_) => const CategoriasView(),
              Rutas.subir: (_) => const SubirView(),
              Rutas.ajustes: (_) => const AjustesView(),
              Rutas.alertas: (_) => const AlertasView(),
            },
            home: const _AuthGate(),
          );
        },
      ),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  String? _boundUid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        // Sesión cerrada: limpia navegación y muestra login.
        if (user == null) {
          if (_boundUid != null) {
            _boundUid = null;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              navigatorKey.currentState?.popUntil((r) => r.isFirst);
              if (context.mounted) {
                context.read<FinanzasProvider>().bind('');
              }
            });
          }
          return const LoginView();
        }

        // Sesión iniciada: vincula el provider una sola vez.
        if (_boundUid != user.uid) {
          _boundUid = user.uid;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.read<FinanzasProvider>().bind(user.uid);
            }
          });
        }

        return const ViewsLayout();
      },
    );
  }
}
