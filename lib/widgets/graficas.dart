import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants/tema.dart';

class GraficaDistribucion extends StatefulWidget {
  const GraficaDistribucion({
    super.key,
    required this.valores,
    required this.colores,
  });
  final List<double> valores;
  final List<Color> colores;
  @override
  State<GraficaDistribucion> createState() => _GraficaDistribucionState();
}

class _GraficaDistribucionState extends State<GraficaDistribucion> {
  int _seleccion = -1;

  @override
  Widget build(BuildContext context) {
    final total = widget.valores.fold<double>(0, (a, b) => a + b);
    if (total <= 0) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Container(
            width: 144,
            height: 144,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Center(
              child: Text(
                'Sin datos\nen el periodo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final colorVacio = Theme.of(context).colorScheme.surfaceContainerHighest;

    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 48,
          sectionsSpace: 4,
          sections: [
            for (var i = 0; i < widget.valores.length; i++)
              PieChartSectionData(
                value: widget.valores[i] > 0 ? widget.valores[i] : 0,
                color: widget.valores[i] > 0
                    ? widget.colores[i]
                    : colorVacio.withValues(alpha: 0.4),
                radius: i == _seleccion ? 34 : 27,
                showTitle: false,
              ),
          ],
          pieTouchData: PieTouchData(
            touchCallback: (evento, respuesta) {
              setState(() {
                _seleccion = evento.isInterestedForInteractions
                    ? respuesta?.touchedSection?.touchedSectionIndex ?? -1
                    : -1;
              });
            },
          ),
        ),
      ),
    );
  }
}

class GraficaMensual extends StatelessWidget {
  const GraficaMensual({
    super.key,
    required this.valores,
    required this.etiquetas,
  });
  final List<double> valores;
  final List<String> etiquetas;

  @override
  Widget build(BuildContext context) {
    final colorVacio = Theme.of(context).colorScheme.surfaceContainerHighest;

    final maxValue =
        valores.isEmpty ? 0.0 : valores.reduce((a, b) => a > b ? a : b);
    // 15 % de aire sobre la barra más alta; 10 si todo está en cero.
    final maxY = maxValue <= 0 ? 10.0 : maxValue * 1.15;

    return SizedBox(
      height: 165,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (valor, meta) {
                  final i = valor.toInt();
                  if (i < 0 || i >= etiquetas.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      etiquetas[i],
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < valores.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: valores[i] > 0 ? valores[i] : 0,
                    width: 27,
                    color: valores[i] <= 0
                        ? colorVacio
                        : (i == valores.length - 1
                            ? Colores.verde
                            : Colores.verde.withValues(alpha: 0.35)),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(7),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
