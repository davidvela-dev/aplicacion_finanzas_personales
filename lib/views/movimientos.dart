import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/rutas.dart';
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
          'SEPTIEMBRE 2026 · ${lista.length} MOVIMIENTOS',
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
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Text(
                      '${movimiento.fecha.day} SEP 2026',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  FilaMovimiento(movimiento: movimiento),
                ],
              ),
            ),
          ),
        const EtiquetaDemo(),
      ],
    );
  }
}
