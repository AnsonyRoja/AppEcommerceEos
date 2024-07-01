import 'dart:convert';
import 'package:flutter/material.dart';
import '/main.dart';
import '../funciones_generales.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthBlock with ChangeNotifier {
  Map resJson = {};

  AuthBlock() {
    _loadingType = 'default';
    setUser();
  }
  AuthService _authService = AuthService();

  // Index
  int _currentIndex = 1;
  int get currentIndex => _currentIndex;

  int _count = 0;
  int get count => _count;
  void incrementCarrito() {
    _count++;
    notifyListeners();
  }

  agregarCarrito(id, _cant) async {
    await setCarrito(id, _cant);
    notifyListeners();
  }

  actualizar() {
    notifyListeners();
  }

  getCarritob({contexto}) async {
    String res = await getData('carrito');
    print('Esto es la respuesta res $res');
    return jsonDecode(res);
  }

  cantCarrito() async {
    Map carrito = await getCarrito();
    print('Esto es el carrito en cant carrito $carrito');
    Map precios = jsonDecode(await getData('listarPrecios'));
    print('Esto es el precio en cantCarrito $precios');
    
    Map productos;
    int cant = 0;
    double totalD = 0.00;
    double totalB = 0.00;

    if (carrito['productos'] != null) {
      productos = carrito['productos'];
      productos.forEach((key, value) {
        if (value > 0) {
          cant += value as int;
          if (precios[key] != null) {
            totalD += double.parse(precios[key]['d']) * value;
            totalB += double.parse(precios[key]['b']) * value;
          }
        }
      });
      await saveDataNoJson('total', "$totalD / $totalB");
      return cant.toString();
    } else {
      return "0";
    }
  }

  totalCarrito() async {
    Map carrito = await getCarrito();
    Map precios = jsonDecode(await getData('listarPrecios'))['data'];
    Map productos;
    int cant = 0;
    double totalD = 0.00;
    double totalB = 0.00;

    if (carrito['productos'] != null) {
      productos = carrito['productos'];
      productos.forEach((key, value) {
        if (value > 0) {
          cant += value as int;
          if (precios[key] != null) {
            totalD += double.parse(precios[key]['d']) * value;
            totalB += double.parse(precios[key]['b']) * value;
          }
        }
      });
      return formatDolar.format(totalD) + " / " + formatBolivar.format(totalB);
    } else {
      return "0";
    }
  }

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // Loading
  bool _loading = false;
  String? _loadingType;
  bool get loading => _loading;
  String get loadingType => _loadingType!;
  set loading(bool loadingState) {
    _loading = loadingState;
    notifyListeners();
  }
  set loadingType(String loadingType) {
    _loadingType = loadingType;
    notifyListeners();
  }

  // Loading
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool isUserExist) {
    _isLoggedIn = isUserExist;
    notifyListeners();
  }

  // user
  Map _user = {};
  Map get user => _user;
  setUser() async {
    _user = await _authService.getUser();
    isLoggedIn = _user != null;
    notifyListeners();
  }

  login(UserCredential userCredential) async {
    loading = true;
    loadingType = 'login';
    bool res = await _authService.login(userCredential);
    loading = false;
    if (res) {
      await saveDataNoJson('noLogin', 'false');
      await setUser();
      return true;
    } else {
      return false;
    }
  }

  Future<Map> cambiarClavePublico(User user) async {
    loading = true;
    loadingType = 'cambiar_clave_publico';
    Map resJson = await _authService.cambiarClavePublico(user);
    loading = false;
    return resJson;
  }

  Future<Map> register(User user) async {
    loading = true;
    loadingType = 'register';
    Map resJson = await _authService.register(user);
    loading = false;
    return resJson;
  }

  Future<Map> recuperar(User user) async {
    loading = true;
    loadingType = 'recuperar';
    Map resJson = await _authService.enviarCodRecuperacion(user);
    loading = false;
    return resJson;
  }

  Future<Map> confirmarCorreo(User user) async {
    loading = true;
    loadingType = 'confirmar_correo';
    Map resJson = await _authService.confirmarCorreo(user);
    loading = false;
    return resJson;
  }

  Future<Map> confirmarCodRecuperacion(User user) async {
    loading = true;
    loadingType = 'confirmarCodRecuperacion';
    Map resJson = await _authService.confirmarCodRecuperacion(user);
    loading = false;
    return resJson;
  }

  logout() async {
    await _authService.logout();
    isLoggedIn = false;
    notifyListeners();
  }
}
