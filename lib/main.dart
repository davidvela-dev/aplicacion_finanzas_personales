import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'constants/rutas.dart';
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

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => FinanzasProvider(),
    child: const MyApp(),
  ),
);

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
      initialRoute: Rutas.login,

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
