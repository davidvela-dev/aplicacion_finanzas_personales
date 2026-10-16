import 'package:flutter/material.dart';

class WidgetCard extends StatelessWidget {
  final Color? colorBackground;
  final String titulo;
  final String monto;
  final Color? colorIndicador;
  final Color? colorTitulo;
  final Color? colorMonto;
  final double? width;
  final double? height;

  const WidgetCard({
    super.key,
    this.colorBackground,
    required this.titulo,
    required this.monto,
    this.colorIndicador,
    this.colorMonto,
    this.colorTitulo,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 180.0,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // operador de expansion ... para dibujar List<Widget>
              if (colorIndicador != null) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorIndicador,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
              ],

              Text(
                titulo,
                style: TextStyle(
                  color: colorMonto ?? Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            monto,
            style: TextStyle(
              color: colorMonto ?? Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
