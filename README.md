![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)
![Android](https://img.shields.io/badge/Android-%233DDC84.svg?style=for-the-badge&logo=android&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-%23000000.svg?style=for-the-badge&logo=ios&logoColor=white)
![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)

# Aplicacion de Finanzas Personales

## Entrega 1: Saldo

La interfaz de la primera entrega está en la rama `entrega1-finanzas`.
Recorrido, alcance, paquetes, pendientes y explicación del código en
[docs/entrega1.md](docs/entrega1.md).

Antes de cada commit y push: `dart format .`, `flutter analyze`, `flutter test`.
Activar los hooks locales con `git config core.hooksPath .githooks`.

El resto de este README conserva la propuesta completa del equipo. SQLite,
importación bancaria y notificaciones pertenecen a las etapas posteriores.

Aplicacion movil multiplataforma diseñada para ayudar a estudiantes y jovenes profesionistas a registrar, organizar y visualizar sus ingresos y gastos diarios de manera intuitiva y sin necesidad de conexion a internet

## 1- Autores del Proyecto
* David Valdez Martinez
* Vittorio Catino
* David Vela

---

## 2- Descripcion

### 2.1- Funcionalidades Principales

* **Registro de Movimientos:** Alta, edicion y eliminacion dinamica de ingresos y gastos
* **Categorias Personalizables:** Organizacion de transacciones mediante categorias con colores e iconos adaptables
* **Presupuestos Mensuales:** Establecimiento de limites de gasto por categoria con indicadores visuales de avance
* **Reportes Visuales:** Graficas de pastel (distribucion de gastos) y de barras (evolucion mensual), acompañadas de metricas de promedio diario
* **Modulo de Estados de Cuenta:** Subida de documentos (PDF/CSV) para la extraccion automatica de transacciones y su adaptacion directa al modelo interno de la aplicacion
* **Sistema de Alertas y Notificaciones:** Avisos locales configurables cuando el usuario se aproxima o excede sus limites presupuestales
* **Exportacion de Datos:** Generacion de respaldos e historial en formato CSV

### 2.2- Pantallas

1. **Inicio:** Balance general del mes, resumen de ingresos/gastos y acceso rapido a ultimos movimientos

2. **Movimientos:** Historial filtrado por pestañas (Todos, Gastos, Ingresos) con soporte para editar o eliminar

3. **Nuevo Movimiento / Edicion:** Teclado numerico integrado para captura rapida de montos, seleccion de categoria y notas

4. **Presupuestos:** Visualizacion del limite total mensual, barras de progreso por categoria y dias restantes del ciclo

5. **Reportes:** Grafica de distribucion de gastos, evolucion mensual y comparativo porcentual contra el mes anterior

6. **Alertas y Preferencias:** Centro de notificaciones locales y configuracion de umbrales de aviso y recordatorios diarios

7. **Categorias:** Listado y reordenamiento de categorias activas con opcion de creacion personalizada

8. **Subida de Estados de Cuenta:** Interfaz de seleccion de archivos bancarios para extraccion y conciliacion automatica de transacciones

---

## 3- Arquitectura

### 3.1- Stack Tecnologico

- Framework Flutter 
- Lenguaje Dart
- Base de datos SQLite local

Paquetes
- Gestion de estados con `provider`
- Graficas eficientes con `fl_chart`
- Gestion de archivos con `file_picker` + parser 

Estandarizacion
- Reglas de diseño de google con `flutter_lints`
- Formateo automatico con `dart format` 
- Mensajes con `conventional commits`

### 3.2- Estructura de Carpetas (Layer-First)

```
lib/
    models/                  # clases de datos
    views/                   # pantallas
        inicio.dart
        movimientos.dart       
        edicion.dart
        presupuestos.dart
        reportes.dart
        categorias.dart
        subir.dart
    widgets/                 # componentes reutilizables
    services/                # logica de datos (base de datos, parsers)
    viewmodels/              # logica de estados (providers, notifiers)
    constants/               # recursos globales (colores, rutas)
    main.dart
```

---

## 4- Requerimientos

### 4.1- Requerimientos Funcionales

* RF-01: El sistema debe mostrar al usuario datos mensuales junto con los detalles semanales sobre sus gastos e ingresos asi como ultimos movimientos

* RF-02: El sistema debe permitir al usuario visualizar el historial de movimientos financieros por tipo (todos, ingresos o gastos)
* RF-03: El sistema debe permitir al usuario registrar movimientos especificando el tipo (ingreso/gasto), categoria, monto, fecha y descripcion

* RF-04: El sistema debe permitir al usuario consultar su presupuesto mensual con desglose por categoria, mostrando el monto total asignado, el monto consumido y el saldo disponible
* RF-05: El sistema debe permitir al usuario registrar presupuestos mensuales por categoria con monto limite a gastar con alertas personalizables
* RF-06: El sistema debe permitir al usuario visualizar y gestionar alertas y ajustar preferencias

* RF-07: El sistema debe generar graficas estadisticas de distribucion de gastos e ingresos y comportamiento historico mensual, trimestral, semestral y anual asi como analisis e interpretacion de metricas clave

* RF-08: El sistema debe permitir evaluar estados de cuenta adjuntos, procesar el texto y mapear los movimientos encontrados hacia las categorias de la app

* RF-09: El almacenamiento debe operar de forma local mediante SQLite, garantizando seguridad total sin requerir cuentas bancarias vinculadas
* RF-10: El sistema debe hacer el manejo de datos de forma asincrona con `try-catch` para evitar cierres inesperados

### 4.2- Requerimientos No Funcionales

* RNF-01: **Rendimiento:** La interfaz debe mantener una tasa constante de 60 cuadros por segundo (FPS) en transiciones y navegacion
* RNF-02: **Disponibilidad Offline:** La aplicacion debe funcionar en su totalidad sin conexion a internet
* RNF-03: **Compatibilidad:** La aplicacion debe tener soporte nativo para plataformas Android e iOS

---

## 5- Convenciones de Codigo

### 5.1- Nomenclatura y Estilo

- **Archivos:** `snake_case` para nombrar los archivos del codigo fuente
- **Clases y Tipos:** `UpperCamelCase` para nombres de clases, enums y extensiones
- **Variables y Metodos:** `lowerCamelCase` para variables, parametros y metodos
- **Inmutabilidad:** uso de palabras clave `const` y `final` para optimizar el rendimiento

### 5.2- Estructura y Arquitectura (Layer-First)

- **Separacion de Responsabilidades:** las pantallas `views/` no deben contener logoca de negocio directa ni consultas a bases de datos, toda la logica debe delegarse a los `viewmodels/` o `services/`
- **Componentes:** los elementos visuales complejos o repetitivos se modelan para reutilizarse en `widgets/`
- **Modelos de Datos:** Las clases en `models/` deben contar con constructores seguros y metodos para interactuar con SQLite 

---

## 6- Guia de Desarrollo y Ejecucion

### 6.1- Ejecucion Local

- **Clonar repositorio** `git clone url.git`
- **Ir a carpeta raiz** `cd personal_finance_app`
- **Instalar dependencias** `flutter pub get`
- **Ejecutar** `flutter run`

### 6.2 Subir Cambios a Repositorio

#### Correr en Local

- **Formateo Automatico** `dart format .`
- **Analisis Estatico** `flutter analyze`
- **Pruebas Unitarias** `flutter test`

#### Proteccion de Rama Main

- require a pull request before merging 
- require status checks to pass before merging
- require branches to be up to date before merging
- status checks: build_and_test
- do not allow bypassing the above settings
