import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/tema.dart';
import '../viewmodels/finanzas_provider.dart';
import '../widgets/componentes.dart';
import '../widgets/graficas.dart';

class ReportesView extends StatefulWidget {
  const ReportesView({super.key});
  @override
  State<ReportesView> createState() => _ReportesViewState();
}

class _ReportesViewState extends State<ReportesView> {
  String _periodo = 'Mes';
  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    final categorias = datos.categorias
        .where((c) => c.nombre != 'Ingreso')
        .toList();
    final esMes = _periodo == 'Mes';
    final valores = esMes
        ? [4100.0, 4684.0, datos.gastos]
        : _periodo == 'Trimestre'
        ? [11800.0, 13200.0, 14003.0]
        : [42000.0, 48500.0, 51200.0];
    final etiquetas = esMes
        ? ['Jul', 'Ago', 'Sep']
        : _periodo == 'Trimestre'
        ? ['Ene–Mar', 'Abr–Jun', 'Jul–Sep']
        : ['2024', '2025', '2026'];
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Encabezado(
          titulo: 'Reportes',
          subtitulo: 'Conoce tus hábitos, paso a paso.',
          accion: IconButton(
            tooltip: 'Exportar historial',
            onPressed: () => mostrarPendiente(
              context,
              'Exportar historial',
              'Se generará un archivo CSV con los movimientos del periodo seleccionado.',
            ),
            icon: const Icon(Icons.ios_share),
          ),
        ),
        Wrap(
          spacing: 10,
          children: [
            for (final periodo in ['Mes', 'Trimestre', 'Año'])
              ChoiceChip(
                label: Text(periodo),
                selected: _periodo == periodo,
                onSelected: (_) => setState(() => _periodo = periodo),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Tarjeta(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Distribución de gastos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              const Text(
                'Septiembre · toca la gráfica para explorar',
                style: TextStyle(fontSize: 11),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  GraficaDistribucion(
                    valores: [
                      for (final c in categorias)
                        datos.gastoCategoria(c.nombre),
                    ],
                    colores: [for (final c in categorias) c.color],
                  ),
                  IgnorePointer(
                    child: Column(
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(fontSize: 9, letterSpacing: 1.5),
                        ),
                        Text(
                          dinero(datos.gastos),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              for (final c in categorias)
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: c.color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          c.nombre,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                        '${datos.gastos == 0 ? 0 : (datos.gastoCategoria(c.nombre) / datos.gastos * 100).round()}%',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Tarjeta(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                esMes
                    ? 'Evolución mensual'
                    : 'Evolución por ${_periodo.toLowerCase()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Histórico ilustrativo de la muestra',
                style: TextStyle(fontSize: 11),
              ),
              const SizedBox(height: 20),
              GraficaMensual(valores: valores, etiquetas: etiquetas),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Tarjeta(
          child: Row(
            children: [
              const Icon(Icons.insights_outlined, color: Colores.verde),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Promedio diario · septiembre',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      dinero(datos.gastos / 30),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const EtiquetaDemo(),
      ],
    );
  }
}
