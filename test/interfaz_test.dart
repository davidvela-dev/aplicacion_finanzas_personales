import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:aplicacion_finanzas_personales/main.dart';
import 'package:aplicacion_finanzas_personales/viewmodels/finanzas_provider.dart';

Future<void> abrirApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1206, 2622);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => FinanzasProvider(),
      child: const MyApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Navegación principal, tema global y regreso al login', (
    tester,
  ) async {
    await abrirApp(tester);
    await tester.tap(find.text('Explorar versión de muestra'));
    await tester.pumpAndSettle();
    expect(find.text('Hola, Vittorio 👋'), findsOneWidget);
    for (final etiqueta in [
      'Movimientos',
      'Presupuestos',
      'Reportes',
      'Inicio',
    ]) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(etiqueta),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    await tester.tap(find.byTooltip('Ajustes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Modo oscuro'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Modo oscuro'))).brightness,
      Brightness.dark,
    );
    await tester.scrollUntilVisible(find.text('Cerrar sesión de muestra'), 250);
    await tester.tap(find.text('Cerrar sesión de muestra'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Salir'));
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });

  testWidgets('Guardar movimiento exige datos y actualiza la muestra', (
    tester,
  ) async {
    await abrirApp(tester);
    await tester.tap(find.text('Explorar versión de muestra'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Nuevo movimiento'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Guardar en la muestra'));
    await tester.tap(find.text('Guardar en la muestra'));
    await tester.pumpAndSettle();
    expect(find.text('Escribe un monto mayor que cero'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('monto')), '65');
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('nota')),
      250,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.enterText(
      find.byKey(const ValueKey('nota')),
      'Café de prueba',
    );
    await tester.ensureVisible(find.text('Guardar en la muestra'));
    await tester.tap(find.text('Guardar en la muestra'));
    await tester.pumpAndSettle();
    expect(find.text('Café de prueba'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
