import 'package:flutter/material.dart';

class WidgetMovements extends StatelessWidget {
  final EdgeInsets? padding;
  final double? borderRadius;
  final Color? colorIndicador;
  final String titulo;
  final String categoria;
  final DateTime fecha;
  final String monto;

  const WidgetMovements({
    super.key,
    this.padding,
    this.borderRadius,
    this.colorIndicador,
    required this.titulo,
    required this.categoria,
    required this.fecha,
    required this.monto,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: padding ?? const EdgeInsets.all(5),
      children: [
        ListTile(
          visualDensity: const VisualDensity(vertical: -4),

          leading: Icon(Icons.square_rounded, color: colorIndicador, size: 20),
          title: Text(
            titulo, // title espera tipo widget<Text>
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ), //
          subtitle: Text(
            '$categoria     ${fecha.day}/${fecha.month}',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          trailing: Text(
            monto.startsWith('-')
                ? '-\$${monto.substring(1)}'
                : '+\$${monto.replaceAll('+', '')}',
            style: TextStyle(
              color: monto.startsWith('-') ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
