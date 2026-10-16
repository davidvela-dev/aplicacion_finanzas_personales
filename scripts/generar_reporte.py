"""Genera el reporte de la entrega usando capturas reales del simulador."""
from pathlib import Path
from xml.sax.saxutils import escape
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Image, Table, TableStyle, PageBreak, KeepTogether

RAIZ = Path(__file__).resolve().parents[1]
SALIDA = RAIZ / 'entrega1'
SALIDA.mkdir(exist_ok=True)
VERDE = colors.HexColor('#168568')
OSCURO = colors.HexColor('#153b32')
GRIS = colors.HexColor('#58675f')
# Incrustar las fuentes para que el PDF se vea igual en otra computadora.
fuente_normal = Path('/System/Library/Fonts/Supplemental/Arial.ttf')
fuente_negrita = Path('/System/Library/Fonts/Supplemental/Arial Bold.ttf')
if fuente_normal.exists() and fuente_negrita.exists():
    pdfmetrics.registerFont(TTFont('Helvetica', str(fuente_normal)))
    pdfmetrics.registerFont(TTFont('Helvetica-Bold', str(fuente_negrita)))
    pdfmetrics.registerFontFamily('Helvetica', normal='Helvetica', bold='Helvetica-Bold', italic='Helvetica', boldItalic='Helvetica-Bold')
ESTILOS = {
    'titulo': ParagraphStyle('titulo', fontName='Helvetica-Bold', fontSize=34, leading=38, textColor=OSCURO, spaceAfter=16),
    'h1': ParagraphStyle('h1', fontName='Helvetica-Bold', fontSize=22, leading=27, textColor=OSCURO, spaceAfter=16),
    'h2': ParagraphStyle('h2', fontName='Helvetica-Bold', fontSize=13, leading=18, textColor=VERDE, spaceBefore=14, spaceAfter=8),
    'cuerpo': ParagraphStyle('cuerpo', fontName='Helvetica', fontSize=10, leading=15, textColor=OSCURO, spaceAfter=10),
    'pequeno': ParagraphStyle('pequeno', fontName='Helvetica', fontSize=8, leading=12, textColor=GRIS, spaceAfter=7),
    'etiqueta': ParagraphStyle('etiqueta', fontName='Helvetica-Bold', fontSize=9, leading=14, textColor=VERDE, spaceAfter=12),
}

def parrafo(texto, estilo='cuerpo'):
    return Paragraph(texto, ESTILOS[estilo])

def pie(canvas, doc):
    canvas.setStrokeColor(colors.HexColor('#dce6df'))
    canvas.line(42, 40, A4[0] - 42, 40)
    canvas.setFont('Helvetica', 8)
    canvas.setFillColor(GRIS)
    canvas.drawString(42, 26, 'SALDO  /  ENTREGA 1  /  INTERFAZ Y NAVEGACION')
    canvas.drawRightString(A4[0] - 42, 26, str(doc.page))

contenido = []
contenido += [parrafo('DESARROLLO DE APLICACIONES MOVILES', 'etiqueta'), Spacer(1, 24)]
contenido += [Image(str(RAIZ / 'assets/identidad/saldo_icono.png'), width=82, height=82, hAlign='LEFT'), Spacer(1, 22)]
contenido += [parrafo('Saldo', 'titulo'), parrafo('Tu dinero, más claro.', 'h1'), parrafo('Primera entrega del proyecto final<br/>Pantallas, componentes y navegación', 'cuerpo'), Spacer(1, 22)]
contenido += [parrafo('Integrantes del equipo', 'h2'), parrafo('David Valdez Martinez<br/>Vittorio Catino<br/>David Vela'), parrafo('15 de octubre de 2026', 'pequeno')]
contenido += [parrafo('¿Qué hará la aplicación?', 'h2'), parrafo('Saldo ayudará a estudiantes y jóvenes profesionistas a registrar ingresos y gastos, organizarlos por categoría y revisar presupuestos y reportes. La propuesta contempla almacenamiento local con SQLite y operación sin vincular cuentas bancarias.')]
contenido += [parrafo('Alcance de esta entrega', 'h2'), parrafo('Se implementó la interfaz completa y la navegación sobre la estructura que ya tenía el equipo. Se utilizan datos de ejemplo. Los cambios de movimientos, categorías y presupuestos son temporales, en memoria; no se incluye autenticación ni guardado permanente.')]
contenido += [parrafo('Repositorio compartido', 'h2'), parrafo('<link href="https://github.com/davidvela-dev/aplicacion_finanzas_personales" color="#168568">github.com/davidvela-dev/aplicacion_finanzas_personales</link>', 'pequeno'), parrafo('Rama de trabajo: entrega1-finanzas. La integración a main se realiza posteriormente mediante revisión del equipo.', 'pequeno'), PageBreak()]

contenido += [parrafo('Una base sencilla para crecer', 'h1')]
contenido += [parrafo('Organización del código', 'h2'), parrafo('Se conservan las rutas nombradas y el layout de navegación existentes. Cada pantalla está en views; los componentes comunes en widgets; las clases de datos en models; los colores y rutas en constants; y el estado compartido en viewmodels. No se usan generadores ni una arquitectura adicional.')]
contenido += [parrafo('Paquetes implementados', 'h2')]
for titulo, texto in [
    ('provider 6.1.5+1', 'Comparte las listas de muestra y los ajustes. Al activar modo oscuro, notifyListeners permite que MaterialApp y las pantallas cambien su tema. Es el mismo mecanismo de la práctica de Provider.'),
    ('fl_chart 1.2.0', 'Dibuja una dona de distribución de gastos y una gráfica de barras en Reportes. Recibe listas de valores y colores; no consulta una base de datos. La selección de periodo cambia las barras del histórico ilustrativo.'),
    ('flutter_localizations / integration_test', 'Son herramientas del SDK. La primera muestra los controles y el selector de fecha en español. La segunda se usa solo en desarrollo para recorrer la app y capturar pantallas en iOS.'),
]:
    contenido += [parrafo(titulo, 'h2'), parrafo(texto)]
contenido += [parrafo('Dos widgets propuestos como nuevos', 'h2'), parrafo('<b>ExpansionTile:</b> permite abrir y cerrar la sección Acerca de Saldo y la explicación del factor WOW.<br/><b>Tooltip:</b> al mantener presionada una barra de gasto diario muestra su valor. Ambos tienen una función pequeña y fácil de explicar. Confirmar con el profesor que no se hayan revisado antes en clase.')]
contenido += [parrafo('Factor WOW propuesto', 'h2'), parrafo('Importar un estado de cuenta bancario real en PDF y registrar automáticamente los ingresos y gastos del mes, después de una revisión del usuario. Su implementación se plantea para la segunda etapa. La siguiente página detalla el flujo y las herramientas que se evaluarán; en esta entrega solo está la interfaz de muestra.')]
contenido += [parrafo('Referencias técnicas', 'h2'), parrafo('pub.dev/packages/fl_chart<br/>pub.dev/packages/provider<br/>api.flutter.dev/flutter/material/ExpansionTile-class.html<br/>api.flutter.dev/flutter/material/Tooltip-class.html', 'pequeno'), PageBreak()]

contenido += [parrafo('Factor WOW: del PDF a tus movimientos', 'h1')]
contenido += [parrafo('La idea del equipo', 'h2'), parrafo('El usuario podrá importar un estado de cuenta real en PDF y Saldo identificará los ingresos y gastos correspondientes al mes o periodo del documento. Después de revisar y confirmar la información, se registrarán los movimientos en la aplicación y se actualizarán el balance y los reportes. Así se evita capturar cada operación manualmente, conservando también esa opción.')]
contenido += [parrafo('Flujo previsto para la segunda etapa', 'h2')]
for texto in [
    '<b>1. Elegir el documento.</b> Seleccionar desde el teléfono el PDF del estado de cuenta y reconocer su banco y periodo.',
    '<b>2. Leer el contenido.</b> Extraer el texto de los PDF digitales. Si las páginas son imágenes escaneadas, evaluar su conversión a imágenes y reconocimiento óptico de caracteres (OCR).',
    '<b>3. Reconocer las operaciones.</b> Obtener fecha, descripción, importe y tipo de movimiento (ingreso o gasto), sin confundir encabezados, saldos o totales del documento con transacciones.',
    '<b>4. Revisar antes de registrar.</b> Mostrar las operaciones detectadas; permitir corregir datos dudosos, descartar filas y revisar posibles duplicados. Las categorías podrán sugerirse para su confirmación.',
    '<b>5. Importar el periodo.</b> Al confirmar, guardar el conjunto de movimientos en SQLite y actualizar el historial, el balance y las gráficas de la aplicación.',
]:
    contenido += [parrafo(texto)]
contenido += [parrafo('Bancos y alcance gradual', 'h2'), parrafo('La meta es aceptar estados de cuenta de bancos como Santander, BBVA (antes Bancomer), Scotiabank y otros. Como cada banco puede usar columnas y formatos distintos, primero se probará un formato concreto y después se ampliará la compatibilidad. No se garantiza todavía la lectura correcta de cualquier banco, ni de todos los PDF escaneados o protegidos.')]
contenido += [parrafo('Herramientas de Flutter por evaluar', 'h2'), parrafo('<b>file_picker:</b> selección del PDF local. <b>pdfrx / pdfrx_engine:</b> lectura y extracción del texto de páginas PDF. <b>google_mlkit_text_recognition:</b> posible apoyo de OCR para páginas convertidas a imágenes. Estas herramientas cubren partes del flujo; el equipo desarrollará las reglas que conviertan el texto bancario en movimientos. Son opciones de evaluación, no paquetes ya instalados ni una integración terminada.')]
contenido += [parrafo('Estado actual y referencias', 'h2'), parrafo('Entrega 1: pantalla Estados de cuenta y revisión ilustrativa. Etapa 2: implementación y pruebas de la importación real. El procesamiento se plantea de forma local, sin vincular credenciales bancarias.', 'pequeno'), parrafo('pub.dev/packages/file_picker<br/>pub.dev/packages/pdfrx<br/>pub.dev/documentation/pdfrx_engine/latest/pdfrx_engine/PdfPage/loadText.html<br/>pub.dev/packages/google_mlkit_text_recognition', 'pequeno'), PageBreak()]

capturas = [
    ('01_login', '01 / Inicio de sesión', 'Acceso, contraseña visible u oculta y recuperación. La autenticación está pendiente; el botón de muestra entra a la app.'),
    ('02_registro', '02 / Registro', 'Formulario con nombre, correo, contraseña y validación. El aviso aclara que todavía no se crean cuentas.'),
    ('03_inicio', '03 / Inicio', 'Balance calculado a partir de los movimientos de ejemplo, resumen de ingresos/gastos y acceso al historial.'),
    ('04_movimientos', '04 / Movimientos', 'Historial con búsqueda y filtros por tipo. Tocar una fila abre la edición; el botón + abre un formulario nuevo.'),
    ('05_presupuestos', '05 / Presupuestos', 'Límites por categoría, consumo y disponible. El botón + y las tarjetas permiten modificar límites de la muestra.'),
    ('06_reportes', '06 / Reportes', 'Gráficas de dona y barras con fl_chart. Los periodos cambian el histórico ilustrativo y exportar abre una alerta.'),
    ('07_nuevo_movimiento', '07 / Captura y edición', 'Monto, categoría, fecha y nota. Valida los campos y modifica datos temporales. La edición también permite eliminar.'),
    ('08_ajustes', '08 / Ajustes', 'Modo oscuro global, privacidad, accesos a pantallas y cierre de sesión de muestra. Acerca de usa ExpansionTile.'),
    ('09_categorias', '09 / Categorías', 'Lista de categorías y formulario de creación con nombre, color e icono. Los cambios solo duran durante la sesión.'),
    ('10_importacion', '10 / Estados de cuenta', 'Interfaz del futuro factor WOW. PDF/CSV y ejemplo de revisión. La lectura de archivos se indica como pendiente.'),
    ('11_alertas', '11 / Alertas', 'Avisos de muestra que se marcan leídos, interruptores y umbral. La programación real de notificaciones está pendiente.'),
    ('12_ajustes_oscuro', '12 / Tema oscuro', 'El ajuste cambia el tema de la aplicación mediante Provider, sin duplicar pantallas ni estilos individuales.'),
    ('13_inicio_oscuro', '13 / Inicio en oscuro', 'El tema se conserva al regresar a otra pantalla. SafeArea y márgenes protegen el contenido del borde del iPhone.'),
    ('14_categoria_nueva', '14 / Nueva categoría', 'Controles de nombre, color e icono en la parte inferior de Categorías. El botón valida nombres vacíos o repetidos.'),
    ('15_importacion_revision', '15 / Revisión de muestra', 'El usuario puede desplegar un ejemplo y confirmar que lo revisó. Importar todavía muestra una alerta de función pendiente.'),
    ('16_reportes_historico', '16 / Histórico por periodo', 'La gráfica de barras redibuja valores ilustrativos al elegir Mes, Trimestre o Año.'),
    ('17_menu_lateral', '17 / Menú lateral', 'Acceso alternativo a las pantallas principales y complementarias. Se conserva la navegación por rutas del equipo.'),
    ('18_funcion_pendiente', '18 / Avisos claros', 'Los botones de integraciones futuras abren diálogos que explican qué harán y que todavía están pendientes.'),
    ('19_acerca_de', '19 / Información desplegable', 'ExpansionTile abre y cierra los detalles de Saldo. Un ejemplo concreto del widget adicional usado en esta entrega.'),
]

for inicio in range(0, len(capturas), 3):
    grupo = capturas[inicio:inicio + 3]
    contenido += [parrafo('Pantallas de la aplicación', 'h1'), parrafo('Capturas reales en iPhone 17 Pro · iOS Simulator', 'etiqueta'), Spacer(1, 12)]
    celdas = []
    for archivo, titulo, descripcion in grupo:
        ruta = SALIDA / 'capturas' / f'{archivo}.png'
        if not ruta.exists():
            raise FileNotFoundError(f'Falta la captura real: {ruta}')
        imagen = Image(str(ruta))
        ancho = 155
        imagen.drawHeight = imagen.imageHeight * ancho / imagen.imageWidth
        imagen.drawWidth = ancho
        celdas.append([imagen, Spacer(1, 14), parrafo(titulo, 'h2'), parrafo(descripcion, 'pequeno')])
    while len(celdas) < 3:
        celdas.append([Spacer(1, 1)])
    tabla = Table([celdas], colWidths=[170, 170, 170], hAlign='LEFT')
    tabla.setStyle(TableStyle([('VALIGN', (0, 0), (-1, -1), 'TOP'), ('LEFTPADDING', (0, 0), (-1, -1), 0), ('RIGHTPADDING', (0, 0), (-1, -1), 15)]))
    contenido += [tabla]
    if inicio + 3 >= len(capturas):
        contenido += [Spacer(1, 16), parrafo('Cómo presentar la navegación', 'h2'), parrafo('Entrar a la muestra; recorrer las cuatro pestañas; abrir captura, categorías, importación y alertas; activar modo oscuro y regresar al inicio. Mostrar una alerta de función pendiente. El video lo grabará el equipo y debe durar menos de dos minutos.')]
    contenido += [PageBreak()]

contenido += [parrafo('Cierre de la primera etapa', 'h1')]
contenido += [parrafo('Verificación realizada', 'h2'), parrafo('Formateo con dart format ., análisis con flutter analyze y pruebas con flutter test. Además se ejecutó un recorrido en el simulador para revisar navegación y generar las capturas. La carpeta de pruebas permite repetir estas comprobaciones.')]
contenido += [parrafo('Pendientes para la siguiente entrega', 'h2'), parrafo('Autenticación, SQLite, persistencia de preferencias, exportación CSV, importación real de archivos y notificaciones locales. Los botones relacionados muestran una explicación; no se presentan como funciones ya integradas.')]
contenido += [parrafo('Conclusiones individuales', 'h2'), parrafo('Borradores sugeridos para revisión de cada integrante. Deben ajustarse a lo que realmente aprendió y realizó cada persona antes de entregar.', 'pequeno')]
for nombre, texto in [
    ('David Valdez Martinez', 'Con esta parte me quedó más claro cómo dividir una app en pantallas y componentes sin poner todo en main. Lo que más trabajo puede dar es que los espacios y colores se vean parejos en todas las vistas. Me gustó que ya se pueda recorrer la idea completa, aunque los datos todavía sean de ejemplo.'),
    ('Vittorio Catino', 'La neta, ver la idea del mockup ya en el iPhone está muy padre. Aquí lo importante para mí es entender cómo se conectan las pantallas y cómo Provider hace que el modo oscuro cambie en toda la app. Lo más enredado fue cuidar que cada botón tuviera una respuesta y que nada se saliera de la pantalla. Todavía falta la parte de guardar de verdad, pero esta primera entrega ya nos deja una base para seguirle metiendo mano.'),
    ('David Vela', 'Esta entrega me ayudó a aterrizar mejor la navegación que ya habíamos empezado en el repo. Tener archivos separados hace más fácil ubicar qué cambiar y revisar el trabajo entre todos. Me gustó conectar el menú con las pantallas y ver los reportes. Para lo que sigue toca mantener esta organización y conectar los datos sin romper lo que ya funciona.'),
]:
    contenido += [parrafo(nombre, 'h2'), parrafo(escape(texto))]
contenido += [parrafo('Revisión antes de subir', 'h2'), parrafo('Revisar las conclusiones, agregar el video del equipo al ZIP y confirmar la rama con los demás integrantes. La entrega de Canvas incluye lib, pubspec.yaml y este reporte. El nombre e icono nativos también están incluidos como recurso adicional.')]

documento = SimpleDocTemplate(str(SALIDA / 'reporte_entrega1.pdf'), pagesize=A4, rightMargin=42, leftMargin=42, topMargin=42, bottomMargin=56, title='Saldo - Primera entrega del proyecto final', author='David Valdez Martinez, Vittorio Catino y David Vela')
documento.build(contenido, onFirstPage=pie, onLaterPages=pie)
print(SALIDA / 'reporte_entrega1.pdf')
