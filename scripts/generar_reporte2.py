import os
from fpdf import FPDF
from datetime import datetime

class ReporteEntrega2(FPDF):
    def header(self):
        # Ocultar el encabezado en la portada (página 1)
        if self.page_no() == 1:
            return
            
        self.set_font('helvetica', 'B', 10)
        self.set_text_color(22, 133, 104) # Verde Saldo
        self.cell(0, 10, 'Saldo - Reporte de Entrega 2 (Funcionalidad y Firebase)', border=False, align='R', new_x="LMARGIN", new_y="NEXT")
        self.ln(5)

    def footer(self):
        # Ocultar el pie de página en la portada (página 1)
        if self.page_no() == 1:
            return
            
        self.set_y(-15)
        self.set_font('helvetica', 'I', 8)
        self.set_text_color(128)
        self.cell(0, 10, f'Página {self.page_no()}', align='C', new_x="LMARGIN", new_y="NEXT")

    def portada(self):
        self.add_page()
        
        # 1. Reporte Técnico (centrado)
        self.set_y(50)
        self.set_font('helvetica', 'B', 24)
        self.set_text_color(21, 59, 50)
        self.cell(0, 10, 'Reporte Técnico', align='C', new_x="LMARGIN", new_y="NEXT")
        
        # 2. Saldo (centrado)
        self.set_font('helvetica', 'B', 36)
        self.set_text_color(22, 133, 104)
        self.cell(0, 20, 'SALDO', align='C', new_x="LMARGIN", new_y="NEXT")
        self.ln(10)
        
        # 3. Logo ITESO (centrado)
        y_logo = self.get_y()
        w_logo = 60
        x_logo = (self.w - w_logo) / 2
        
        # Lógica para encontrar el logo en la carpeta capturas
        ruta_logo = 'capturas/logo_iteso.png'
        if not os.path.exists(ruta_logo) and os.path.exists('entrega2/capturas/logo_iteso.png'):
            ruta_logo = 'entrega2/capturas/logo_iteso.png'
            
        try:
            self.image(ruta_logo, x=x_logo, y=y_logo, w=w_logo)
            self.set_y(y_logo + 65) # Mueve el cursor debajo del logo
        except Exception:
            self.set_font('helvetica', 'I', 12)
            self.set_text_color(150)
            self.cell(0, 60, f'[ Faltó el archivo {ruta_logo} ]', align='C', new_x="LMARGIN", new_y="NEXT")
        
        self.ln(5)
        
        # 4. Funcionalidad (centrado)
        self.set_font('helvetica', '', 16)
        self.set_text_color(100)
        self.cell(0, 10, 'Funcionalidad: Firebase, CRUD y Estado Global', align='C', new_x="LMARGIN", new_y="NEXT")
        
        # 5. Integrantes del equipo (hasta la derecha, hasta abajo)
        self.set_y(-50)
        self.set_font('helvetica', 'B', 14)
        self.set_text_color(21, 59, 50)
        self.cell(0, 8, 'Integrantes del equipo', align='R', new_x="LMARGIN", new_y="NEXT")
        
        self.set_font('helvetica', '', 12)
        self.set_text_color(50)
        self.cell(0, 6, 'David Valdez Martinez', align='R', new_x="LMARGIN", new_y="NEXT")
        self.cell(0, 6, 'Vittorio Catino', align='R', new_x="LMARGIN", new_y="NEXT")
        self.cell(0, 6, 'David Vela', align='R', new_x="LMARGIN", new_y="NEXT")

    def introduccion(self):
        self.add_page()
        
        # 1. Explicación del proyecto
        self.set_font('helvetica', 'B', 14)
        self.set_text_color(21, 59, 50)
        self.cell(0, 10, '¿Qué hace el proyecto?', new_x="LMARGIN", new_y="NEXT")
        self.set_font('helvetica', '', 11)
        self.multi_cell(0, 6, 
            "Saldo es una aplicación de finanzas personales diseñada para estudiantes y jóvenes profesionistas. "
            "Permite a los usuarios registrar ingresos y gastos diarios, organizarlos por categorías personalizadas, "
            "establecer presupuestos y visualizar métricas de su salud financiera. La app busca dar claridad "
            "económica sin requerir la vinculación directa de credenciales bancarias."
        )
        self.ln(5)

        # 2. Repositorio
        self.set_font('helvetica', 'B', 14)
        self.cell(0, 10, 'Repositorio de Código', new_x="LMARGIN", new_y="NEXT")
        self.set_font('helvetica', '', 11)
        self.cell(0, 6, 'Enlace: https://github.com/davidvela-dev/aplicacion_finanzas_personales', new_x="LMARGIN", new_y="NEXT")
        self.ln(10)

    def seccion_implementacion(self):
        self.set_font('helvetica', 'B', 16)
        self.set_text_color(21, 59, 50)
        self.cell(0, 10, 'Resumen de Implementación (Backend y Funcionalidad)', new_x="LMARGIN", new_y="NEXT")
        self.ln(3)
        
        self.set_font('helvetica', '', 11)
        texto = (
            "Para esta segunda entrega, la aplicación ha dejado de utilizar información 'hardcodeada' y "
            "ahora funciona de manera asíncrona conectada a una base de datos real.\n\n"
            "- Autenticación: Registro e inicio de sesión funcional con Firebase Auth (Correo y Google).\n"
            "- Base de datos: Uso de Cloud Firestore. La información de usuarios, categorías y movimientos "
            "se guarda y lee en tiempo real.\n"
            "- Device Token: Se genera y guarda un token UUID por dispositivo en el documento del usuario en Firestore.\n"
            "- Foto de Perfil: Permite selección desde la galería guardada localmente.\n"
            "- CRUD Funcional: La gestión de movimientos financieros permite Crear, Leer, Editar y Eliminar "
            "transacciones con impacto inmediato en el balance.\n"
            "- Pull to Refresh: Swipe down implementado en listas para recargar datos (ej. Movimientos).\n"
            "- Provider: Toda la estructura de estado global (FinanzasProvider) se rediseñó para reaccionar "
            "a los streams de Firebase."
        )
        self.multi_cell(0, 6, texto)
        self.ln(10)

        # 4. Tecnologías y Paquetes
        self.set_font('helvetica', 'B', 14)
        self.cell(0, 10, 'Tecnologías y Paquetes Utilizados', new_x="LMARGIN", new_y="NEXT")
        self.set_font('helvetica', '', 11)
        tech_texto = (
            "Tecnologías Principales:\n"
            "- Flutter y Dart (SDK)\n"
            "- Firebase Authentication (Auth y Google Sign-in)\n"
            "- Cloud Firestore (Base de datos NoSQL)\n\n"
            "Paquetes de pub.dev (dependencias adicionales):\n"
            "- provider: Manejo de estado global reactivo.\n"
            "- firebase_core / firebase_auth / cloud_firestore: Integración del backend.\n"
            "- fl_chart: Renderizado de las gráficas de donas y barras en reportes.\n"
            "- image_picker: Para la selección de fotos de perfil desde la galería.\n"
            "- google_sign_in: Integración nativa del inicio de sesión de Google."
        )
        self.multi_cell(0, 6, tech_texto)

    def seccion_factor_wow(self):
        self.add_page()
        self.set_font('helvetica', 'B', 16)
        self.set_text_color(21, 59, 50)
        self.cell(0, 10, 'Avance del Factor WOW', new_x="LMARGIN", new_y="NEXT")
        self.ln(3)

        self.set_font('helvetica', '', 11)
        wow_texto = (
            "Idea del Factor WOW: Permitir al usuario importar un estado de cuenta real en formato PDF o CSV, "
            "del cual Saldo identificará ingresos y gastos. Tras una revisión, el usuario podrá registrar "
            "operaciones masivamente sin tener que escribirlas una por una.\n\n"
            "Estado Actual: Ya se encuentra implementada la interfaz de entrada (pantalla de 'Estados de cuenta' y "
            "'Alertas') conectada a la navegación principal. El usuario puede ver la vista previa del flujo de importación, "
            "el cual será conectado al motor de procesamiento de archivos locales para la entrega final."
        )
        self.multi_cell(0, 6, wow_texto)
        self.ln(5)

    def seccion_capturas(self, carpeta):
        self.add_page()
        self.set_font('helvetica', 'B', 16)
        self.set_text_color(21, 59, 50)
        self.cell(0, 10, 'Evidencia Visual de Pantallas', new_x="LMARGIN", new_y="NEXT")
        self.ln(5)

        if not os.path.exists(carpeta):
            self.set_font('helvetica', 'I', 12)
            self.cell(0, 10, f'No se encontró la carpeta de capturas: {carpeta}', new_x="LMARGIN", new_y="NEXT")
            return

        # Filtrar solo imágenes (evitar intentar procesar carpetas ocultas u otros archivos)
        imagenes = [f for f in os.listdir(carpeta) if f.lower().endswith(('.png', '.jpg', '.jpeg')) and f != 'logo_iteso.png']
        imagenes.sort()

        if not imagenes:
            self.set_font('helvetica', 'I', 12)
            self.cell(0, 10, 'No hay imágenes.', new_x="LMARGIN", new_y="NEXT")
            return

        ancho_disponible = self.w - self.l_margin - self.r_margin

        # Procesar 00_database.png (Firebase) de forma independiente
        if '00_database.png' in imagenes:
            ruta_db = os.path.join(carpeta, '00_database.png')
            self.set_font('helvetica', 'B', 12)
            self.cell(0, 10, 'Firestore (Evidencia de datos en la nube)', new_x="LMARGIN", new_y="NEXT")
            self.set_font('helvetica', '', 10)
            self.multi_cell(0, 5, "Estructura de las colecciones 'usuarios', 'categorias' y 'movimientos' sin datos hardcodeados.")
            self.ln(2)
            
            try:
                w_img = ancho_disponible * 0.70
                x_center = self.l_margin + (ancho_disponible - w_img) / 2
                self.image(ruta_db, w=w_img, x=x_center)
            except Exception as e:
                self.cell(0, 10, f'Error al cargar imagen: {e}', new_x="LMARGIN", new_y="NEXT")
            
            imagenes.remove('00_database.png')
            self.ln(10)

        # Diccionario con las descripciones solicitadas
        descripciones = {
            '01_login.png': ('Login / Auth', 'Autenticación asíncrona validada con Firebase Auth y Google.'),
            '02_registro.png': ('Registro', 'Creación de cuenta y guardado de perfil y Token en Firestore.'),
            '03_inicio.png': ('Inicio (Dashboard)', 'Balance alimentado dinámicamente desde la base de datos.'),
            '04_movimientos.png': ('Historial (CRUD - Read)', 'Lectura de transacciones con soporte Swipe down (Refresh).'),
            '05_presupuestos.png': ('Presupuestos', 'Cálculos reactivos vía Provider usando datos reales.'),
            '06_reportes.png': ('Reportes Gráficos', 'Gráficas alimentadas de la clasificación de Firestore.'),
            '07_nuevo_movimiento.png': ('Crear (CRUD - Create)', 'Formulario para inyectar transacciones financieras a la DB.'),
            '08_ajustes.png': ('Ajustes y Modo Oscuro', 'Cambios globales de tema escuchados mediante Provider.'),
            '09_categorias.png': ('Categorías', 'Lista conectada a Firestore para organizar gastos.'),
            '10_importacion.png': ('Factor WOW', 'Interfaz del flujo de lectura masiva de PDF/CSV (En proceso).'),
            '11_alertas.png': ('Alertas WOW', 'Sistema visual de notificaciones presupuestales.'),
            '12_ajustes_oscuro.png': ('Tema Oscuro', 'Comprobación de variables de estado sin recargar la app.'),
            '13_inicio_oscuro.png': ('Inicio Dark', 'Lectura de base de datos conservando preferencias.'),
            '14_categoria_nueva.png': ('Crear Categoría', 'Formulario para agregar nuevas ramas al árbol en Firebase.'),
            '15_importacion_revision.png': ('Revisión WOW', 'Vista previa de movimientos extraídos a confirmar.'),
            '16_reportes_historico.png': ('Filtros', 'Redibujado asíncrono de gráficos por trimestre.'),
            '17_menu_lateral.png': ('Navegación', 'Drawer y rutas navegables 100% funcionales.'),
            '18_funcion_pendiente.png': ('Avisos', 'Validación de botones y navegación sin romper la UI.'),
            '19_acerca_de.png': ('Expansión', 'Uso de widgets asíncronos adicionales en la app.')
        }

        espacio_entre_imgs = 8
        ancho_img = (ancho_disponible - (espacio_entre_imgs * 2)) / 3

        # Grid de 3x3 con descripciones
        for i in range(0, len(imagenes), 3):
            grupo = imagenes[i:i+3]
            alto_estimado_total = (ancho_img * 2.16) + 25 
            
            if self.get_y() + alto_estimado_total > self.page_break_trigger:
                self.add_page()
                self.set_font('helvetica', 'B', 14)
                self.set_text_color(21, 59, 50)
                self.cell(0, 10, 'Evidencia Visual (Continuación)', new_x="LMARGIN", new_y="NEXT")
                self.ln(5)

            y_actual = self.get_y()
            
            for j, img in enumerate(grupo):
                ruta = os.path.join(carpeta, img)
                x_offset = self.l_margin + j * (ancho_img + espacio_entre_imgs)
                
                titulo, desc = descripciones.get(img, (img, 'Pantalla de la aplicación funcional.'))
                
                # Renderizar Título
                self.set_xy(x_offset, y_actual)
                self.set_font('helvetica', 'B', 8)
                self.multi_cell(ancho_img, 4, titulo, align='C')
                y_imagen = y_actual + 10
                
                # Renderizar la imagen
                try:
                    self.image(ruta, x=x_offset, y=y_imagen, w=ancho_img)
                    alto_img_real = ancho_img * 2.16
                except Exception as e:
                    self.set_xy(x_offset, y_imagen)
                    self.cell(ancho_img, 10, 'Error de imagen', align='C', new_x="LMARGIN", new_y="NEXT")
                    alto_img_real = 20
                
                # Renderizar Descripción
                self.set_xy(x_offset, y_imagen + alto_img_real + 2)
                self.set_font('helvetica', '', 7)
                self.multi_cell(ancho_img, 3, desc, align='C')
            
            self.set_y(y_actual + alto_estimado_total + 10)

    def seccion_conclusiones(self):
        self.add_page()
        self.set_font('helvetica', 'B', 16)
        self.set_text_color(21, 59, 50)
        self.cell(0, 10, 'Conclusiones Individuales', new_x="LMARGIN", new_y="NEXT")
        self.ln(5)

        conclusiones = [
            ("David Valdez Martinez", "En esta entrega comprendí la complejidad de conectar la UI con un backend en tiempo real. La implementación del CRUD me ayudó a entender cómo los datos asíncronos requieren un manejo de estado cuidadoso para que la pantalla no se quede en blanco mientras carga. Ver que la app ya guarda información que no se borra al cerrar el simulador fue un gran avance."),
            ("Vittorio Catino", "Configurar Firebase Auth y conectar Google Sign-In fue retador pero muy satisfactorio. Me quedó muy claro cómo funciona Provider cuando lo conectas a los streams de Firestore, logrando que el balance cambie automáticamente cuando sumamos un gasto sin tener que recargar la vista a mano. Ya tenemos un esqueleto robusto para el WOW."),
            ("David Vela", "Pasar de datos estáticos a modelos reales requirió refactorizar varias pantallas, pero esto demostró la importancia de separar bien la lógica de la vista. La implementación de la galería local para la foto de perfil y la generación del token UUID fortalecen la identidad de usuario en nuestra app, dejándonos listos para la entrega final.")
        ]

        for nombre, texto in conclusiones:
            self.set_font('helvetica', 'B', 12)
            self.cell(0, 8, nombre, new_x="LMARGIN", new_y="NEXT")
            self.set_font('helvetica', '', 11)
            self.multi_cell(0, 5, texto)
            self.ln(8)


def generar_pdf():
    pdf = ReporteEntrega2()
    
    # 1. Portada completamente separada
    pdf.portada()
    
    # 2. Introducción y repositorio
    pdf.introduccion()
    
    # 3. Requisitos técnicos, Firebase y Paquetes
    pdf.seccion_implementacion()
    
    # 4. Explicación del Factor WOW
    pdf.seccion_factor_wow()
    
    # 5. Capturas de pantalla
    carpeta_capturas = 'entrega2/capturas' # O 'capturas' dependiendo de tu estructura
    pdf.seccion_capturas(carpeta_capturas)
    
    # 6. Conclusiones individuales
    pdf.seccion_conclusiones()
    
    # Guardar documento
    os.makedirs('entrega2', exist_ok=True)
    output_path = 'entrega2/reporte_entrega2_final.pdf'
    pdf.output(output_path)
    print(f"Reporte final generado exitosamente en: {output_path}")

if __name__ == '__main__':
    generar_pdf()