import 'package:flutter/material.dart';

// import '../constants/rutas.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: const Center(child: Text('Pantalla de Inicio')),
    );
  }
}
