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
          subtitulo: '${mesLargo(DateTime.now()).toUpperCase()} · TU RESUMEN',
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
                  style:
                      const TextStyle(color: Color(0xFFDCEAE3), fontSize: 12),
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

/// Gráfica de barras con datos reales. Barras proporcionales al máximo
/// del período, con headroom vertical para que la más alta no toque el techo.
class BarrasSemanales extends StatelessWidget {
  const BarrasSemanales({super.key});

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    final serie = datos.gastoDiario(dias: 7);
    final maxMonto = serie.fold<double>(0, (p, c) => c.monto > p ? c.monto : p);
    final hoy = DateTime.now();
    const letrasDia = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final colorVacio = Theme.of(context).colorScheme.surfaceContainerHighest;

    return SizedBox(
      height: 110, // sube de 94 a 110 para dar aire en la parte superior
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < serie.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Tooltip(
                      message: serie[i].monto <= 0
                          ? 'Sin gasto'
                          : 'Gasto: ${datos.ocultarMontos ? '••••' : dinero(serie[i].monto)}',
                      child: Container(
                        height: _alturaBarra(serie[i].monto, maxMonto),
                        decoration: BoxDecoration(
                          color: serie[i].monto <= 0
                              ? colorVacio
                              : (serie[i].dia.year == hoy.year &&
                                      serie[i].dia.month == hoy.month &&
                                      serie[i].dia.day == hoy.day
                                  ? Colores.verde
                                  : Colores.verde.withValues(alpha: 0.35)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      letrasDia[serie[i].dia.weekday - 1],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: serie[i].dia.day == hoy.day
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: serie[i].dia.day == hoy.day
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Altura proporcional al máximo. Deja ~20 px de aire en la parte superior
  /// (contenedor 110 px, gap 8 px, texto 14 px, barra máx. 68 px).
  double _alturaBarra(double monto, double maxMonto) {
    const minAltura = 6.0;
    const maxAltura = 68.0;
    if (monto <= 0 || maxMonto <= 0) return minAltura;
    final proporcion = (monto / maxMonto).clamp(0.0, 1.0);
    return minAltura + proporcion * (maxAltura - minAltura);
  }
}
