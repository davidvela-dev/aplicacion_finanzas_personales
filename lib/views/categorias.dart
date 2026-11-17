import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/tema.dart';
import '../models/categoria.dart';
import '../viewmodels/finanzas_provider.dart';
import '../widgets/componentes.dart';

class CategoriasView extends StatefulWidget {
  const CategoriasView({super.key});
  @override
  State<CategoriasView> createState() => _CategoriasViewState();
}

class _CategoriasViewState extends State<CategoriasView> {
  final _nombre = TextEditingController();
  int _color = 0;
  int _icono = 0;
  final _colores = [
    Colores.naranja,
    Colores.verde,
    Colores.azul,
    Colores.morado,
    Colores.rojo,
  ];
  final _iconos = [
    Icons.shopping_bag_outlined,
    Icons.pets_outlined,
    Icons.sports_esports_outlined,
    Icons.local_cafe_outlined,
    Icons.favorite_outline,
  ];

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  Future<bool> _confirmarEliminar(Categoria categoria) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar categoría?'),
        content: Text(
          'Se eliminará "${categoria.nombre}" y su presupuesto asociado. '
          'Los movimientos existentes no se borrarán.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    return ok == true;
  }

  Future<void> _eliminar(Categoria categoria) async {
    final id = categoria.id;
    if (id == null) {
      aviso(context, 'No se puede eliminar: falta el id.');
      return;
    }
    final datos = context.read<FinanzasProvider>();
    try {
      await datos.eliminarCategoria(id);
      if (!mounted) return;
      aviso(context, 'Categoría eliminada.');
    } catch (e) {
      if (!mounted) return;
      aviso(context, 'No se pudo eliminar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Encabezado(
            titulo: 'Todo en su lugar.',
            subtitulo:
                '${datos.categorias.length} categorías para organizarte.',
          ),
          if (datos.categorias.isEmpty)
            const Tarjeta(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No tienes categorías todavía.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          for (final categoria in datos.categorias)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Dismissible(
                key: ValueKey(categoria.id ?? categoria.nombre),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: Colores.rojo,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                confirmDismiss: (_) => _confirmarEliminar(categoria),
                onDismissed: (_) => _eliminar(categoria),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: categoria.color.withValues(alpha: 0.13),
                      child: Icon(categoria.icono, color: categoria.color),
                    ),
                    title: Text(
                      categoria.nombre,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${datos.movimientos.where((m) => m.categoria == categoria.nombre).length} movimientos',
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colores.rojo,
                      ),
                      tooltip: 'Eliminar categoría',
                      onPressed: () async {
                        final ok = await _confirmarEliminar(categoria);
                        if (ok) await _eliminar(categoria);
                      },
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 18),
          Tarjeta(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nueva categoría',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _nombre,
                  maxLength: 24,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la categoría',
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Color e icono', style: TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    for (var i = 0; i < _colores.length; i++)
                      ChoiceChip(
                        label: const Text(''),
                        avatar: CircleAvatar(
                          backgroundColor: _colores[i],
                          radius: 10,
                        ),
                        selected: _color == i,
                        showCheckmark: false,
                        tooltip: [
                          'Naranja',
                          'Verde',
                          'Azul',
                          'Morado',
                          'Rojo',
                        ][i],
                        onSelected: (_) => setState(() => _color = i),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    for (var i = 0; i < _iconos.length; i++)
                      IconButton(
                        tooltip: [
                          'Compras',
                          'Mascotas',
                          'Juegos',
                          'Café',
                          'Salud',
                        ][i],
                        isSelected: _icono == i,
                        onPressed: () => setState(() => _icono = i),
                        icon: Icon(_iconos[i]),
                        selectedIcon: Icon(
                          _iconos[i],
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      final nombre = _nombre.text.trim();
                      if (nombre.isEmpty) {
                        aviso(context, 'Escribe un nombre para la categoría.');
                        return;
                      }
                      if (datos.categorias.any(
                        (c) => c.nombre.toLowerCase() == nombre.toLowerCase(),
                      )) {
                        aviso(context, 'Esta categoría ya existe.');
                        return;
                      }
                      final nueva = Categoria(
                        nombre: nombre,
                        icono: _iconos[_icono],
                        color: _colores[_color],
                      );

                      try {
                        await datos.agregarCategoria(nueva);
                        if (!context.mounted) return;

                        _nombre.clear();
                        FocusScope.of(context).unfocus();
                        aviso(context, 'Categoría "$nombre" creada.');
                      } catch (e) {
                        if (!context.mounted) return;
                        aviso(context, 'No se pudo crear: $e');
                      }
                    },
                    child: const Text('Crear categoría'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
