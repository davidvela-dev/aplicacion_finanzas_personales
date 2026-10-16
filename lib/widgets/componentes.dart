import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/rutas.dart';
import '../constants/tema.dart';
import '../models/movimiento.dart';
import '../viewmodels/finanzas_provider.dart';

Future<void> mostrarPendiente(
  BuildContext context,
  String titulo,
  String texto,
) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(titulo),
    content: Text(
      '$texto\n\nFuncionalidad pendiente para la siguiente entrega.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Entendido'),
      ),
    ],
  ),
);

void aviso(BuildContext context, String texto) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));

class MarcaSaldo extends StatelessWidget {
  const MarcaSaldo({super.key, this.grande = false});
  final bool grande;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: EdgeInsets.all(grande ? 17 : 9),
        decoration: BoxDecoration(
          color: Colores.verde,
          borderRadius: BorderRadius.circular(grande ? 24 : 14),
        ),
        child: Icon(
          Icons.account_balance_wallet_outlined,
          size: grande ? 38 : 24,
          color: Colors.white,
        ),
      ),
      const SizedBox(width: 12),
      Text(
        'saldo',
        style: TextStyle(
          fontSize: grande ? 40 : 26,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.5,
        ),
      ),
    ],
  );
}

class Tarjeta extends StatelessWidget {
  const Tarjeta({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: padding, child: child),
  );
}

class Encabezado extends StatelessWidget {
  const Encabezado({
    super.key,
    required this.titulo,
    required this.subtitulo,
    this.accion,
  });
  final String titulo;
  final String subtitulo;
  final Widget? accion;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitulo,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        accion ?? const SizedBox.shrink(),
      ],
    ),
  );
}

class EtiquetaDemo extends StatelessWidget {
  const EtiquetaDemo({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 8),
    child: Text(
      'VISTA PREVIA · DATOS DE EJEMPLO',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 10,
        letterSpacing: 1.5,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}

class FilaMovimiento extends StatelessWidget {
  const FilaMovimiento({super.key, required this.movimiento, this.onTap});
  final Movimiento movimiento;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    final categoria = datos.categoria(movimiento.categoria);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: categoria.color.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(categoria.icono, color: categoria.color, size: 22),
      ),
      title: Text(
        movimiento.titulo,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        movimiento.categoria,
        style: const TextStyle(fontSize: 11),
      ),
      trailing: Text(
        datos.ocultarMontos
            ? '••••'
            : '${movimiento.esIngreso ? '+' : '-'}${dinero(movimiento.monto)}',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: movimiento.esIngreso
              ? Theme.of(context).colorScheme.primary
              : null,
        ),
      ),
      onTap:
          onTap ??
          () => Navigator.pushNamed(
            context,
            Rutas.edicion,
            arguments: movimiento,
          ),
    );
  }
}
