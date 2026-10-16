import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/tema.dart';
import '../viewmodels/finanzas_provider.dart';
import '../widgets/componentes.dart';

Future<void> editarPresupuesto(
  BuildContext context, {
  String? categoriaActual,
}) async {
  final datos = context.read<FinanzasProvider>();
  var categoria = categoriaActual ?? datos.categorias.first.nombre;
  final controlador = TextEditingController(
    text: categoriaActual == null
        ? ''
        : datos.presupuestos[categoria]?.toStringAsFixed(0),
  );
  final formulario = GlobalKey<FormState>();
  await showDialog<void>(
    context: context,
    builder: (dialogo) => StatefulBuilder(
      builder: (context, actualizar) => AlertDialog(
        title: Text(
          categoriaActual == null ? 'Nuevo presupuesto' : 'Ajustar presupuesto',
        ),
        content: Form(
          key: formulario,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: categoria,
                isExpanded: true,
                items: [
                  for (final c in datos.categorias.where(
                    (c) => c.nombre != 'Ingreso',
                  ))
                    DropdownMenuItem(value: c.nombre, child: Text(c.nombre)),
                ],
                onChanged: (v) => actualizar(() => categoria = v!),
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: controlador,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Límite mensual',
                  prefixText: '\$ ',
                ),
                validator: (v) {
                  final n = double.tryParse((v ?? '').replaceAll(',', '.'));
                  return n == null || !n.isFinite || n <= 0
                      ? 'Escribe un monto mayor que cero'
                      : null;
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'El límite se aplica a la muestra de esta sesión.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogo),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (!formulario.currentState!.validate()) return;
              datos.guardarPresupuesto(
                categoria,
                double.parse(controlador.text.replaceAll(',', '.')),
              );
              Navigator.pop(dialogo);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    ),
  );
  // El controlador se libera después de que termina la transición del diálogo.
  await Future<void>.delayed(const Duration(milliseconds: 300));
  controlador.dispose();
}

class PresupuestosView extends StatelessWidget {
  const PresupuestosView({super.key});
  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    final porcentaje = datos.limiteTotal == 0
        ? 0.0
        : datos.gastos / datos.limiteTotal;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Encabezado(
          titulo: 'Presupuestos',
          subtitulo: 'Un plan para gastar con tranquilidad.',
          accion: IconButton(
            tooltip: 'Nuevo presupuesto',
            onPressed: () => editarPresupuesto(context),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ),
        Tarjeta(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LÍMITE TOTAL · SEPTIEMBRE',
                      style: TextStyle(fontSize: 10, letterSpacing: 1),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      dinero(datos.gastos),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'de ${dinero(datos.limiteTotal)}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: porcentaje.clamp(0.0, 1.0),
                        strokeWidth: 7,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                      ),
                    ),
                    Text(
                      '${(porcentaje * 100).round()}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        for (final entrada in datos.presupuestos.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _Presupuesto(nombre: entrada.key, limite: entrada.value),
          ),
        const EtiquetaDemo(),
      ],
    );
  }
}

class _Presupuesto extends StatelessWidget {
  const _Presupuesto({required this.nombre, required this.limite});
  final String nombre;
  final double limite;
  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    final categoria = datos.categoria(nombre);
    final gasto = datos.gastoCategoria(nombre);
    final excedido = gasto > limite;
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => editarPresupuesto(context, categoriaActual: nombre),
      child: Tarjeta(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(categoria.icono, size: 19, color: categoria.color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    nombre,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const Icon(Icons.edit_outlined, size: 16),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${dinero(gasto)} / ${dinero(limite)}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: (gasto / limite).clamp(0.0, 1.0),
              color: excedido ? Colores.rojo : categoria.color,
              minHeight: 7,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
            ),
            const SizedBox(height: 10),
            Text(
              excedido
                  ? 'Excedido por ${dinero(gasto - limite)}'
                  : '${(gasto / limite * 100).round()}% usado · disponible ${dinero(limite - gasto)}',
              style: TextStyle(
                fontSize: 11,
                color: excedido
                    ? Colores.rojo
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
