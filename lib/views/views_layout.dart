import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/rutas.dart';
import '../viewmodels/finanzas_provider.dart';
import '../widgets/componentes.dart';
import 'inicio.dart';
import 'movimientos.dart';
import 'presupuestos.dart';
import 'reportes.dart';

class ViewsLayout extends StatefulWidget {
  final int initialIndex;
  const ViewsLayout({super.key, this.initialIndex = 0});
  @override
  State<ViewsLayout> createState() => _ViewsLayoutState();
}

class _ViewsLayoutState extends State<ViewsLayout> {
  late int _currentIndex;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _seleccionar(int indice) => setState(() => _currentIndex = indice);

  @override
  Widget build(BuildContext context) {
    final datos = context.watch<FinanzasProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: MarcaSaldo(),
        ),
        actions: [
          if (_currentIndex <= 1)
            IconButton.filled(
              tooltip: 'Nuevo movimiento',
              onPressed: () => Navigator.pushNamed(context, Rutas.edicion),
              icon: const Icon(Icons.add),
            ),
          IconButton(
            tooltip: 'Alertas',
            onPressed: () => Navigator.pushNamed(context, Rutas.alertas),
            icon: const Icon(Icons.notifications_none_outlined),
          ),
          IconButton(
            tooltip: 'Ajustes',
            onPressed: () => Navigator.pushNamed(context, Rutas.ajustes),
            icon: const Icon(Icons.tune_outlined),
          ),
          const SizedBox(width: 6),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const Padding(padding: EdgeInsets.all(24), child: MarcaSaldo()),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Text(
                  'Hola, ${datos.nombre}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('Tus finanzas a tu ritmo.'),
              ),
              const SizedBox(height: 24),
              for (final item in [
                (Icons.home_outlined, 'Inicio', 0),
                (Icons.receipt_long_outlined, 'Movimientos', 1),
                (Icons.account_balance_wallet_outlined, 'Presupuestos', 2),
                (Icons.bar_chart_outlined, 'Reportes', 3),
              ])
                ListTile(
                  leading: Icon(item.$1),
                  title: Text(item.$2),
                  selected: _currentIndex == item.$3,
                  onTap: () {
                    Navigator.pop(context);
                    _seleccionar(item.$3);
                  },
                ),
              const Divider(indent: 24, endIndent: 24),
              for (final item in [
                (Icons.category_outlined, 'Categorías', Rutas.categorias),
                (Icons.upload_file_outlined, 'Estados de cuenta', Rutas.subir),
                (Icons.notifications_none, 'Alertas', Rutas.alertas),
                (Icons.settings_outlined, 'Ajustes', Rutas.ajustes),
              ])
                ListTile(
                  leading: Icon(item.$1),
                  title: Text(item.$2),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, item.$3);
                  },
                ),
              const EtiquetaDemo(),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          InicioView(onVerTodo: () => _seleccionar(1)),
          const MovimientosView(),
          const PresupuestosView(),
          const ReportesView(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _seleccionar,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Movimientos',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Presupuestos',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reportes',
          ),
        ],
      ),
    );
  }
}
