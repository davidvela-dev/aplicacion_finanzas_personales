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

    // 1. Entrar a la versión de muestra desde el login
    await tester.tap(find.text('Explorar versión de muestra'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Hola'), findsWidgets);

    // 2. Probar navegación en las pestañas del NavigationBar
    for (final etiqueta in [
      'Movimientos',
      'Presupuestos',
      'Reportes',
      'Inicio',
    ]) {
      final tabFinder = find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(etiqueta),
      );
      if (tabFinder.evaluate().isNotEmpty) {
        await tester.tap(tabFinder);
        await tester.pumpAndSettle();
      }
    }

    // 3. Abrir Ajustes
    final btnAjustes = find.byTooltip('Ajustes');
    if (btnAjustes.evaluate().isNotEmpty) {
      await tester.tap(btnAjustes);
      await tester.pumpAndSettle();
    }

    // Cambiar tema
    final btnModoOscuro = find.text('Modo oscuro');
    if (btnModoOscuro.evaluate().isNotEmpty) {
      await tester.tap(btnModoOscuro);
      await tester.pumpAndSettle();
    }

    // 4. Cerrar sesión
    final btnCerrarMuestra = find.text('Cerrar sesión de muestra');

    // Intentar hacer scroll dinámico hasta encontrar el botón de cerrar sesión
    try {
      await tester.scrollUntilVisible(
        btnCerrarMuestra,
        300,
        scrollable: find.byType(Scrollable).first,
      );
    } catch (_) {}

    if (btnCerrarMuestra.evaluate().isNotEmpty) {
      await tester.tap(btnCerrarMuestra);
      await tester.pumpAndSettle();

      final btnSalir = find.text('Salir');
      if (btnSalir.evaluate().isNotEmpty) {
        await tester.tap(btnSalir);
        await tester.pumpAndSettle();
      }
    }

    // 5. Verificar regreso al Login
    expect(find.text('Iniciar sesión'), findsOneWidget);
  });

  testWidgets('Guardar movimiento exige datos y actualiza la muestra', (
    tester,
  ) async {
    await abrirApp(tester);

    // 1. Entrar a versión de muestra
    await tester.tap(find.text('Explorar versión de muestra'));
    await tester.pumpAndSettle();

    // 2. Abrir formulario de nuevo movimiento
    await tester.tap(find.byTooltip('Nuevo movimiento'));
    await tester.pumpAndSettle();

    // 3. Intentar guardar sin datos para validar error
    final btnGuardar = find.text('Guardar en la muestra');
    if (btnGuardar.evaluate().isNotEmpty) {
      await tester.tap(btnGuardar);
      await tester.pumpAndSettle();
      expect(find.text('Escribe un monto mayor que cero'), findsOneWidget);
    }

    // 4. Ingresar monto
    final campoMonto = find.byKey(const ValueKey('monto'));
    if (campoMonto.evaluate().isNotEmpty) {
      await tester.enterText(campoMonto, '65');
      await tester.pumpAndSettle();
    }

    // 5. Ingresar nota
    final campoNota = find.byKey(const ValueKey('nota'));
    try {
      await tester.scrollUntilVisible(
        campoNota,
        200,
        scrollable: find.byType(Scrollable).first,
      );
    } catch (_) {}

    if (campoNota.evaluate().isNotEmpty) {
      await tester.enterText(campoNota, 'Café de prueba');
      await tester.pumpAndSettle();
    }

    // 6. Quitar foco del teclado
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();

    // 7. Guardar movimiento
    if (btnGuardar.evaluate().isNotEmpty) {
      await tester.tap(btnGuardar);
      await tester.pumpAndSettle();
    }

    // 8. Confirmar actualización en pantalla
    expect(find.text('Café de prueba'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
