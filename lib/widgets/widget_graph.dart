import 'package:flutter/material.dart';

class WidgetGraph extends StatelessWidget {
  final List<double> valores;
  final List<String> dias;

  const WidgetGraph({super.key, required this.valores, required this.dias});

  @override
  Widget build(BuildContext context) {
    final double valorMaximo = valores.isEmpty
        ? 1.0
        : valores.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),

          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(valores.length, (index) {
                final double alturaProporcional = valorMaximo == 0
                    ? 15.0 // altura minima
                    : (valores[index] / valorMaximo) * 80.0;

                // valor destacado en otro color
                final bool esDestacado = valores[index] == valorMaximo;
                return Container(
                  width: 28,
                  height: alturaProporcional < 15 ? 15 : alturaProporcional,
                  decoration: BoxDecoration(
                    color: esDestacado
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFC8E6C9),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dias.map((dia) {
              return SizedBox(
                width: 28,
                child: Text(
                  dia,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
