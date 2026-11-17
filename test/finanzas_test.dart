import 'package:flutter_test/flutter_test.dart';
import 'package:aplicacion_finanzas_personales/constants/tema.dart';
import 'package:aplicacion_finanzas_personales/models/movimiento.dart';

void main() {
  group('Pruebas de Lógica Financiera', () {
    test('La función dinero() formatea correctamente los montos', () {
      expect(dinero(1234.5), '\$1,234.50');
      expect(dinero(0), '\$0.00');
      expect(dinero(-500.25), '-\$500.25');
      expect(dinero(1000000), '\$1,000,000.00');
    });

    test('El modelo Movimiento mapea correctamente a Map', () {
      final mov = Movimiento(
        titulo: 'Prueba',
        categoria: 'Alimentación',
        monto: 150.0,
        fecha: DateTime(2026, 9, 15),
        esIngreso: false,
      );

      final map = mov.toMap();
      expect(map['titulo'], 'Prueba');
      expect(map['monto'], 150.0);
      expect(map['esIngreso'], false);
    });
  });
}
