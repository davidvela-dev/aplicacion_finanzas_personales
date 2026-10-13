import 'package:flutter/material.dart';

// rutas
import 'constants/rutas.dart';

// pantallas
import 'views/login.dart';
import 'views/registro.dart';
import 'views/inicio.dart';
import 'views/movimientos.dart';
import 'views/edicion.dart';
import 'views/presupuestos.dart';
import 'views/reportes.dart';
import 'views/categorias.dart';
import 'views/subir.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Rutas.login,

      // diccionario de rutas nombradas
      routes: {
        Rutas.login: (context) => const LoginView(),
        Rutas.registro: (context) => const RegistroView(),
        Rutas.inicio: (context) => const InicioView(),
        Rutas.movimientos: (context) => const MovimientosView(),
        Rutas.edicion: (context) => const EdicionView(),
        Rutas.presupuestos: (context) => const PresupuestosView(),
        Rutas.reportes: (context) => const ReportesView(),
        Rutas.categorias: (context) => const CategoriasView(),
        Rutas.subir: (context) => const SubirView(),
      },
    );
  }
}
