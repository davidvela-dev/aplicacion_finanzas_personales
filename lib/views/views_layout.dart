import 'package:flutter/material.dart';

// pantallas en el layout
import 'inicio.dart';
import 'movimientos.dart';
import 'presupuestos.dart';
import 'reportes.dart';

class ViewsLayout extends StatefulWidget {
  const ViewsLayout({super.key});

  @override
  State<ViewsLayout> createState() => _ViewsLayoutState();
}

class _ViewsLayoutState extends State<ViewsLayout> {
  int _currentIndex = 0;

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
