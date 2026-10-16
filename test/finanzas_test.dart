import 'package:flutter_test/flutter_test.dart';
import 'package:aplicacion_finanzas_personales/constants/tema.dart';
import 'package:aplicacion_finanzas_personales/models/movimiento.dart';
import 'package:aplicacion_finanzas_personales/viewmodels/finanzas_provider.dart';

void main() {
  test('Formato de dinero conserva decimales, miles y signo', () {
    expect(dinero(0), r'$0.00');
    expect(dinero(65.1), r'$65.10');
    expect(dinero(1234.5), r'$1,234.50');
    expect(dinero(1000000), r'$1,000,000.00');
    expect(dinero(-65.1), r'-$65.10');
  });
  test('Ingresos, gastos y presupuesto usan los mismos datos', () {
    final datos = FinanzasProvider();
    expect(datos.ingresos, 9500);
    expect(datos.gastos, closeTo(5930, 0.001));
    expect(datos.balance, closeTo(3570, 0.001));
    expect(datos.gastoCategoria('Alimentación'), closeTo(2180, 0.001));
    expect(datos.limiteTotal, 7000);
  });

  test('Alta, edición y eliminación actualizan el balance sin duplicar', () {
    final datos = FinanzasProvider();
    final balance = datos.balance;
    final nuevo = Movimiento(
      titulo: 'Café',
      categoria: 'Alimentación',
      monto: 65,
      fecha: DateTime(2026, 9, 3),
    );
    datos.guardarMovimiento(nuevo);
    expect(datos.balance, closeTo(balance - 65, 0.001));
    final editado = Movimiento(
      titulo: 'Café',
      categoria: 'Alimentación',
      monto: 50,
      fecha: nuevo.fecha,
    );
    datos.guardarMovimiento(editado, anterior: nuevo);
    expect(datos.balance, closeTo(balance - 50, 0.001));
    expect(datos.movimientos.where((m) => m.titulo == 'Café').length, 1);
    datos.eliminarMovimiento(editado);
    expect(datos.balance, closeTo(balance, 0.001));
  });
}
