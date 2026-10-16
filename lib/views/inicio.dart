import 'package:flutter/material.dart';

import '../widgets/widget_card.dart';
import '../widgets/widget_movements.dart';
import '../widgets/widget_graph.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Inicio'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SEPTIEMBRE 2026',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Hola, David',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFD8EFE3),
                  child: Text(
                    'DV',
                    style: TextStyle(
                      color: Color(0xFF1E7051),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFF18191B),
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BALANCE DEL MES',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '\$4,280',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '.50',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: WidgetCard(
                          width: double.infinity,
                          colorBackground: Color(0xFF26272B),
                          colorIndicador: Color(0xFF2FA275),
                          colorTitulo: Colors.grey,
                          colorMonto: Colors.white,
                          titulo: 'Ingresos',
                          monto: '\$9,500.00',
                        ),
                      ),

                      SizedBox(width: 12),

                      Expanded(
                        child: WidgetCard(
                          width: double.infinity,
                          colorBackground: Color(0xFF26272B),
                          colorIndicador: Color(0xFFE57373),
                          colorTitulo: Colors.grey,
                          colorMonto: Colors.white,
                          titulo: 'Gastos',
                          monto: '\$5,219.50',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gasto diario',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'últimos 7 días',
                  style: TextStyle(fontSize: 13.0, color: Colors.grey),
                ),
              ],
            ),
            const WidgetGraph(
              valores: [400.0, 850.0, 300.0, 1200.0, 700.0, 250.0, 100.0],
              dias: ['L', 'M', 'M', 'J', 'V', 'S', 'D'],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ultimos Movimientos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Ver todo',
                    style: TextStyle(
                      color: Color(0xFF2FA275),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            WidgetMovements(
              titulo: 'Super de la semana',
              categoria: 'Alimentacion',
              fecha: DateTime(2026, 12, 25),
              colorIndicador: Colors.orange,
              monto: '-742',
            ),

            WidgetMovements(
              titulo: 'Beca Escolar',
              categoria: 'Ingreso',
              fecha: DateTime(2026, 12, 10),
              colorIndicador: Colors.green,
              monto: '5000',
            ),
          ],
        ),
      ),
    );
  }
}
