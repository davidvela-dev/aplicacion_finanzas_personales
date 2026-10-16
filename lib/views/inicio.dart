import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/tema.dart';
import '../viewmodels/finanzas_provider.dart';
import '../widgets/componentes.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key, this.onVerTodo});
  final VoidCallback? onVerTodo;

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    String monto(double valor) => datos.ocultarMontos ? '••••' : dinero(valor);
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 86),
      children: [
        Encabezado(
          titulo: 'Hola, ${datos.nombre}',
          subtitulo: 'SEPTIEMBRE 2026 · TU RESUMEN',
          accion: IconButton(
            tooltip: datos.ocultarMontos ? 'Mostrar montos' : 'Ocultar montos',
            onPressed: () => datos.cambiarPrivacidad(!datos.ocultarMontos),
            icon: Icon(
              datos.ocultarMontos
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colores.oscuro,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Color(0xFF97D8BE),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'BALANCE DEL MES',
                    style: TextStyle(
                      color: Color(0xFFB4D3C7),
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  monto(datos.balance),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 43,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.8,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Cada pequeño paso cuenta.',
                style: TextStyle(color: Color(0xFFB4D3C7), fontSize: 12),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _Resumen(
                      titulo: 'Ingresos',
                      monto: monto(datos.ingresos),
                      icono: Icons.south_west,
                      color: const Color(0xFF92DEBD),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _Resumen(
                      titulo: 'Gastos',
                      monto: monto(datos.gastos),
                      icono: Icons.north_east,
                      color: const Color(0xFFF1BBA1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Gasto diario',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            Text('Últimos 7 días', style: TextStyle(fontSize: 11)),
          ],
        ),
        const SizedBox(height: 16),
        const Tarjeta(child: BarrasSemanales()),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Últimos movimientos',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ),
            TextButton(onPressed: onVerTodo, child: const Text('Ver todo')),
          ],
        ),
        Card(
          child: Column(
            children: [
              for (final movimiento in datos.movimientos.take(3))
                FilaMovimiento(movimiento: movimiento),
            ],
          ),
        ),
        const EtiquetaDemo(),
      ],
    );
  }
}

class _Resumen extends StatelessWidget {
  const _Resumen({
    required this.titulo,
    required this.monto,
    required this.icono,
    required this.color,
  });
  final String titulo;
  final String monto;
  final IconData icono;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icono, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              titulo,
              style: const TextStyle(color: Color(0xFFDCEAE3), fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FittedBox(
          child: Text(
            monto,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

class BarrasSemanales extends StatelessWidget {
  const BarrasSemanales({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 94,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Tooltip(
                    message:
                        'Gasto de ejemplo: ${dinero([160.0, 240.0, 110.0, 300.0, 190.0, 85.0, 35.0][i])}',
                    child: Container(
                      height: [36.0, 56.0, 25.0, 70.0, 44.0, 20.0, 10.0][i],
                      decoration: BoxDecoration(
                        color: i == 3
                            ? Colores.verde
                            : Colores.verde.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ['L', 'M', 'M', 'J', 'V', 'S', 'D'][i],
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}
