import 'package:flutter/material.dart';

import '../constants/tema.dart';
import '../models/categoria.dart';
import '../models/movimiento.dart';

// Entrega 1: estado de demostración en memoria. Al reiniciar se restablece.
class FinanzasProvider extends ChangeNotifier {
  bool modoOscuro = false;
  bool ocultarMontos = false;
  bool avisarLimite = true;
  bool recordatorio = false;
  double umbral = 80;
  String nombre = 'Vittorio';
  final Set<int> alertasLeidas = {};
  final categorias = <Categoria>[
    const Categoria('Alimentación', Icons.restaurant_outlined, Colores.naranja),
    const Categoria('Transporte', Icons.directions_bus_outlined, Colores.azul),
    const Categoria('Entretenimiento', Icons.movie_outlined, Colores.morado),
    const Categoria('Vivienda', Icons.home_outlined, Color(0xFF00838B)),
    const Categoria('Escuela', Icons.school_outlined, Color(0xFF658048)),
    const Categoria('Ingreso', Icons.south_west, Colores.verde),
  ];
  final movimientos = <Movimiento>[
    Movimiento(
      titulo: 'Súper de la semana',
      categoria: 'Alimentación',
      monto: 742.10,
      fecha: DateTime(2026, 9, 3),
    ),
    Movimiento(
      titulo: 'Metro · recarga',
      categoria: 'Transporte',
      monto: 120,
      fecha: DateTime(2026, 9, 3),
    ),
    Movimiento(
      titulo: 'Beca escolar',
      categoria: 'Ingreso',
      monto: 3000,
      fecha: DateTime(2026, 9, 2),
      esIngreso: true,
    ),
    Movimiento(
      titulo: 'Cine con amigos',
      categoria: 'Entretenimiento',
      monto: 279,
      fecha: DateTime(2026, 9, 2),
    ),
    Movimiento(
      titulo: 'Renta de cuarto',
      categoria: 'Vivienda',
      monto: 1430,
      fecha: DateTime(2026, 9, 1),
    ),
    Movimiento(
      titulo: 'Comidas del mes',
      categoria: 'Alimentación',
      monto: 1437.90,
      fecha: DateTime(2026, 9, 1),
    ),
    Movimiento(
      titulo: 'Traslados',
      categoria: 'Transporte',
      monto: 740,
      fecha: DateTime(2026, 9, 1),
    ),
    Movimiento(
      titulo: 'Suscripciones y salidas',
      categoria: 'Entretenimiento',
      monto: 661,
      fecha: DateTime(2026, 9, 1),
    ),
    Movimiento(
      titulo: 'Material escolar',
      categoria: 'Escuela',
      monto: 520,
      fecha: DateTime(2026, 9, 1),
    ),
    Movimiento(
      titulo: 'Trabajo de medio tiempo',
      categoria: 'Ingreso',
      monto: 6500,
      fecha: DateTime(2026, 9, 1),
      esIngreso: true,
    ),
  ];
  final presupuestos = <String, double>{
    'Alimentación': 2400,
    'Transporte': 1200,
    'Entretenimiento': 800,
    'Vivienda': 1500,
    'Escuela': 1100,
  };
  double get ingresos => movimientos
      .where((m) => m.esIngreso)
      .fold(0.0, (total, m) => total + m.monto);
  double get gastos => movimientos
      .where((m) => !m.esIngreso)
      .fold(0.0, (total, m) => total + m.monto);
  double get balance => ingresos - gastos;
  double get limiteTotal =>
      presupuestos.values.fold(0.0, (total, monto) => total + monto);
  double gastoCategoria(String nombre) => movimientos
      .where((m) => !m.esIngreso && m.categoria == nombre)
      .fold(0.0, (total, m) => total + m.monto);
  Categoria categoria(String nombre) => categorias.firstWhere(
    (c) => c.nombre == nombre,
    orElse: () => categorias.first,
  );
  void cambiarTema(bool valor) {
    modoOscuro = valor;
    notifyListeners();
  }

  void cambiarPrivacidad(bool valor) {
    ocultarMontos = valor;
    notifyListeners();
  }

  void cambiarAviso(bool valor) {
    avisarLimite = valor;
    notifyListeners();
  }

  void cambiarRecordatorio(bool valor) {
    recordatorio = valor;
    notifyListeners();
  }

  void cambiarUmbral(double valor) {
    umbral = valor;
    notifyListeners();
  }

  void leerAlerta(int indice) {
    alertasLeidas.add(indice);
    notifyListeners();
  }

  void iniciarSesion(String valor) {
    if (valor.trim().isNotEmpty) nombre = valor.trim();
    notifyListeners();
  }

  void guardarMovimiento(Movimiento movimiento, {Movimiento? anterior}) {
    if (anterior != null) movimientos.remove(anterior);
    movimientos.insert(0, movimiento);
    notifyListeners();
  }

  void eliminarMovimiento(Movimiento movimiento) {
    movimientos.remove(movimiento);
    notifyListeners();
  }

  void agregarCategoria(Categoria categoria) {
    categorias.add(categoria);
    notifyListeners();
  }

  void guardarPresupuesto(String categoria, double limite) {
    presupuestos[categoria] = limite;
    notifyListeners();
  }
}
