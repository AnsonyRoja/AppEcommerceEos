import 'package:webview_flutter/webview_flutter.dart';

import '../config.dart';
import '../funciones_generales.dart';
import 'package:flutter/material.dart';

class Tdd extends StatelessWidget {
  final int? nroOrden;
  final String? monto;
  final ValueChanged<Map>? onChanged;
  const Tdd({ Key? key, this.onChanged, this.nroOrden, this.monto }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: btnAtras3(context),
        title: Text("Realizar pago en TDD",style:TextStyle(color: Color(colorRojo),fontSize: 20,fontWeight: FontWeight.bold))
        ,
    ),

    body: weba(),
    );


  }
  weba(){
    Map cabezera = Map();
    cabezera['orden']=nroOrden.toString();
    String a=double.parse(monto!).toStringAsFixed(2);
    return WebView(
      initialUrl: "$BASE_URL/mercantil/index.php?evento=inicio&nroFactura="+nroOrden.toString()+"&amount=$a",
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
          // Aquí puedes interactuar con el controlador del WebView si es necesario
        },
        onPageStarted: (String url) {
          // Manejar eventos cuando la página comienza a cargarse
        },
        onPageFinished: (String url) {
          // Manejar eventos cuando la página ha terminado de cargarse
        },
        navigationDelegate: (NavigationRequest request) {
          // Opcional: manejar la navegación de la página web
          return NavigationDecision.navigate;
        },
debuggingEnabled: true,
     
    );
  }
}