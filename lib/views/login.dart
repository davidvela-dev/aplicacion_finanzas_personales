import 'package:flutter/material.dart';

// import '../constants/rutas.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(
        child: Text('Pantalla de Login'),
        /* 
        child: ElevatedButton(
          onPressed: () {
            // Navigator.pushNamed(context, Rutas.registro);
          },
          child: const Text('Ir a Registro'),
        ),
        */
      ),
    );
  }
}
