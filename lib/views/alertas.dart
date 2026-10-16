import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/tema.dart';
import '../viewmodels/finanzas_provider.dart';
import '../widgets/componentes.dart';

class AlertasView extends StatelessWidget {
  const AlertasView({super.key});
  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    final alertas = [
      (
        'Revisa Entretenimiento',
        'El gasto de muestra es ${dinero(datos.gastoCategoria('Entretenimiento'))} de un límite de ${dinero(datos.presupuestos['Entretenimiento']!)}.',
        Icons.movie_outlined,
        Colores.morado,
      ),
      (
        'Cuida tu alimentación',
        'Has usado ${(datos.gastoCategoria('Alimentación') / datos.presupuestos['Alimentación']! * 100).round()}% del presupuesto de Alimentación.',
        Icons.restaurant_outlined,
        Colores.naranja,
      ),
      (
        'Tu resumen está listo',
        'En Reportes puedes revisar la distribución de tus gastos.',
        Icons.insights_outlined,
        Colores.verde,
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Alertas')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Encabezado(
            titulo: 'Un aviso a tiempo.',
            subtitulo:
                '${3 - datos.alertasLeidas.length} sin leer · alertas de muestra',
          ),
          for (var i = 0; i < alertas.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: alertas[i].$4.withValues(alpha: 0.13),
                    child: Icon(alertas[i].$3, color: alertas[i].$4),
                  ),
                  title: Text(
                    alertas[i].$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      alertas[i].$2,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  trailing: Icon(
                    datos.alertasLeidas.contains(i) ? Icons.done : Icons.circle,
                    size: datos.alertasLeidas.contains(i) ? 18 : 8,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () {
                    datos.leerAlerta(i);
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
                  subtitle: const Text('Preferencia de muestra'),
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
                  subtitle: const Text(
                    'Todos los días a las 21:00 · vista previa',
                  ),
                  value: datos.recordatorio,
                  onChanged: (v) {
                    datos.cambiarRecordatorio(v);
                    if (v) {
                      mostrarPendiente(
                        context,
                        'Recordatorio de captura',
                        'Aquí se programará una notificación local a las 21:00. El interruptor solo modifica la preferencia visual.',
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Las notificaciones del dispositivo se integrarán en la siguiente etapa.',
            style: TextStyle(fontSize: 12),
          ),
          const EtiquetaDemo(),
        ],
      ),
    );
  }
}
