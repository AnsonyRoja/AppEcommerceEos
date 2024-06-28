import 'dart:convert';

import 'funciones_generales.dart';

const String BASE_URL = 'https://be3b-38-51-176-35.ngrok-free.app';
//const String BASE_URL = 'http://127.0.0.1:8000';
//const String BASE_URL_IMAGEN="http://127.0.0.1:8000/storage/";  //se usa para evitar CROSS
const String BASE_URL_IMAGEN = "https://be3b-38-51-176-35.ngrok-free.app/storage/"; //se usa para evitar CROSS

//const String BASE_URL = 'http://10.0.1.112';

Future<String> UrlLogin(String uri) async {
  print('entre por aqui en urlLogin ');
  Map user = await getUser();
  if (user != null) {
    if (user['id_sesion'] != null) {
      String id_session = user['id_sesion'] ?? 0;
      return "$BASE_URL/api_rapida.php?id_sesion=$id_session&evento=$uri";
    } else {
      return "$BASE_URL/api_rapida.php?id_sesion=0&evento='uuuuu'";
    }
  } else {
    return "$BASE_URL/api_rapida.php?id_sesion=0&evento='uuuuu'";
  }
}

String UrlNoLogin(String uri) {
  print('Entre aqui en listar precio');
  return "$BASE_URL/api_rapida.php?evento=$uri";
}

getUser() async {
  String user = await getData('user');
  return jsonDecode(user);
}
