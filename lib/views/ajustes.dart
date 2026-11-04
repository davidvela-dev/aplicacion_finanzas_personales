import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/rutas.dart';
import '../services/auth_service.dart';
import '../viewmodels/finanzas_provider.dart';
import '../widgets/componentes.dart';

class AjustesView extends StatelessWidget {
  const AjustesView({super.key});
  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Encabezado(
            titulo: 'A tu manera.',
            subtitulo: 'Pequeños ajustes, más comodidad.',
          ),
          Tarjeta(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  child: Text(datos.nombre.substring(0, 1).toUpperCase()),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        datos.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AuthService.usuario?.email ?? 'Perfil de demostración',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'APARIENCIA Y PRIVACIDAD',
            style: TextStyle(fontSize: 11, letterSpacing: 1.2),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Modo oscuro'),
                  subtitle: const Text('Cambia el tema de toda la app'),
                  value: datos.modoOscuro,
                  onChanged: datos.cambiarTema,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  secondary: const Icon(Icons.visibility_off_outlined),
                  title: const Text('Ocultar montos'),
                  subtitle: const Text(
                    'Oculta los importes en inicio y movimientos',
                  ),
                  value: datos.ocultarMontos,
                  onChanged: datos.cambiarPrivacidad,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Alertas y recordatorios'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, Rutas.alertas),
                ),
                ListTile(
                  leading: const Icon(Icons.category_outlined),
                  title: const Text('Categorías'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, Rutas.categorias),
                ),
                ListTile(
                  leading: const Icon(Icons.upload_file_outlined),
                  title: const Text('Estados de cuenta'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(context, Rutas.subir),
                ),
                if (AuthService.usuario != null &&
                    !AuthService.usuario!.emailVerified)
                  ListTile(
                    leading: const Icon(Icons.mark_email_unread_outlined),
                    title: const Text('Verificar correo electrónico'),
                    subtitle: const Text('Reenviar el correo de verificación'),
                    onTap: () async {
                      await AuthService.reenviarVerificacion();
                      if (context.mounted) {
                        aviso(context, 'Correo de verificación enviado.');
                      }
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.ios_share),
                  title: const Text('Exportar mis movimientos'),
                  onTap: () => mostrarPendiente(
                    context,
                    'Exportar datos',
                    'Se creará un archivo CSV con tu historial para compartirlo o respaldarlo.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Card(
            child: ExpansionTile(
              key: PageStorageKey('acerca-de-saldo'),
              leading: Icon(Icons.info_outline),
              title: Text('Acerca de Saldo'),
              childrenPadding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              children: [
                Text(
                  'Saldo es una app de finanzas personales para estudiantes y jóvenes profesionistas.\n\nEntrega 1: interfaz y navegación. Los datos son de ejemplo y los cambios duran solo mientras la app está abierta.\n\nEquipo: David Valdez Martinez, Vittorio Catino y David Vela.\n\nVersión 1.0.0',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () async {
              final salir = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('¿Cerrar sesión?'),
                  content: const Text(
                    'Volverás a la pantalla de inicio de sesión.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Salir'),
                    ),
                  ],
                ),
              );
              if (salir == true && context.mounted) {
                await AuthService.cerrarSesion();
                if (!context.mounted) return;
                context.read<FinanzasProvider>().cerrarSesion();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Rutas.login,
                  (_) => false,
                );
              }
            },
            icon: const Icon(Icons.logout),
            label: Text(
              AuthService.usuario == null
                  ? 'Cerrar sesión de muestra'
                  : 'Cerrar sesión',
            ),
          ),
          if (AuthService.usuario != null)
            TextButton.icon(
              onPressed: () async {
                final borrar = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('¿Eliminar cuenta?'),
                    content: const Text(
                      'Se eliminará tu cuenta de Firebase. Esta acción no se puede deshacer.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                );
                if (borrar != true || !context.mounted) return;
                try {
                  await AuthService.eliminarCuenta();
                  if (!context.mounted) return;
                  context.read<FinanzasProvider>().cerrarSesion();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Rutas.login,
                    (_) => false,
                  );
                } catch (e) {
                  if (context.mounted) aviso(context, AuthService.mensaje(e));
                }
              },
              icon: const Icon(Icons.delete_forever_outlined),
              label: const Text('Eliminar cuenta'),
            ),
          const EtiquetaDemo(),
        ],
      ),
    );
  }
}
