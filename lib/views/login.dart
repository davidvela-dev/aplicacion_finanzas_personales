import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/rutas.dart';
import '../constants/tema.dart';
import '../viewmodels/finanzas_provider.dart';
import '../widgets/componentes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  bool _ocultar = true;

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  void _entrar() {
    if (!_correo.text.contains('@') || _clave.text.length < 6) {
      aviso(
        context,
        'Escribe un correo válido y una contraseña de al menos 6 caracteres.',
      );
      return;
    }
    mostrarPendiente(
      context,
      'Inicio de sesión de muestra',
      'Aquí se validarán tus credenciales. Por ahora puedes explorar con datos de ejemplo.',
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(28),
        children: [
          const SizedBox(height: 30),
          const MarcaSaldo(grande: true),
          const SizedBox(height: 42),
          const Text(
            'Tu dinero,\nmás claro.',
            style: TextStyle(
              fontSize: 43,
              height: 1.12,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.8,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Menos dudas a fin de mes.\nUn lugar para cuidar lo que ganas.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _correo,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              prefixIcon: Icon(Icons.alternate_email),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _clave,
            obscureText: _ocultar,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                tooltip: _ocultar ? 'Mostrar contraseña' : 'Ocultar contraseña',
                onPressed: () => setState(() => _ocultar = !_ocultar),
                icon: Icon(
                  _ocultar
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => mostrarPendiente(
                context,
                'Recuperar contraseña',
                'Se enviará un enlace de recuperación al correo registrado.',
              ),
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ),
          FilledButton(onPressed: _entrar, child: const Text('Iniciar sesión')),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              context.read<FinanzasProvider>().iniciarSesion('Vittorio');
              Navigator.pushReplacementNamed(context, Rutas.inicio);
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: const Text('Explorar versión de muestra'),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('¿Aún no tienes cuenta?'),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, Rutas.registro),
                child: const Text('Regístrate'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.shield_outlined, size: 16, color: Colores.verde),
              SizedBox(width: 7),
              Text(
                'Sin vincular cuentas bancarias',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          const EtiquetaDemo(),
        ],
      ),
    ),
  );
}
