import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Categoria {
  final String? id;
  final String nombre;
  final IconData icono;
  final Color color;

  Categoria({
    this.id,
    required this.nombre,
    required this.icono,
    required this.color,
  });

  Map<String, dynamic> toMap() => {
        'nombre': nombre,
        'iconCode': icono.codePoint,
        'colorValue': color.toARGB32(),
      };

  factory Categoria.fromDoc(
    DocumentSnapshot doc,
  ) {
    final m = (doc.data() as Map<String, dynamic>?) ?? <String, dynamic>{};

    final rawIcon = m['iconCode'];
    final int codigo = rawIcon is num ? rawIcon.toInt() : 0xe000;

    final rawColor = m['colorValue'];
    final int colorVal = rawColor is num ? rawColor.toInt() : 0xFF888888;

    final rawNombre = m['nombre'];
    final String nombre = rawNombre is String && rawNombre.trim().isNotEmpty
        ? rawNombre.trim()
        : 'Otros';

    return Categoria(
      id: doc.id,
      nombre: nombre,
      icono: IconData(
        // ignore: non_const_argument_for_const_parameter
        codigo,
        fontFamily: 'MaterialIcons',
      ),
      color: Color(colorVal),
    );
  }

  factory Categoria.seed(
    String nombre,
    IconData icono,
    Color color,
  ) =>
      Categoria(
        nombre: nombre,
        icono: icono,
        color: color,
      );

  Categoria copyWith({
    String? id,
    String? nombre,
    IconData? icono,
    Color? color,
  }) {
    return Categoria(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      icono: icono ?? this.icono,
      color: color ?? this.color,
    );
  }
}
