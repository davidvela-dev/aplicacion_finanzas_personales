import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:aplicacion_finanzas_personales/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Recorrido real de entrega 1 y capturas', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    Future<void> captura(String nombre) async {
      await tester.pumpAndSettle();
      await binding.takeScreenshot(nombre);
      expect(tester.takeException(), isNull);
    }

    await captura('01_login');
    await tester.ensureVisible(find.text('Regístrate'));
    await tester.tap(find.text('Regístrate'));
    await tester.pumpAndSettle();
    await captura('02_registro');
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Explorar versión de muestra'));
    await tester.tap(find.text('Explorar versión de muestra'));
    await tester.pumpAndSettle();
    await captura('03_inicio');
    for (final entrada in [
      ('Movimientos', '04_movimientos'),
      ('Presupuestos', '05_presupuestos'),
      ('Reportes', '06_reportes'),
    ]) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(entrada.$1),
        ),
      );
      await tester.pumpAndSettle();
      await captura(entrada.$2);
      if (entrada.$1 == 'Reportes') {
        await tester.tap(find.text('Trimestre'));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(ListView).last, const Offset(0, -340));
        await tester.pumpAndSettle();
        await captura('16_reportes_historico');
      }
    }
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Inicio'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Nuevo movimiento'));
    await tester.pumpAndSettle();
    await captura('07_nuevo_movimiento');
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Ajustes'));
    await tester.pumpAndSettle();
    await captura('08_ajustes');
    for (final entrada in [
      ('Categorías', '09_categorias'),
      ('Estados de cuenta', '10_importacion'),
      ('Alertas y recordatorios', '11_alertas'),
    ]) {
      await tester.ensureVisible(find.text(entrada.$1));
      await tester.tap(find.text(entrada.$1));
      await tester.pumpAndSettle();
      await captura(entrada.$2);
      if (entrada.$1 == 'Categorías') {
        await tester.scrollUntilVisible(
          find.text('Crear categoría de muestra'),
          250,
          scrollable: find
              .descendant(
                of: find.byType(ListView),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        await captura('14_categoria_nueva');
      }
      if (entrada.$1 == 'Estados de cuenta') {
        await tester.tap(find.text('Seleccionar archivo'));
        await tester.pumpAndSettle();
        await captura('18_funcion_pendiente');
        await tester.tap(find.text('Entendido'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Ver ejemplo de revisión'));
        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('Confirmar importación'),
          250,
        );
        await captura('15_importacion_revision');
      }
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
    }
    await tester.ensureVisible(find.text('Modo oscuro'));
    await tester.tap(find.text('Modo oscuro'));
    await tester.pumpAndSettle();
    await captura('12_ajustes_oscuro');
    await tester.ensureVisible(find.text('Acerca de Saldo'));
    await tester.tap(find.text('Acerca de Saldo'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -280));
    await tester.pumpAndSettle();
    await captura('19_acerca_de');
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await captura('13_inicio_oscuro');
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await captura('17_menu_lateral');
  });
}
