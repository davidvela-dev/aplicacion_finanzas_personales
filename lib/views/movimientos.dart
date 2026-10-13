import 'package:flutter/material.dart';

// import '../constants/rutas.dart';

class MovimientosView extends StatelessWidget {
  const MovimientosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movimientos')),
      body: const Center(child: Text('Pantalla de Movimientos')),
    );
  }
}
