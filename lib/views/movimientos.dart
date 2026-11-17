import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/rutas.dart';
import '../constants/tema.dart';
import '../models/movimiento.dart';
import '../viewmodels/finanzas_provider.dart';
import '../widgets/componentes.dart';

class MovimientosView extends StatefulWidget {
  const MovimientosView({super.key});
  @override
  State<MovimientosView> createState() => _MovimientosViewState();
}

class _MovimientosViewState extends State<MovimientosView> {
  String _filtro = 'Todos';
  String _busqueda = '';

  Future<bool> _confirmarEliminar(Movimiento m) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar movimiento?'),
        content: Text('Se borrará "${m.titulo}" permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    return ok == true;
  }

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    final lista = datos.movimientos
        .where(
          (m) =>
              (_filtro == 'Todos' ||
                  (_filtro == 'Ingresos' ? m.esIngreso : !m.esIngreso)) &&
              '${m.titulo} ${m.categoria}'.toLowerCase().contains(
                    _busqueda.toLowerCase(),
                  ),
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 86),
      children: [
        Encabezado(
          titulo: 'Movimientos',
          subtitulo: 'Tu dinero tiene una historia.',
          accion: IconButton(
            tooltip: 'Gestionar categorías',
            onPressed: () => Navigator.pushNamed(context, Rutas.categorias),
            icon: const Icon(Icons.category_outlined),
          ),
        ),
        TextField(
          onChanged: (v) => setState(() => _busqueda = v),
          decoration: const InputDecoration(
            hintText: 'Buscar un movimiento',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            for (final filtro in ['Todos', 'Gastos', 'Ingresos'])
              ChoiceChip(
                label: Text(filtro),
                selected: _filtro == filtro,
                onSelected: (_) => setState(() => _filtro = filtro),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          '${mesLargo(DateTime.now()).toUpperCase()} · ${lista.length} MOVIMIENTOS',
          style: const TextStyle(fontSize: 10, letterSpacing: 1.2),
        ),
        const SizedBox(height: 12),
        if (lista.isEmpty)
          const Tarjeta(
            child: Column(
              children: [
                Icon(Icons.search_off, size: 38),
                SizedBox(height: 12),
                Text('No hay movimientos con este filtro.'),
              ],
            ),
          ),
        for (final movimiento in lista)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Dismissible(
              key: ValueKey(movimiento.id ?? movimiento.hashCode),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                decoration: BoxDecoration(
                  color: Colores.rojo,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
              confirmDismiss: (_) => _confirmarEliminar(movimiento),
              onDismissed: (_) async {
                final id = movimiento.id;
                if (id == null) return;
                try {
                  await datos.eliminarMovimiento(id);
                  if (context.mounted) {
                    aviso(context, 'Movimiento eliminado.');
                  }
                } catch (e) {
                  if (context.mounted) {
                    aviso(context, 'No se pudo eliminar: $e');
                  }
                }
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Text(
                        fechaLarga(movimiento.fecha).toUpperCase(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    FilaMovimiento(movimiento: movimiento),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
