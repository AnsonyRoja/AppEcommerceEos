import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '/widget/icono_carrito.dart';
import '../config.dart';
import '../funciones_generales.dart';
import '../home/agregarProducto.dart';
import '../home/galeria.dart';
import '../home/rating.dart';
import '../modelo/products.dart';
import '../modelo/favorites.dart';
import 'package:http/http.dart' as http;
import 'package:Pide/pide_icons.dart';
class Producto extends StatefulWidget {
  @override
  _productoState createState() => _productoState();
}
class _productoState extends State<Producto>{
  bool _status_favorite=false;
  Favorites objFavorites = Favorites();
  bool guardadoVisita=false;
  bool mayor=true;
  bool consultadoFavorito=false;
  var msj_mayor;

  @override
  void initState() {
    
      print('Me monte');
       super.initState();
  }

  @override
  Widget build(BuildContext context) {
   // final proveedor = Provider.of<AuthBlock>(context);
    final Products args = ModalRoute.of(context)!.settings.arguments as Products;
  
    // guardarVisitaProducto(args.id!);
    if(_status_favorite==false) {
      if(consultadoFavorito==false) {
        // consultarFavorito(args.id!);
        consultadoFavorito=true;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: titleBio('Detalles del producto'),
        leading: leadingBio(context),
        backgroundColor: colorAppBarBio(),
        actions: <Widget>[
//en true el actualizar
          IconoCarrito(),
        ],
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 260,
                child: Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Galeria(galleryItems:[args.image],imagenPrevia: args.image_previa!),
                     
                      Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: FloatingActionButton(
                                mini: true,
                                child: Icon(Icons.favorite,color: _status_favorite==false ? Colors.grey : Colors.red,) ,
                                backgroundColor: Colors.white,
                                onPressed: () async{
                                  if(await validarSesion()){
                                    guardarFavorito(args.id!);
                                  }
                                },
                              )

                      ),

                  
                   
                    Container(
                      alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(10),
                    child: args.promocion==1 ? new Container(
                      width: 80,
                      height: 20,
                      decoration: new BoxDecoration(

                        color: const Color(0xffF4901E),
                        borderRadius: new BorderRadius.all(
                          const Radius.circular(40.0),
                         
                        )
                      ),
                      child: const Center(child: Text('en oferta',style: TextStyle(color: Colors.white),)),
                    ) : const Text(''),
                    
                    
                    
                    
                    
                    )
                    
                    
                    ,








                    ]
                ),
              ),



              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: const Alignment(-1.0, -1.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                          args.name,
                          style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  args.precio.toString(),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 150,
                                child: Rating(rating: args.rating,nombre: args.name,calificado_por_mi: args.calificado_por_mi,products_id: args.id,)),
                              const Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                    '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    FutureBuilder(
                        future: mayorDeEdad(args.id!),
                        builder: (context, projectSnap) {
                          //return mayor ? AgregarProducto(precioBolivar: args.precioBolivar,precioDolar: args.precioDolar,id:args.id,stock: args.stock,pedidoMax:args.pedidoMax) : Text(msj_mayor,style: TextStyle(color:Colors.red),);
                          return mayor ? AgregarProducto(precioBolivar: args.precioBolivar!,precioDolar: args.precioDolar!,id:args.id!,stock: args.stock!,pedidoMax:args.pedidoMax!) : Text(msj_mayor,style: const TextStyle(color:Colors.red),);

                    }),

                    const Divider(),
                    Column(
                      children: <Widget>[
                        Container(
                            alignment: const Alignment(-1.0, -1.0),
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Descripción',
                                style: TextStyle(color: Colors.black, fontSize: 20,  fontWeight: FontWeight.w600),
                              ),
                            )
                        ),

                        Container(
                            alignment: const Alignment(-1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                               args.description_short,
                                style: const TextStyle(color: Colors.black54, fontSize: 17),
                              ),
                            )
                        ),Container(
                            alignment: const Alignment(-1.0, -1.0),
                            child: const Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                               '',
                                style: TextStyle(color: Colors.black54, fontSize: 16),
                              ),
                            )
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

      ),
    );
  }
  void guardarFavorito(int products_id) async {

    objFavorites.products_id=products_id;
    objFavorites.guardar();
    setState(() {
      if(_status_favorite==true){
        _status_favorite = false;
      }else {
        msj("Agregado a favoritos.");
        _status_favorite = true;
      }
    });
    return;
  }
void consultarFavorito(int products_id) async {
    objFavorites.products_id=products_id;
    await objFavorites.consultar();
if(objFavorites.res['data'][products_id.toString()]==true){
 // if(esnulo['es_nulo']==true){
    //if(objFavorites.res['success']==true){
       // if(objFavorites.res['data'][products_id.toString()]==true){
          setState(() {
            _status_favorite=true;
          });
      //  }
    //}
  //}

}

    return;
  }
  guardarVisitaProducto(int products_id) async {
    if(guardadoVisita==false) {
      String url;
      String datos = 'guardarVisitaProducto&products_id=' +
          products_id.toString();
      url = await UrlLogin(datos);
      var uri = Uri.parse(url);
      final response = await http.get(
        uri, headers: {"Accept": "application/json"},);
      print(response.body);
      print(response.statusCode);
      guardadoVisita=true;
    }
  }
  mayorDeEdad(int products_id) async {
    String url;
    Map res=Map();
    res=await getData('productos_mayor');

   // String datos='mayorDeEdad&products_id='+products_id.toString();
   // url=await UrlLogin(datos);
    //res= await peticionGet(url);
      print("MAYOR");
      print(res);
    if(res['data'][products_id.toString()]==true){
      mayor= false;
      msj_mayor=res['msj_general'];

    }else{
      mayor= true;
    }

  }

}
