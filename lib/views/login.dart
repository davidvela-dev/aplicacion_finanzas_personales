import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/rutas.dart';
import '../services/auth_service.dart';
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
  bool _cargando = false;

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  Future<void> _autenticar(Future<User> Function() accion) async {
    setState(() => _cargando = true);
    try {
      await accion();
    } catch (e) {
      if (mounted) aviso(context, AuthService.mensaje(e));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _entrar() {
    if (_correo.text.trim().isEmpty || _clave.text.isEmpty) {
      aviso(context, 'Escribe tu correo y contraseña.');
      return;
    }
    _autenticar(() => AuthService.iniciarConCorreo(_correo.text, _clave.text));
  }

  Future<void> _recuperar() async {
    if (_correo.text.trim().isEmpty) {
      aviso(context, 'Escribe tu correo para enviarte el enlace.');
      return;
    }
    try {
      await AuthService.recuperarClave(_correo.text);
      if (mounted) aviso(context, 'Te enviamos un enlace de recuperación.');
    } catch (e) {
      if (mounted) aviso(context, AuthService.mensaje(e));
    }
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
                    tooltip:
                        _ocultar ? 'Mostrar contraseña' : 'Ocultar contraseña',
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
                  onPressed: _recuperar,
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ),
              FilledButton(
                onPressed: _cargando ? null : _entrar,
                child: _cargando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Iniciar sesión'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _cargando
                    ? null
                    : () => _autenticar(AuthService.iniciarConGoogle),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                icon: const Icon(Icons.g_mobiledata, size: 30),
                label: const Text('Continuar con Google'),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text('¿Aún no tienes cuenta?'),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, Rutas.registro),
                    child: const Text('Regístrate'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
