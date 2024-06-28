import 'package:webview_flutter/webview_flutter.dart';

import '../config.dart';
import '../funciones_generales.dart';
import 'package:flutter/material.dart';
class Faq extends StatelessWidget {
  final ValueChanged<Map>? onChanged;
  const Faq({ Key ? key,  this.onChanged }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: btnAtras3(context),
        title: Text("Preguntas frecuentes",style:TextStyle(color: Color(colorRojo),fontSize: 20,fontWeight: FontWeight.bold))
        ,
    ),

   

    body: WebView(
      initialUrl: "$BASE_URL/api_rapida.php?evento=getPage&page_id=2",
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
     
    ),

    );


  }
}