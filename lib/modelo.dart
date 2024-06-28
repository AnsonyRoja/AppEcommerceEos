import 'dart:convert';

import 'config.dart';
import 'funciones_generales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class ModeloTime{
  Map res= {};
  String evento = "";
  String url = "";

  String titulo = "";

  bool listandoProductos=false; //para evitar que mientras espera el await consulte mil veces
  Future listarProductosIA(context) async {

    evento='listarProductosIA';
    url = await UrlLogin(evento);
    await procesarEvento('get',120);
    if(res['success']==true) {
      return res['data'];
    }else{
      return null;
    }
  }
  Future<void> verificarSesionN(context) async {
    await  Future.delayed(const Duration(seconds: 3));
    evento='verificarSesion';
    url=await UrlLogin(evento);
    await procesarEvento('get',240);
    if(res['success']!=null) {
      if (res['success']) {
        await delData('user');
        await _setData(3);
        Phoenix.rebirth(context);
        Navigator.pushNamedAndRemoveUntil(context,'/', (Route<dynamic> route) => false);
       // print("SESSION INACTIVA");
      } else {
       // print("SESSION ACTIVA");
      }
    }

  }

  Future listarProductos() async {



      titulo = await getTitulo();
      print('Titulo $titulo');

      evento = await getEvento();
      print('Evento $evento');
      url =  UrlNoLogin(evento);
      print('url $url');
      if(evento=='listarFavoritos') {
        res = await peticionGetZlib(url);
        print('Esta es la respuesta $res');
      }else {
        await procesarEvento('get', 120);
      }

      return res;

  }
  Future listarCategorias() async{
    evento='listarCombos';
    url=await UrlLogin(evento);
    await procesarEvento('get', 480);
    return res;
  }
  Future listarPrecios() async{
    evento='listarPrecios';

    url=UrlNoLogin(evento);
    print('Esto es la url $url');
   var response = await procesarEvento('get', 480);
   print('Respuesta $response');
    return res;
  }
  Future listarCombos() async{
    evento='listarCombos';
    url=await UrlLogin(evento);
    await procesarEvento('get', 120);
    return res;
  }

  Future listarPublicidad(String tipo) async{
    evento='listarPublicidad&tipo=$tipo';
    url=UrlNoLogin(evento);
    print(url);
    await procesarEvento('get', 120);
    return res;
  }
  borrarRecordarClave() async {
    Map data = {};
    await saveData('recuerdo',data);
  }
  Future listarPublicidadFinal() async{
    evento='listarPublicidadFinal';
    url=await UrlLogin(evento);
    await procesarEvento('get', 120);
    return res;
  }
  Future listarPublicidadMedio() async{
    evento='listarPublicidadMedio';
    url=await UrlLogin(evento);
    await procesarEvento('get', 120);
    return res;
  }
  Future listarProductosNuevo(String tipo) async {

      print('Esto es el tipos $tipo');
    switch(tipo){
      
      case 'listarProductosConPromocion':
      
        evento='listarProductosConPromocion';
        break;
      case 'listarProductos':
        evento='listarProductos';
        break;
      case 'compraFacil':
        evento='listarProductos';
        break;
      case 'ia':
        evento='listarProductosIA';
        break;
      case 'promocion':
        evento='listarProductosPromocion';
      break;
      default:
        titulo = await getTitulo();
        evento = await getEvento();
    }
    url = UrlNoLogin(evento);
    

    if(evento=='listarFavoritos') {
      url = await UrlLogin(evento);
      res = await peticionGetZlib(url);

    }else {
      await procesarEvento('get', 120);
    }
    print(res);
    return res;

    

  }

  horasDisponiblesEntrega() async {
    evento='horasDisponiblesEntrega';
    url=UrlNoLogin(evento);
    await procesarEvento('get', 120);
    if (res['success']==true) {
      return res['data'];
    }else{
      return false;
    }
  }


  listarMetodosDePago() async {
    evento='listarMetodosDePago';
    url=await UrlLogin(evento);
    await procesarEvento('get', 240);
    if (res['success']==true) {
      return res['data'];
    }else{
      msj(res['msj_general']);
    }
  }

  listarBancosdelMetododePago(payment_methods_id) async {
    evento='listarBancosdelMetododePago&payment_methods_id=$payment_methods_id';
    url=await UrlLogin(evento);
    await procesarEvento('get', 240);
    if (res['success']==true) {
      return res['data'];
    }else{
      //print("aaaaaaaaaaaaaaaaaaaaaaa"+res['msj_general']);
      //msj(res['msj_general']);
      return null;
    }
  }
  envio() async {
    evento='recargoEnvio';
    url=UrlNoLogin(evento);
    await procesarEvento('get', 240);
    return res;
  }



  procesarEvento(tipo,int tiempoActualizacion) async {
    print('esto es el tipo $tipo y este es el tiempo de actualizacion $tiempoActualizacion');
    if(tipo=='get') {
      if (await getTiempo(tiempoActualizacion)) {
        //print("REAL : "+evento);
        print('Esto es la url despues del tiempoactualizacion $url');
        res=await peticionGetZlib(url);
        if(res['success']==true) {
          await _setData(tiempoActualizacion);
        }
      }else{
       // print("CACHE : "+evento);
        res=jsonDecode(await getData('data_$evento'));
      }
    }
  }
 Future<bool> getTiempo(int tiempoActualizacion) async {
  print('Esto es el evento en getTiempo $evento y el tiempo de actualización $tiempoActualizacion');

  DateTime time = DateTime.now();
  print('Esto es el tiempo actual $time');

  String? tiempo;
  try {
    tiempo = await getData('tiempo_$evento');
  } catch (e) {
    print('Error obteniendo tiempo: $e');
    tiempo = null;
  }

  if (tiempo != null && tiempo.isNotEmpty) {
    DateTime tiempoViejo = DateTime.parse(tiempo);
    if (time.isAfter(tiempoViejo)) {
      return true;
    } else {
      return false;
    }
  } else {
    await _setData(tiempoActualizacion);
    return true;
  }
}

Future<void> _setData(int tiempoActualizacion) async {
  DateTime time = DateTime.now().add(Duration(seconds: tiempoActualizacion));
  print('Guardando nuevo tiempo para $evento: $time');

  await saveData('data_$evento', res);
  await saveDataNoJson('tiempo_$evento', time.toString());
}
}