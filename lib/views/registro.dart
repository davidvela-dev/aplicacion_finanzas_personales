import 'package:flutter/material.dart';

import '../widgets/componentes.dart';

class RegistroView extends StatefulWidget {
  const RegistroView({super.key});
  @override
  State<RegistroView> createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  final _formulario = GlobalKey<FormState>();
  final _clave = TextEditingController();
  bool _acepta = false;
  bool _ocultar = true;
  @override
  void dispose() {
    _clave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Crear cuenta')),
    body: Form(
      key: _formulario,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Encabezado(
            titulo: 'Empieza con calma.',
            subtitulo: 'El primer paso para conocer tus finanzas.',
          ),
          const MarcaSaldo(),
          const SizedBox(height: 26),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nombre completo'),
            validator: (v) =>
                (v ?? '').trim().isEmpty ? 'Escribe tu nombre' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
            validator: (v) =>
                !(v ?? '').contains('@') ? 'Escribe un correo válido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _clave,
            obscureText: _ocultar,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              helperText: 'Al menos 6 caracteres',
              suffixIcon: IconButton(
                tooltip: 'Ver contraseña',
                onPressed: () => setState(() => _ocultar = !_ocultar),
                icon: Icon(
                  _ocultar
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
              ),
            ),
            validator: (v) =>
                (v ?? '').length < 6 ? 'Usa al menos 6 caracteres' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: _ocultar,
            decoration: const InputDecoration(
              labelText: 'Confirmar contraseña',
            ),
            validator: (v) =>
                v != _clave.text ? 'Las contraseñas no coinciden' : null,
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _acepta,
            onChanged: (v) => setState(() => _acepta = v ?? false),
            title: const Text(
              'Acepto el aviso de privacidad',
              style: TextStyle(fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () => mostrarPendiente(
              context,
              'Privacidad',
              'La app guardará los movimientos en el dispositivo. El aviso definitivo se agregará antes de publicar la app.',
            ),
            child: const Text('Consultar aviso'),
          ),
          FilledButton(
            onPressed: () {
              if (!_formulario.currentState!.validate()) return;
              if (!_acepta) {
                aviso(context, 'Acepta el aviso de privacidad para continuar.');
                return;
              }
              mostrarPendiente(
                context,
                'Registro de muestra',
                'Aquí se creará tu cuenta. Esta entrega no guarda cuentas ni contraseñas.',
              );
            },
            child: const Text('Crear mi cuenta'),
          ),
          const EtiquetaDemo(),
        ],
      ),
    ),
  );
}
