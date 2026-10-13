import 'package:flutter/material.dart';

// pantallas en el layout
import 'inicio.dart';
import 'movimientos.dart';
import 'presupuestos.dart';
import 'reportes.dart';

class ViewsLayout extends StatefulWidget {
  final int initialIndex; // variable para guardar pestaña inicial

  const ViewsLayout({super.key, this.initialIndex = 0});

  @override
  State<ViewsLayout> createState() => _ViewsLayoutState();
}

class _ViewsLayoutState extends State<ViewsLayout> {
  late int _currentIndex; // inicializar al cargar la vista

  @override
  void initState() {
    super.initState();
    _currentIndex =
        widget.initialIndex; // se asigna indice de la ruta principa;
  }

  // lista de pantallas con indices
  final List<Widget> _pantallas = const [
    InicioView(),
    MovimientosView(),
    PresupuestosView(),
    ReportesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack mantiene el estado de todas las pestañas
      body: IndexedStack(
        index: _currentIndex, // indice para pantalla e icono seleccionado
        children: _pantallas, // lista de pantallas
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // mostrar todos los elementos del menu sin esconderlos
        currentIndex: _currentIndex, // variable privada para indice actual
        selectedItemColor:
            Colors.black, // color negro para elementos seleccionados
        unselectedItemColor:
            Colors.grey, // color gris para elementos no seleccionados
        showUnselectedLabels:
            false, // no mostrar label de elementos no seleccionados
        showSelectedLabels:
            false, // no mostrar label de elementos seleccionados
        // lista de iconos
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Movimientos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Presupuestos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Reportes',
          ),
        ],

        onTap: (index) {
          // se cambia el indice actual
          setState(() {
            _currentIndex = index; // flutter vuelve a dibujar con nuevo indice
          });
        },
      ),
    );
  }
}
