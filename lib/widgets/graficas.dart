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
  Widget build(BuildContext context) => SizedBox(
    height: 180,
    child: PieChart(
      PieChartData(
        centerSpaceRadius: 48,
        sectionsSpace: 4,
        sections: [
          for (var i = 0; i < widget.valores.length; i++)
            PieChartSectionData(
              value: widget.valores[i],
              color: widget.colores[i],
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

class GraficaMensual extends StatelessWidget {
  const GraficaMensual({
    super.key,
    required this.valores,
    required this.etiquetas,
  });
  final List<double> valores;
  final List<String> etiquetas;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 165,
    child: BarChart(
      BarChartData(
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
              getTitlesWidget: (valor, meta) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  etiquetas[valor.toInt()],
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < valores.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: valores[i],
                  width: 27,
                  color: i == valores.length - 1
                      ? Colores.verde
                      : Colores.verde.withValues(alpha: 0.22),
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
