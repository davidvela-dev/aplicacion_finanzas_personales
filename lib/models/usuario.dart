import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String? fotoPath;
  final String deviceToken;
  final double umbral;
  final bool modoOscuro;
  final bool ocultarMontos;
  final bool avisarLimite;
  final bool recordatorio;
  final DateTime createdAt;

  const Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.deviceToken,
    this.fotoPath,
    this.umbral = 80,
    this.modoOscuro = false,
    this.ocultarMontos = false,
    this.avisarLimite = true,
    this.recordatorio = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'nombre': nombre,
        'email': email,
        'fotoPath': fotoPath,
        'deviceToken': deviceToken,
        'umbral': umbral,
        'modoOscuro': modoOscuro,
        'ocultarMontos': ocultarMontos,
        'avisarLimite': avisarLimite,
        'recordatorio': recordatorio,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory Usuario.fromMap(String uid, Map<String, dynamic> m) {
    final ts = m['createdAt'];
    return Usuario(
      uid: uid,
      nombre: (m['nombre'] as String?) ?? 'Usuario',
      email: (m['email'] as String?) ?? '',
      fotoPath: m['fotoPath'] as String?,
      deviceToken: (m['deviceToken'] as String?) ?? '',
      umbral: (m['umbral'] as num?)?.toDouble() ?? 80,
      modoOscuro: (m['modoOscuro'] as bool?) ?? false,
      ocultarMontos: (m['ocultarMontos'] as bool?) ?? false,
      avisarLimite: (m['avisarLimite'] as bool?) ?? true,
      recordatorio: (m['recordatorio'] as bool?) ?? false,
      createdAt: ts is Timestamp ? ts.toDate() : DateTime.now(),
    );
  }

  Usuario copyWith({
    String? nombre,
    String? email,
    String? fotoPath,
    String? deviceToken,
    double? umbral,
    bool? modoOscuro,
    bool? ocultarMontos,
    bool? avisarLimite,
    bool? recordatorio,
    DateTime? createdAt,
  }) {
    return Usuario(
      uid: uid,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      fotoPath: fotoPath ?? this.fotoPath,
      deviceToken: deviceToken ?? this.deviceToken,
      umbral: umbral ?? this.umbral,
      modoOscuro: modoOscuro ?? this.modoOscuro,
      ocultarMontos: ocultarMontos ?? this.ocultarMontos,
      avisarLimite: avisarLimite ?? this.avisarLimite,
      recordatorio: recordatorio ?? this.recordatorio,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
