import 'package:flutter/material.dart';

import '../widgets/componentes.dart';

class SubirView extends StatefulWidget {
  const SubirView({super.key});
  @override
  State<SubirView> createState() => _SubirViewState();
}

class _SubirViewState extends State<SubirView> {
  String _formato = 'PDF';
  bool _ejemplo = false;
  bool _conciliado = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Estados de cuenta')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Encabezado(
          titulo: 'Menos captura.\nMás claridad.',
          subtitulo: 'Una idea para el siguiente paso de Saldo.',
        ),
        Tarjeta(
          child: Column(
            children: [
              Icon(
                Icons.upload_file_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                'Importa tu estado de cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Elige un PDF o CSV y revisa los movimientos antes de agregarlos.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                children: [
                  for (final formato in ['PDF', 'CSV'])
                    ChoiceChip(
                      label: Text(formato),
                      selected: _formato == formato,
                      onSelected: (_) => setState(() => _formato = formato),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => mostrarPendiente(
                  context,
                  'Seleccionar $_formato',
                  'Se abrirá el selector de archivos para elegir un estado de cuenta $_formato. No se está leyendo ningún documento todavía.',
                ),
                icon: const Icon(Icons.folder_open_outlined),
                label: const Text('Seleccionar archivo'),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _ejemplo = !_ejemplo;
                  _conciliado = false;
                }),
                child: Text(
                  _ejemplo ? 'Ocultar ejemplo' : 'Ver ejemplo de revisión',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (_ejemplo)
          Tarjeta(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Vista previa de importación',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('Ejemplo ilustrativo · no proviene de un archivo'),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.local_cafe_outlined),
                  title: Text('Cafetería campus'),
                  subtitle: Text('Alimentación · 3 sep'),
                  trailing: Text('-\$65.00'),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.directions_bus_outlined),
                  title: Text('Recarga transporte'),
                  subtitle: Text('Transporte · 3 sep'),
                  trailing: Text('-\$120.00'),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Revisé los movimientos',
                    style: TextStyle(fontSize: 13),
                  ),
                  value: _conciliado,
                  onChanged: (v) => setState(() => _conciliado = v ?? false),
                ),
                FilledButton(
                  onPressed: () {
                    if (!_conciliado) {
                      aviso(
                        context,
                        'Primero confirma que revisaste el ejemplo.',
                      );
                      return;
                    }
                    mostrarPendiente(
                      context,
                      'Confirmar importación',
                      'Se convertirán las filas reconocidas en movimientos y se guardarán en SQLite, después de revisar duplicados.',
                    );
                  },
                  child: const Text('Confirmar importación'),
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),
        const Card(
          child: ExpansionTile(
            key: PageStorageKey('factor-wow'),
            leading: Icon(Icons.auto_awesome_outlined),
            title: Text('Nuestro factor WOW'),
            childrenPadding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: [
              Text(
                'Propuesta: leer un estado de cuenta PDF o CSV, reconocer sus movimientos y sugerir categorías sin vincular una cuenta bancaria.\n\nEn esta entrega solo está la interfaz. La lectura de archivos, la extracción y el guardado local se desarrollarán y evaluarán después.',
              ),
            ],
          ),
        ),
        const EtiquetaDemo(),
      ],
    ),
  );
}
