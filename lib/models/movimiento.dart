import 'package:cloud_firestore/cloud_firestore.dart';

class Movimiento {
  final String? id;
  final String titulo;
  final String categoria;
  final double monto;
  final DateTime fecha;
  final bool esIngreso;

  const Movimiento({
    this.id,
    required this.titulo,
    required this.categoria,
    required this.monto,
    required this.fecha,
    this.esIngreso = false,
  });

  Map<String, dynamic> toMap() => {
        'titulo': titulo,
        'categoria': categoria,
        'monto': monto,
        'fecha': Timestamp.fromDate(fecha),
        'esIngreso': esIngreso,
      };

  factory Movimiento.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data()!;
    final ts = m['fecha'];
    return Movimiento(
      id: doc.id,
      titulo: (m['titulo'] as String?) ?? '',
      categoria: (m['categoria'] as String?) ?? 'Otros',
      monto: (m['monto'] as num?)?.toDouble() ?? 0,
      fecha: ts is Timestamp ? ts.toDate() : DateTime.now(),
      esIngreso: (m['esIngreso'] as bool?) ?? false,
    );
  }

  Movimiento copyWith({
    String? id,
    String? titulo,
    String? categoria,
    double? monto,
    DateTime? fecha,
    bool? esIngreso,
  }) {
    return Movimiento(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      categoria: categoria ?? this.categoria,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      esIngreso: esIngreso ?? this.esIngreso,
    );
  }
}
