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
          for (final categoria in datos.categorias)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
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
                    '${datos.movimientos.where((m) => m.categoria == categoria.nombre).length} movimientos de muestra',
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
                    onPressed: () {
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
                      datos.agregarCategoria(
                        Categoria(nombre, _iconos[_icono], _colores[_color]),
                      );
                      _nombre.clear();
                      FocusScope.of(context).unfocus();
                      aviso(
                        context,
                        'Categoría agregada a la muestra. Guardado permanente pendiente.',
                      );
                    },
                    child: const Text('Crear categoría de muestra'),
                  ),
                ),
              ],
            ),
          ),
          const EtiquetaDemo(),
        ],
      ),
    );
  }
}
