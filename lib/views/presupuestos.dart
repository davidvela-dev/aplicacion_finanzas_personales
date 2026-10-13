import 'package:flutter/material.dart';

// import '../constants/rutas.dart';

class PresupuestosView extends StatelessWidget {
  const PresupuestosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presupuestos')),
      body: const Center(child: Text('Pantalla de Presupuestos')),
    );
  }
}
