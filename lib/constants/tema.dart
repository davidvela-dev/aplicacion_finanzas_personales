import 'package:flutter/material.dart';

class Colores {
  static const verde = Color(0xFF168568);
  static const oscuro = Color(0xFF153B32);
  static const naranja = Color(0xFFBC7542);
  static const azul = Color(0xFF587CC0);
  static const morado = Color(0xFFA067A5);
  static const rojo = Color(0xFFBA514F);
}

ThemeData crearTema(Brightness brillo) {
  final esOscuro = brillo == Brightness.dark;
  final esquema = ColorScheme.fromSeed(
    seedColor: Colores.verde,
    brightness: brillo,
    primary: esOscuro ? const Color(0xFF73D8B6) : Colores.verde,
    surface: esOscuro ? const Color(0xFF17231F) : Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: esOscuro
        ? const Color(0xFF101915)
        : const Color(0xFFF5F7F3),
    appBarTheme: AppBarTheme(
      backgroundColor: esOscuro
          ? const Color(0xFF101915)
          : const Color(0xFFF5F7F3),
      foregroundColor: esquema.onSurface,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: esquema.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: esquema.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: esquema.outlineVariant),
      ),
      contentPadding: const EdgeInsets.all(18),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: esquema.surface,
      indicatorColor: esquema.primaryContainer,
      height: 72,
    ),
  );
}

String dinero(double cantidad) {
  final partes = cantidad.abs().toStringAsFixed(2).split('.');
  final entero = partes[0].replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (coincidencia) => '${coincidencia[1]},',
  );
  return '${cantidad < 0 ? '-' : ''}\$$entero.${partes[1]}';
}
