# Saldo - Entrega 1

## Alcance

Interfaz y navegación. Se parte de la estructura de rutas y el layout que ya
tenía el equipo. El nombre visible elegido es **Saldo**, con un icono de cartera.
Los datos de septiembre de 2026 son de muestra, no información bancaria real.

La captura, edición, eliminación, categorías y presupuestos modifican listas en
memoria para demostrar los cambios de interfaz. Al cerrar y volver a iniciar el
proceso se restablecen. No hay SQLite ni autenticación real en esta entrega.

## Cómo recorrer la app

1. En inicio de sesión, usar **Explorar versión de muestra**.
2. Revisar Inicio, Movimientos, Presupuestos y Reportes con la barra inferior.
3. En Movimientos, cambiar el filtro o buscar. Tocar una fila para editar o borrar.
4. Usar **+** para un nuevo movimiento. Guardar actualiza la muestra y el balance.
5. Tocar un presupuesto o el botón **+** para ajustar el límite de muestra.
6. En Reportes, cambiar Mes/Trimestre/Año. El histórico es ilustrativo.
7. En el menú lateral están Categorías, Estados de cuenta, Alertas y Ajustes.
8. En Ajustes, activar modo oscuro y regresar: se aplica a todas las pantallas.
9. En Estados de cuenta, seleccionar formato, ver el ejemplo y revisar las
   alertas de las funciones pendientes.

## Dónde explicar el código al profesor

| Elemento | Archivo | Explicación breve |
| --- | --- | --- |
| Arranque | `lib/main.dart` | `ChangeNotifierProvider` envuelve a `MaterialApp`. |
| Rutas | `lib/constants/rutas.dart` | Nombres que utiliza `Navigator.pushNamed`. |
| Navegación | `lib/views/views_layout.dart` | `setState` cambia el índice; `IndexedStack` conserva las pestañas. |
| Tema | `lib/constants/tema.dart` | Colores, bordes y los dos `ThemeData`. |
| Estado compartido | `lib/viewmodels/finanzas_provider.dart` | Listas y ajustes; `notifyListeners` avisa a `context.watch`. |
| Componentes | `lib/widgets/componentes.dart` | Tarjetas, marca, filas y alertas reutilizables. |
| Gráficas | `lib/widgets/graficas.dart` | `PieChart` y `BarChart` de fl_chart con listas de números. |
| Formularios | `lib/views/edicion.dart` | Controladores, validación y selector de fecha. |
| Widget nuevo 1 | `lib/views/ajustes.dart` | `ExpansionTile` abre y cierra la explicación de la app. |
| Widget nuevo 2 | `lib/views/inicio.dart` | `Tooltip` muestra el gasto al mantener presionada una barra. |

No se usa generación de código, servicios en la nube ni arquitectura avanzada.
Revisar especialmente cada función antes de presentar: el profesor pide que
todos entiendan el código y limita el uso de IA a apoyos específicos.

## Paquetes

- **provider**: estado compartido y modo oscuro global, igual que en la práctica.
- **fl_chart**: gráfica de dona y barras que sí se muestran en Reportes.
- **flutter_localizations** (SDK): controles y selector de fecha en español.
- **integration_test** (SDK, desarrollo): recorre la app real y obtiene capturas.

Referencia: https://pub.dev/packages/fl_chart
Widgets: https://api.flutter.dev/flutter/material/ExpansionTile-class.html
y https://api.flutter.dev/flutter/material/Tooltip-class.html

## Funcionalidad pendiente de siguientes etapas

- Autenticación y recuperación de contraseña.
- Guardado de movimientos y ajustes en SQLite.
- Lectura de archivos PDF/CSV, extracción y detección de duplicados.
- Exportación CSV y notificaciones reales del dispositivo.
- Gráficas basadas en histórico real en lugar de ejemplos.

El factor WOW propuesto es importar estados de cuenta y sugerir categorías sin
vincular cuentas bancarias. Su espacio está en Estados de cuenta, con avisos
explícitos de que la integración aún está pendiente.

## Verificaciones y Git

Antes de cada commit y cada push ejecutar `sh scripts/verificar.sh`.
Los tres comandos son `dart format .`, `flutter analyze` y `flutter test`.
Para activar el bloqueo automático en cada copia del repo:

```sh
git config core.hooksPath .githooks
```

Después del formateo revisar y agregar los cambios antes del commit.
Mantener la rama de entrega separada de `main` y usar un pull request al integrar.

Capturas en iOS:

```sh
flutter drive --driver=test_driver/capturas.dart --target=integration_test/recorrido_test.dart -d ID_DEL_SIMULADOR
```

## Archivos de la entrega

`entrega1/entrega1_saldo.zip` contiene `lib`, `pubspec.yaml`, `pubspec.lock`,
el PDF de reporte, capturas y el icono. El video lo graba Vittorio y debe durar
menos de dos minutos; incorporarlo al ZIP antes de subirlo a Canvas.

Las tres conclusiones del reporte son borradores sugeridos a petición de Vittorio.
Cada integrante debe revisarlas y ajustarlas a su experiencia antes de entregar.
