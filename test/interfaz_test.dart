import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:aplicacion_finanzas_personales/viewmodels/finanzas_provider.dart';
import 'package:aplicacion_finanzas_personales/views/login.dart';

// Creamos un Provider "falso" para pruebas que evite llamadas reales a Firebase
class FakeFinanzasProvider extends ChangeNotifier implements FinanzasProvider {
  @override
  bool get modoOscuro => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('La pantalla de Login se renderiza sin errores', (tester) async {
    // 1. Construimos el widget simulando el entorno de la app
    await tester.pumpWidget(
      ChangeNotifierProvider<FinanzasProvider>(
        create: (_) => FakeFinanzasProvider(),
        child: const MaterialApp(
          home: LoginView(),
        ),
      ),
    );

    // 2. Verificamos que los textos principales existan
    expect(find.text('Tu dinero,\nmás claro.'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Continuar con Google'), findsOneWidget);

    // 3. Verificamos que existan los campos de texto (Correo y Contraseña)
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
