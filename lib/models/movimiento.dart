class Movimiento {
  final String titulo;
  final String categoria;
  final double monto;
  final DateTime fecha;
  final bool esIngreso;

  const Movimiento({
    required this.titulo,
    required this.categoria,
    required this.monto,
    required this.fecha,
    this.esIngreso = false,
  });
}
