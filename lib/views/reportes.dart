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
    final categorias =
        datos.categorias.where((c) => c.nombre != 'Ingreso').toList();

    final List<({String etiqueta, double monto})> serie = switch (_periodo) {
      'Trimestre' => datos
          .gastoTrimestral(trimestres: 3)
          .map(
            (e) => (
              etiqueta: _etiquetaTrimestre(e.trimestre),
              monto: e.monto,
            ),
          )
          .toList(),
      'Año' => datos
          .gastoAnual(anios: 3)
          .map((e) => (etiqueta: '${e.anio.year}', monto: e.monto))
          .toList(),
      _ => datos
          .gastoMensual(meses: 3)
          .map((e) => (etiqueta: mesCorto(e.mes), monto: e.monto))
          .toList(),
    };

    final valores = [for (final s in serie) s.monto];
    final etiquetas = [for (final s in serie) s.etiqueta];

    final ahora = DateTime.now();
    final diasMes = DateTime(ahora.year, ahora.month + 1, 0).day;
    final promedioDiario = diasMes == 0 ? 0.0 : datos.gastoMesActual / diasMes;

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
              Text(
                '${mesLargo(ahora)} · toca la gráfica para explorar',
                style: const TextStyle(fontSize: 11),
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
                _periodo == 'Mes'
                    ? 'Evolución mensual'
                    : 'Evolución por ${_periodo.toLowerCase()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Histórico real de tus movimientos',
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
                      'Promedio diario · ${mesLargoSinAnio(ahora)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      dinero(promedioDiario),
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
        const SizedBox(height: 16),
        // Comparativa mes actual vs anterior (#7)
        _ComparativaMensual(datos: datos),
      ],
    );
  }

  String _etiquetaTrimestre(DateTime inicioTrimestre) {
    final trimestre = ((inicioTrimestre.month - 1) ~/ 3) + 1;
    final anio = inicioTrimestre.year.toString().substring(2);
    return 'T$trimestre\'$anio';
  }
}

class _ComparativaMensual extends StatelessWidget {
  const _ComparativaMensual({required this.datos});
  final FinanzasProvider datos;

  @override
  Widget build(BuildContext context) {
    final actual = datos.gastoMesActual;
    final anterior = datos.gastoMesAnterior;
    final variacion =
        anterior <= 0 ? 0.0 : (actual - anterior) / anterior * 100;

    final Color color;
    final IconData icono;
    final String texto;
    if (anterior <= 0 && actual > 0) {
      color = Colores.azul;
      icono = Icons.insights_outlined;
      texto = 'Primer mes con gastos. Aún no hay comparación.';
    } else if (variacion > 5) {
      color = Colores.rojo;
      icono = Icons.trending_up;
      texto =
          'Gastaste ${variacion.toStringAsFixed(0)}% más que el mes anterior.';
    } else if (variacion < -5) {
      color = Colores.verde;
      icono = Icons.trending_down;
      texto =
          'Gastaste ${(-variacion).toStringAsFixed(0)}% menos que el mes anterior. ¡Bien!';
    } else {
      color = Colores.azul;
      icono = Icons.trending_flat;
      texto = 'Tu gasto es similar al mes anterior.';
    }

    return Tarjeta(
      child: Row(
        children: [
          Icon(icono, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comparativa mensual',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  texto,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Este mes: ${dinero(actual)} · Anterior: ${dinero(anterior)}',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
