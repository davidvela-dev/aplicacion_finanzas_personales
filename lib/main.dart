import 'package:flutter/material.dart';

// rutas
import 'constants/rutas.dart';

// pantallas
import 'views/login.dart';
import 'views/registro.dart';
import 'views/edicion.dart';
import 'views/categorias.dart';
import 'views/subir.dart';
import 'views/views_layout.dart'; // layout carga las pantallas inicio, movimientos, presupuestos y registros

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Rutas.inicio, // ruta inicial saltando la autenticacion
      // initialRoute: Rutas.login,

      // diccionario de rutas nombradas
      routes: {
        Rutas.login: (context) => const LoginView(),
        Rutas.registro: (context) => const RegistroView(),
        Rutas.edicion: (context) => const EdicionView(),
        Rutas.categorias: (context) => const CategoriasView(),
        Rutas.subir: (context) => const SubirView(),

        // pantallas del mismo layout con distinto indice
        Rutas.inicio: (context) => const ViewsLayout(initialIndex: 0),
        Rutas.movimientos: (context) => const ViewsLayout(initialIndex: 1),
        Rutas.presupuestos: (context) => const ViewsLayout(initialIndex: 2),
        Rutas.reportes: (context) => const ViewsLayout(initialIndex: 3),
      },
    );
  }
}
