import 'dart:convert';

import 'package:Pide/app_theme.dart';
import 'package:Pide/home/ordenes.dart';

import 'modelo.dart';

import 'biowallet.dart';
import 'blocks/nuevo_proveedor.dart';
import 'config.dart';
import 'direccion_habitacion.dart';
import 'funciones_generales.dart';
import 'home/combo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'auth/auth.dart';
import 'blocks/auth_block.dart';
import 'categorise.dart';
import 'home/home.dart';
import 'product_detail.dart';
import 'settings.dart';
import 'shop/shop.dart';
import 'shop/prueba.dart';
import 'shop/prueba3.dart';
import 'shop/buscador.dart';
import 'carrito.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'cambiarClave.dart';
import 'direcciones.dart';
import 'home/producto.dart';
import 'listadoDirecciones.dart';
import 'mi_perfil.dart';
import 'package:responsive_framework/responsive_framework.dart';


class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
 


    runApp(MainApp());
  }
}

void main() {
  AppInitializer.initialize();

}


// Future<void> mains() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final Locale locale = Locale('eu', 'ES'); //estaba solo en: en

// //final bool vistaPrincipal=await Analizar();
//   runApp(
//     Phoenix(
//       child: MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => AuthBlock()),
//         ],
//         child: MaterialApp(
//           builder: (context, widget) => ResponsiveBreakpoints.builder(
             
//               breakpoints: [
//                 const Breakpoint(start: 0, end: 450, name: MOBILE),
//           const Breakpoint(start: 451, end: 800, name: TABLET),
//           const Breakpoint(start: 801, end: 1200, name: DESKTOP),
//           const Breakpoint(start: 1201, end: double.infinity, name: '4K'),
//               ],
//               child: Container(color: Color(0xFFF5F5F5))),
//           localizationsDelegates: const [
//             GlobalMaterialLocalizations.delegate,
//             GlobalWidgetsLocalizations.delegate,
//             GlobalCupertinoLocalizations.delegate,
//           ],
//           supportedLocales: const [Locale('es', 'ES')],
//           locale: locale,
//           debugShowCheckedModeBanner: false,
//           theme: ThemeData(
//             primaryColor: Color(0xff80bc00),
//             secondaryHeaderColor: Colors.lightBlue[900],

//             //fontFamily: locale.languageCode == 'ar' ? 'Dubai' : 'Lato'),
//           ),
//           initialRoute: '/analizar',
//           routes: <String, WidgetBuilder>{
            
//           },
//         ),
//       ),
//     ),
//   );
// }


class MainApp extends StatefulWidget {

  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();

  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Phoenix(
      child: MultiProvider(
        providers: [
                    ChangeNotifierProvider(create: (_) => AuthBlock()),
      
        ],
        child: MaterialApp(
          
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
          navigatorKey: navigatorKey,
          theme: AppTheme(selectedColor: 4).theme(),
          debugShowCheckedModeBanner: false,
          initialRoute: '/analizar',
          routes: {
        '/producto': (context) => Producto(),
                '/': (BuildContext context) => Auth(1),
                '/analizar': (BuildContext context) => analizarTodo(context),
                //'/analizar': (BuildContext context) => (vistaPrincipal==true ? Home() : Auth(1)),
                '/biowallet': (BuildContext context) => Biowallet(),
                '/home': (BuildContext context) => Home(),
                '/combo': (BuildContext context) => Combo(),
                '/direccion_habitacion': (BuildContext context) => DireccionHabitacion(),
                '/prueba': (BuildContext context) => SearchList(),
                '/prueba2': (BuildContext context) => Buscador(),
                '/prueba3': (BuildContext context) => HomePage(),
                '/auth': (BuildContext context) => Auth(1),
                '/registro': (BuildContext context) => Auth(0),
                '/recuperar': (BuildContext context) => Auth(2),
                '/confirmar_registro': (BuildContext context) => Auth(3),
                '/confirmarCodRecuperacion': (BuildContext context) => Auth(4),
                '/cambiarClavePublico': (BuildContext context) => Auth(5),
                '/cambiarClave': (BuildContext context) => cambiarClave(),
                '/shop': (BuildContext context) => Shop(),
                '/categorise': (BuildContext context) => Categorise(),
                '/cart': (BuildContext context) => Carrito(),
                '/settings': (BuildContext context) => Settings(),
                '/ordenes': (BuildContext context) => Ordenes(),
                '/products': (BuildContext context) => Products(),
                '/miPerfil': (BuildContext context) => MiPerfil(),
                '/direcciones': (BuildContext context) => Direcciones(),
                '/ListadoDirecciones': (BuildContext context) => ListadoDirecciones(),
          },
        ),
      ),
    );
  }
}


analizarTodo(context) {
  print('Entre aqui');
  return FutureBuilder<dynamic>(
    future: analizar(),
    builder: (context, AsyncSnapshot res) {
      if (res.connectionState == ConnectionState.done) {
        print('esto es res ${res}');
        if (res.data != null && res.data) {
          return Home();
        } else {
          Future.microtask(() => Navigator.pushReplacementNamed(context, '/auth'));
          return cargandoInicio(false, context);

        }
      } else {
        return cargandoInicio(true, context);
      }
    },
  );
}


Widget cargandoInicio(tipo, context) {
  return Scaffold(
    body: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 100, bottom: 50),
          child: Center(
            child: Image(image: AssetImage("assets/images/logo_peque.png")),
          ),
        ),
        Center(
          child: tipo
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/analizar');
                  },
                  child: Text("Reintentar"),
                ),
        ),
        Padding(padding: EdgeInsets.only(top: 50)),
        Center(
          child: Text(
            "Automercado Online \n Acarigua - Araure.",
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Future<bool> analizar() async {
  print('Esto prit');
  var res = await ModeloTime().listarPrecios();
  print('Esto es res 2 $res');
  saveData('listarPrecios', res);
  String data = await getData('user');
  print("USUARIO: "+data);
  if (data != null) {
    var evento = 'verificarSesion';
    var url = await UrlLogin(evento);
    var res = await peticionGet(url);

    print("CALOR");
    if (res['success'] != null) {
      // si es true es porque no esta iniciada la sesion
      print("CHINA");
      if (res['success']) {
        print("PARIS");
        var datab = await getData('recuerdo');
        if (datab != null) {
          Map resData = jsonDecode(datab);
          // print(datab);
          if (resData['si'] == true) {
            // print(datab);
            String url = UrlNoLogin('${'&evento=theBest&email=' + resData['correo']}&password=' + resData['clave']);
            print("CACHICAMO");
            Map resh = await peticionGetZlib(url);

            if (resh['success'] == true) {
              await saveDataNoJson('noLogin', 'false');

              await saveData('user', resh['data']['usuario']['data']);
              await setData(resh['data']);

              return true;
            } else {
              await saveDataNoJson('noLogin', 'true');
              return true;
            }
          } else {
            await saveDataNoJson('noLogin', 'true');
            return true;
          }
        }

        await saveDataNoJson('noLogin', 'true');
        return true;
      } else {
        await saveDataNoJson('noLogin', 'false');
        return true;
      }
    }
  } else {
    print("TORPEDO");
    bool res = await loginNoUser();
    if (res) {
      print("TRINO");
      await saveDataNoJson('noLogin', 'true');
      await iniciarCarrito();
      return true;
    } else {
      return false;
    }
  }
  return false;
}

Future<bool> loginNoUser() async {
  //var status = await Permission.storage.status;

  Map res = {};
  String url = '$BASE_URL/api_rapida.php?evento=loginNoUser';
  print(url);
  res = await peticionGetZlib(url);
  print(res);
  if (res['success'] == true) {
    await setData(res['data']);
    return true;
  } else {
    msj(res['msj_general']);
    return false;
  }
}

setData(Map value) async {
  value.forEach(actualizarTodo);
}

void actualizarTodo(key, value) async {
  await saveData(key, value);
}

class Prueba {
  String _variable = "inicio";
  setVariable(value) {
    _variable = value;
  }

  getVariable() {
    return _variable;
  }
}
