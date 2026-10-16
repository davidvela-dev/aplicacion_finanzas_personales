import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/rutas.dart';
import '../models/movimiento.dart';
import '../viewmodels/finanzas_provider.dart';
import '../widgets/componentes.dart';

class EdicionView extends StatefulWidget {
  const EdicionView({super.key});
  @override
  State<EdicionView> createState() => _EdicionViewState();
}

class _EdicionViewState extends State<EdicionView> {
  final _formulario = GlobalKey<FormState>();
  final _monto = TextEditingController();
  final _nota = TextEditingController();
  bool _esIngreso = false;
  String _categoria = 'Alimentación';
  DateTime _fecha = DateTime(2026, 9, 3);
  Movimiento? _anterior;
  bool _cargado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cargado) return;
    _anterior = ModalRoute.of(context)?.settings.arguments as Movimiento?;
    final anterior = _anterior;
    if (anterior != null) {
      _monto.text = anterior.monto.toStringAsFixed(2);
      _nota.text = anterior.titulo;
      _categoria = anterior.categoria;
      _fecha = anterior.fecha;
      _esIngreso = anterior.esIngreso;
    }
    _cargado = true;
  }

  @override
  void dispose() {
    _monto.dispose();
    _nota.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formulario.currentState!.validate()) return;
    context.read<FinanzasProvider>().guardarMovimiento(
      Movimiento(
        titulo: _nota.text.trim(),
        categoria: _esIngreso ? 'Ingreso' : _categoria,
        monto: double.parse(_monto.text.replaceAll(',', '.')),
        fecha: _fecha,
        esIngreso: _esIngreso,
      ),
      anterior: _anterior,
    );
    Navigator.pop(context);
    aviso(
      context,
      'Movimiento actualizado en la muestra. El guardado permanente está pendiente.',
    );
  }

  Future<void> _borrar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar movimiento?'),
        content: const Text(
          'Se quitará de los datos de muestra de esta sesión.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true || !mounted) return;
    context.read<FinanzasProvider>().eliminarMovimiento(_anterior!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _anterior == null ? 'Nuevo movimiento' : 'Editar movimiento',
        ),
        actions: [
          if (_anterior != null)
            IconButton(
              tooltip: 'Eliminar movimiento',
              onPressed: _borrar,
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 12, 24, 12),
        child: FilledButton.icon(
          onPressed: _guardar,
          icon: const Icon(Icons.check),
          label: const Text('Guardar en la muestra'),
        ),
      ),
      body: Form(
        key: _formulario,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Cada movimiento cuenta.',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Regístralo para tener una vista más clara.'),
            const SizedBox(height: 24),
            Row(
              children: [
                for (final ingreso in [false, true])
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(ingreso ? 'Ingreso' : 'Gasto'),
                        selected: _esIngreso == ingreso,
                        onSelected: (_) => setState(() => _esIngreso = ingreso),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              key: const ValueKey('monto'),
              controller: _monto,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'Monto en MXN',
                prefixText: '\$ ',
              ),
              validator: (v) {
                final monto = double.tryParse((v ?? '').replaceAll(',', '.'));
                return monto == null || !monto.isFinite || monto <= 0
                    ? 'Escribe un monto mayor que cero'
                    : null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'CATEGORÍA',
              style: TextStyle(fontSize: 11, letterSpacing: 1.4),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final categoria in datos.categorias.where(
                  (c) => _esIngreso
                      ? c.nombre == 'Ingreso'
                      : c.nombre != 'Ingreso',
                ))
                  ChoiceChip(
                    avatar: Icon(
                      categoria.icono,
                      size: 17,
                      color: categoria.color,
                    ),
                    label: Text(categoria.nombre),
                    selected: _esIngreso || _categoria == categoria.nombre,
                    onSelected: (_) =>
                        setState(() => _categoria = categoria.nombre),
                  ),
                ActionChip(
                  label: const Text('+ Nueva'),
                  onPressed: () =>
                      Navigator.pushNamed(context, Rutas.categorias),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Tarjeta(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('Fecha'),
                subtitle: Text('${_fecha.day}/${_fecha.month}/${_fecha.year}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final fecha = await showDatePicker(
                    context: context,
                    initialDate: _fecha,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (fecha != null && mounted) setState(() => _fecha = fecha);
                },
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              key: const ValueKey('nota'),
              controller: _nota,
              maxLength: 60,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ej. Café con amigos',
                prefixIcon: Icon(Icons.edit_note),
              ),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? 'Agrega una descripción' : null,
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            const EtiquetaDemo(),
          ],
        ),
      ),
    );
  }
}
