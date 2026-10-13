import 'package:flutter/material.dart';

// import '../constants/rutas.dart';

class EdicionView extends StatelessWidget {
  const EdicionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edicion')),
      body: const Center(child: Text('Pantalla de Edicion')),
    );
  }
}
