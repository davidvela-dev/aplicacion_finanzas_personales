import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/tema.dart';
import '../models/categoria.dart';
import '../models/movimiento.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/profile_photo_service.dart';

class FinanzasProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? _uid;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _movSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _catSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _presSub;

  Usuario? usuario;
  List<Movimiento> movimientos = [];
  List<Categoria> categorias = [];
  final Map<String, double> presupuestos = {};
  bool cargando = true;
  String? error;

  final Map<String, dynamic> _demoPrefs = {};
  final Set<String> alertasLeidas = {};

  bool get esDemo => _uid == null || _uid!.isEmpty;

  // ---- Compatibilidad con vistas ----
  bool get modoOscuro =>
      usuario?.modoOscuro ?? (_demoPrefs['modoOscuro'] as bool?) ?? false;
  bool get ocultarMontos =>
      usuario?.ocultarMontos ?? (_demoPrefs['ocultarMontos'] as bool?) ?? false;
  bool get avisarLimite =>
      usuario?.avisarLimite ?? (_demoPrefs['avisarLimite'] as bool?) ?? true;
  bool get recordatorio =>
      usuario?.recordatorio ?? (_demoPrefs['recordatorio'] as bool?) ?? false;
  double get umbral =>
      usuario?.umbral ?? (_demoPrefs['umbral'] as double?) ?? 80;
  String get nombre =>
      usuario?.nombre ?? (_demoPrefs['nombre'] as String?) ?? 'Invitado';
  String? get fotoPath => usuario?.fotoPath;
  String get deviceToken => usuario?.deviceToken ?? '';
  String get email => usuario?.email ?? '';
  String? get uid => _uid;

  // ---- Cálculos ----
  double get ingresos =>
      movimientos.where((m) => m.esIngreso).fold(0.0, (p, c) => p + c.monto);
  double get gastos =>
      movimientos.where((m) => !m.esIngreso).fold(0.0, (p, c) => p + c.monto);
  double get balance => ingresos - gastos;

  double gastoCategoria(String cat) =>
      movimientos.where((m) => !m.esIngreso && m.categoria == cat).fold(
            0.0,
            (p, c) => p + c.monto,
          );

  Categoria? categoria(String nombreCat) {
    try {
      return categorias.firstWhere((c) => c.nombre == nombreCat);
    } catch (_) {
      return null;
    }
  }

  double get limiteTotal => presupuestos.values.fold(0.0, (p, c) => p + c);

  // ---- Comparativas mensuales ----
  double gastoMes(DateTime referencia) => movimientos
      .where(
        (m) =>
            !m.esIngreso &&
            m.fecha.year == referencia.year &&
            m.fecha.month == referencia.month,
      )
      .fold(0.0, (p, c) => p + c.monto);

  double get gastoMesActual => gastoMes(DateTime.now());

  double get gastoMesAnterior {
    final ahora = DateTime.now();
    return gastoMes(DateTime(ahora.year, ahora.month - 1, 1));
  }

  double get variacionMensual {
    final anterior = gastoMesAnterior;
    if (anterior <= 0) return 0;
    return (gastoMesActual - anterior) / anterior * 100;
  }

  // ---- Agregaciones ----
  List<({DateTime dia, double monto})> gastoDiario({int dias = 7}) {
    final hoy = DateTime.now();
    final inicio = DateTime(hoy.year, hoy.month, hoy.day)
        .subtract(Duration(days: dias - 1));
    return List.generate(dias, (i) {
      final dia = inicio.add(Duration(days: i));
      final fin = dia.add(const Duration(days: 1));
      final monto = movimientos
          .where(
            (m) =>
                !m.esIngreso && !m.fecha.isBefore(dia) && m.fecha.isBefore(fin),
          )
          .fold(0.0, (p, c) => p + c.monto);
      return (dia: dia, monto: monto);
    });
  }

  List<({DateTime mes, double monto})> gastoMensual({int meses = 6}) {
    final hoy = DateTime.now();
    return List.generate(meses, (i) {
      final mes = DateTime(hoy.year, hoy.month - (meses - 1 - i), 1);
      final sig = DateTime(mes.year, mes.month + 1, 1);
      final monto = movimientos
          .where(
            (m) =>
                !m.esIngreso && !m.fecha.isBefore(mes) && m.fecha.isBefore(sig),
          )
          .fold(0.0, (p, c) => p + c.monto);
      return (mes: mes, monto: monto);
    });
  }

  List<({DateTime trimestre, double monto})> gastoTrimestral({
    int trimestres = 4,
  }) {
    final hoy = DateTime.now();
    final triActual = (hoy.month - 1) ~/ 3;
    final globalActual = hoy.year * 4 + triActual;
    return List.generate(trimestres, (i) {
      final global = globalActual - (trimestres - 1 - i);
      final year = global ~/ 4;
      final triIdx = global % 4;
      final inicio = DateTime(year, triIdx * 3 + 1, 1);
      final fin = DateTime(year, triIdx * 3 + 4, 1);
      final monto = movimientos
          .where(
            (m) =>
                !m.esIngreso &&
                !m.fecha.isBefore(inicio) &&
                m.fecha.isBefore(fin),
          )
          .fold(0.0, (p, c) => p + c.monto);
      return (trimestre: inicio, monto: monto);
    });
  }

  List<({DateTime anio, double monto})> gastoAnual({int anios = 3}) {
    final hoy = DateTime.now();
    return List.generate(anios, (i) {
      final y = hoy.year - (anios - 1 - i);
      final inicio = DateTime(y, 1, 1);
      final fin = DateTime(y + 1, 1, 1);
      final monto = movimientos
          .where(
            (m) =>
                !m.esIngreso &&
                !m.fecha.isBefore(inicio) &&
                m.fecha.isBefore(fin),
          )
          .fold(0.0, (p, c) => p + c.monto);
      return (anio: inicio, monto: monto);
    });
  }

  // ---- Ciclo de vida ----
  void bind(String uid) {
    if (_uid == uid) return;
    _uid = uid;
    cargando = true;
    notifyListeners();

    _suscribirPerfil(uid);
    _suscribirMovimientos(uid);
    _suscribirCategorias(uid);
    _suscribirPresupuestos(uid);
  }

  void _suscribirPerfil(String uid) {
    _userSub?.cancel();
    if (uid.isEmpty) return;
    _userSub = _db.collection('usuarios').doc(uid).snapshots().listen((snap) {
      if (!snap.exists) return;
      usuario = Usuario.fromMap(uid, snap.data()!);
      notifyListeners();
    });
  }

  void _suscribirMovimientos(String uid) {
    _movSub?.cancel();
    if (uid.isEmpty) return;
    _movSub = _db
        .collection('usuarios')
        .doc(uid)
        .collection('movimientos')
        .orderBy('fecha', descending: true)
        .snapshots()
        .listen(
      (snap) {
        movimientos = snap.docs.map(Movimiento.fromDoc).toList();
        _marcarListo();
        notifyListeners();
      },
      onError: (Object e) {
        error = 'No se pudieron cargar los movimientos: $e';
        _marcarListo();
        notifyListeners();
      },
    );
  }

  void _suscribirCategorias(String uid) {
    _catSub?.cancel();
    if (uid.isEmpty) {
      // Demo: seed local y listo
      if (categorias.isEmpty) {
        categorias = List.from(_categoriasPorDefecto);
      }
      _marcarListo();
      notifyListeners();
      return;
    }
    _catSub = _db
        .collection('usuarios')
        .doc(uid)
        .collection('categorias')
        .snapshots()
        .listen(
      (snap) async {
        categorias = snap.docs.map(Categoria.fromDoc).toList();
        if (categorias.isEmpty) {
          await _sembrarCategorias(uid);
        }
        _marcarListo();
        notifyListeners();
      },
      onError: (Object e) {
        error = 'No se pudieron cargar las categorías: $e';
        _marcarListo();
        notifyListeners();
      },
    );
  }

  void _suscribirPresupuestos(String uid) {
    _presSub?.cancel();
    if (uid.isEmpty) return;
    _presSub = _db
        .collection('usuarios')
        .doc(uid)
        .collection('presupuestos')
        .snapshots()
        .listen(
      (snap) {
        presupuestos.clear();
        for (final doc in snap.docs) {
          final data = doc.data();
          final cat = (data['categoria'] as String?) ?? doc.id;
          final monto = (data['monto'] as num?)?.toDouble() ?? 0;
          presupuestos[cat] = monto;
        }
        notifyListeners();
      },
      onError: (Object e) {
        error = 'No se pudieron cargar los presupuestos: $e';
        notifyListeners();
      },
    );
  }

  void _marcarListo() {
    if (cargando) {
      cargando = false;
      notifyListeners();
    }
  }

  // ---- Adaptadores ----
  Future<void> iniciarSesion(String correo, String clave) async {
    await AuthService.iniciarConCorreo(correo, clave);
  }

  Future<void> guardarMovimiento(Movimiento m) async {
    if (m.id == null) {
      await agregarMovimiento(m);
    } else {
      await actualizarMovimiento(m);
    }
  }

  Future<void> agregarCategoria(Categoria c) => crearCategoria(c);

  Future<void> cambiarTema(bool v) => setModoOscuro(v);
  Future<void> cambiarPrivacidad(bool v) => setOcultarMontos(v);
  Future<void> cambiarAviso(bool v) => setAvisarLimite(v);
  Future<void> cambiarUmbral(double v) => setUmbral(v);
  Future<void> cambiarRecordatorio(bool v) => setRecordatorio(v);

  void leerAlerta(String clave) {
    alertasLeidas.add(clave);
    notifyListeners();
  }

  // ---- CRUD movimientos ----
  Future<void> agregarMovimiento(Movimiento m) async {
    if (esDemo) {
      final nuevo = Movimiento(
        id: 'demo-${DateTime.now().microsecondsSinceEpoch}',
        titulo: m.titulo,
        categoria: m.categoria,
        monto: m.monto,
        fecha: m.fecha,
        esIngreso: m.esIngreso,
      );
      movimientos = [nuevo, ...movimientos]
        ..sort((a, b) => b.fecha.compareTo(a.fecha));
      notifyListeners();
      return;
    }
    await _db
        .collection('usuarios')
        .doc(_uid)
        .collection('movimientos')
        .add(m.toMap());
  }

  Future<void> actualizarMovimiento(Movimiento m) async {
    if (m.id == null) throw ArgumentError('El movimiento no tiene id.');
    if (esDemo) {
      movimientos = [
        for (final x in movimientos)
          if (x.id == m.id) m else x,
      ]..sort((a, b) => b.fecha.compareTo(a.fecha));
      notifyListeners();
      return;
    }
    await _db
        .collection('usuarios')
        .doc(_uid)
        .collection('movimientos')
        .doc(m.id)
        .update(m.toMap());
  }

  Future<void> eliminarMovimiento(String id) async {
    if (esDemo) {
      movimientos = movimientos.where((m) => m.id != id).toList();
      notifyListeners();
      return;
    }
    await _db
        .collection('usuarios')
        .doc(_uid)
        .collection('movimientos')
        .doc(id)
        .delete();
  }

  // ---- CRUD categorías ----
  /// Crea una categoría. En modo demo se agrega en memoria; en real se guarda
  /// en Firestore (`usuarios/{uid}/categorias/{autoId}`).
  Future<void> crearCategoria(Categoria c) async {
    if (esDemo) {
      final nueva = c.copyWith(
        id: 'demo-${DateTime.now().microsecondsSinceEpoch}',
      );
      categorias = [...categorias, nueva];
      notifyListeners();
      return;
    }
    await _db
        .collection('usuarios')
        .doc(_uid)
        .collection('categorias')
        .add(c.toMap());
  }

  /// Elimina la categoría y, si existe, su presupuesto asociado.
  Future<void> eliminarCategoria(String id) async {
    if (esDemo) {
      categorias = categorias.where((c) => c.id != id).toList();
      notifyListeners();
      return;
    }
    // Preservar el nombre antes de borrar, para eliminar presupuesto asociado.
    final encontrada = categorias.where((c) => c.id == id).firstOrNull;
    await _db
        .collection('usuarios')
        .doc(_uid)
        .collection('categorias')
        .doc(id)
        .delete();
    if (encontrada != null && presupuestos.containsKey(encontrada.nombre)) {
      await _db
          .collection('usuarios')
          .doc(_uid)
          .collection('presupuestos')
          .doc(encontrada.nombre)
          .delete();
    }
  }

  // ---- CRUD presupuestos ----
  Future<void> guardarPresupuesto(String categoria, double monto) async {
    presupuestos[categoria] = monto;
    notifyListeners();
    if (esDemo) return;
    try {
      await _db
          .collection('usuarios')
          .doc(_uid)
          .collection('presupuestos')
          .doc(categoria)
          .set({'categoria': categoria, 'monto': monto});
    } catch (e) {
      error = 'No se pudo guardar el presupuesto: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> eliminarPresupuesto(String categoria) async {
    presupuestos.remove(categoria);
    notifyListeners();
    if (esDemo) return;
    try {
      await _db
          .collection('usuarios')
          .doc(_uid)
          .collection('presupuestos')
          .doc(categoria)
          .delete();
    } catch (e) {
      error = 'No se pudo eliminar el presupuesto: $e';
      notifyListeners();
      rethrow;
    }
  }

  // ---- Preferencias ----
  Future<void> setModoOscuro(bool v) => _updatePerfil({'modoOscuro': v});
  Future<void> setOcultarMontos(bool v) => _updatePerfil({'ocultarMontos': v});
  Future<void> setAvisarLimite(bool v) => _updatePerfil({'avisarLimite': v});
  Future<void> setRecordatorio(bool v) => _updatePerfil({'recordatorio': v});
  Future<void> setUmbral(double v) => _updatePerfil({'umbral': v});
  Future<void> setNombre(String v) => _updatePerfil({'nombre': v.trim()});

  Future<void> actualizarFoto(String? nuevoPath) async {
    final anterior = usuario?.fotoPath;
    if (anterior != null && anterior != nuevoPath) {
      await ProfilePhotoService.eliminar(anterior);
    }
    await _updatePerfil({'fotoPath': nuevoPath});
  }

  Future<void> _updatePerfil(Map<String, dynamic> data) async {
    _demoPrefs.addAll(data);
    if (usuario != null) {
      usuario = usuario!.copyWith(
        nombre: data['nombre'] as String?,
        modoOscuro: data['modoOscuro'] as bool?,
        ocultarMontos: data['ocultarMontos'] as bool?,
        avisarLimite: data['avisarLimite'] as bool?,
        recordatorio: data['recordatorio'] as bool?,
        umbral: (data['umbral'] as num?)?.toDouble(),
      );
    }
    notifyListeners();
    if (esDemo) return;
    try {
      await _db
          .collection('usuarios')
          .doc(_uid)
          .set(data, SetOptions(merge: true));
    } catch (_) {}
  }

  // ---- Cuenta ----
  Future<void> cerrarSesion() async {
    _unbind();
    await AuthService.cerrarSesion();
  }

  Future<void> eliminarCuenta() async {
    if (!esDemo) {
      await _db.collection('usuarios').doc(_uid).delete();
    }
    _unbind();
    await AuthService.eliminarCuenta();
  }

  // ---- Semilla ----
  static final List<Categoria> _categoriasPorDefecto = [
    Categoria.seed('Alimentación', Icons.restaurant_outlined, Colores.naranja),
    Categoria.seed('Transporte', Icons.directions_bus_outlined, Colores.azul),
    Categoria.seed('Entretenimiento', Icons.movie_outlined, Colores.morado),
    Categoria.seed('Vivienda', Icons.home_outlined, const Color(0xFF00838B)),
    Categoria.seed('Escuela', Icons.school_outlined, const Color(0xFF658048)),
    Categoria.seed('Ingreso', Icons.south_west, Colores.verde),
  ];

  Future<void> _sembrarCategorias(String uid) async {
    final col = _db.collection('usuarios').doc(uid).collection('categorias');
    final existing = await col.limit(1).get();
    if (existing.docs.isNotEmpty) return;
    final batch = _db.batch();
    for (final c in _categoriasPorDefecto) {
      batch.set(col.doc(), c.toMap());
    }
    await batch.commit();
  }

  void _unbind() {
    _userSub?.cancel();
    _movSub?.cancel();
    _catSub?.cancel();
    _presSub?.cancel();
    _userSub = null;
    _movSub = null;
    _catSub = null;
    _presSub = null;
    _uid = null;
    usuario = null;
    movimientos = [];
    categorias = [];
    presupuestos.clear();
    _demoPrefs.clear();
    alertasLeidas.clear();
    cargando = true;
    error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _userSub?.cancel();
    _movSub?.cancel();
    _catSub?.cancel();
    _presSub?.cancel();
    super.dispose();
  }
}
