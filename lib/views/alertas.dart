import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/tema.dart';
import '../viewmodels/finanzas_provider.dart';
import '../widgets/componentes.dart';

class _Alerta {
  final String id;
  final String titulo;
  final String detalle;
  final IconData icono;
  final Color color;
  const _Alerta(this.id, this.titulo, this.detalle, this.icono, this.color);
}

class AlertasView extends StatelessWidget {
  const AlertasView({super.key});

  List<_Alerta> _construirAlertas(FinanzasProvider datos) {
    final alertas = <_Alerta>[];

    // 1) Comparativa mes actual vs mes anterior (#7)
    final actual = datos.gastoMesActual;
    final anterior = datos.gastoMesAnterior;
    if (anterior > 0) {
      final variacion = (actual - anterior) / anterior * 100;
      if (variacion > 10) {
        alertas.add(
          _Alerta(
            'mes_mas_gasto',
            'Gastaste ${variacion.toStringAsFixed(0)}% más este mes',
            'Llevas ${dinero(actual)} este mes vs ${dinero(anterior)} el anterior.',
            Icons.trending_up,
            Colores.rojo,
          ),
        );
      } else if (variacion < -10) {
        alertas.add(
          _Alerta(
            'mes_menos_gasto',
            'Gastaste ${(-variacion).toStringAsFixed(0)}% menos este mes',
            'Llevas ${dinero(actual)} este mes vs ${dinero(anterior)} el anterior. ¡Buen ritmo!',
            Icons.trending_down,
            Colores.verde,
          ),
        );
      } else if (actual > 0) {
        alertas.add(
          _Alerta(
            'mes_similar',
            'Gasto similar al mes anterior',
            'Este mes ${dinero(actual)}, el anterior ${dinero(anterior)}.',
            Icons.trending_flat,
            Colores.azul,
          ),
        );
      }
    } else if (actual > 0) {
      alertas.add(
        _Alerta(
          'primer_mes',
          'Primer mes con gastos registrados',
          'Aún no hay mes anterior para comparar. Este mes llevas ${dinero(actual)}.',
          Icons.insights_outlined,
          Colores.azul,
        ),
      );
    }

    // 2) Alertas por presupuesto (#6: solo si el usuario las habilitó)
    if (datos.avisarLimite) {
      for (final entry in datos.presupuestos.entries) {
        final cat = entry.key;
        final limite = entry.value;
        if (limite <= 0) continue;
        final gasto = datos.gastoCategoria(cat);
        final pct = gasto / limite * 100;
        final icono = datos.categoria(cat)?.icono ??
            Icons.account_balance_wallet_outlined;
        if (pct >= 100) {
          alertas.add(
            _Alerta(
              'presupuesto_excedido_$cat',
              'Excediste el presupuesto de $cat',
              'Gastaste ${dinero(gasto)} de ${dinero(limite)} '
                  '(${pct.toStringAsFixed(0)}%).',
              icono,
              Colores.rojo,
            ),
          );
        } else if (pct >= datos.umbral) {
          alertas.add(
            _Alerta(
              'presupuesto_umbral_$cat',
              'Presupuesto de $cat al ${pct.toStringAsFixed(0)}%',
              'Llevas ${dinero(gasto)} de ${dinero(limite)}.',
              icono,
              Colores.naranja,
            ),
          );
        }
      }
    }

    // 3) Estado vacío
    if (datos.movimientos.isEmpty) {
      alertas.add(
        const _Alerta(
          'sin_movimientos',
          'Aún no hay movimientos',
          'Agrega tu primer movimiento para empezar a ver alertas personalizadas.',
          Icons.info_outline,
          Colores.azul,
        ),
      );
    }

    return alertas;
  }

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    final alertas = _construirAlertas(datos);
    final sinLeer =
        alertas.where((a) => !datos.alertasLeidas.contains(a.id)).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Alertas')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Encabezado(
            titulo: 'Un aviso a tiempo.',
            subtitulo: '$sinLeer sin leer',
          ),
          for (final alerta in alertas)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: alerta.color.withValues(alpha: 0.13),
                    child: Icon(alerta.icono, color: alerta.color),
                  ),
                  title: Text(
                    alerta.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      alerta.detalle,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  trailing: Icon(
                    datos.alertasLeidas.contains(alerta.id)
                        ? Icons.done
                        : Icons.circle,
                    size: datos.alertasLeidas.contains(alerta.id) ? 18 : 8,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {
                    datos.leerAlerta(alerta.id);
                    aviso(context, 'Alerta marcada como leída.');
                  },
                ),
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            'PREFERENCIAS',
            style: TextStyle(fontSize: 11, letterSpacing: 1.3),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text(
                    'Aviso al acercarse al límite',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: datos.avisarLimite,
                  onChanged: datos.cambiarAviso,
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Umbral de aviso'),
                      Text(
                        '${datos.umbral.round()}%',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Slider(
                  value: datos.umbral,
                  min: 50,
                  max: 100,
                  divisions: 10,
                  label: '${datos.umbral.round()}%',
                  onChanged: datos.avisarLimite ? datos.cambiarUmbral : null,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text(
                    'Recordatorio diario',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: datos.recordatorio,
                  onChanged: datos.cambiarRecordatorio,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
