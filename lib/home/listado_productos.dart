import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '/widget/add_carrito.dart';

import '../modelo.dart';
import 'package:flutter/material.dart';
import '../funciones_generales.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../home/rating.dart';
import '../modelo/products.dart';
import '../config.dart';
import 'package:Pide/pide_icons.dart';
class ListadoProductos extends StatefulWidget {
final String? tipoListado;
final Future? listadoProductos;
  const ListadoProductos({Key? key, this.tipoListado, this.listadoProductos}) : super(key: key);
  @override
  _productosState createState() => _productosState();
}
class _productosState extends State<ListadoProductos> {
  var evento;
  bool _cargado=false;
bool _botonBusqueda=false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  _capturarRetroceso(){//para actualizar la pagina esta despues que retrocedan de la pagina productos
    //setState(() {

    //});
  print("capturado retroceso");
  }

  Future? _getTaskAsync;
  @override
  void initState() {
    if(widget.listadoProductos!=null){
      _getTaskAsync =widget.listadoProductos;
    }else{
      _getTaskAsync = ModeloTime().listarProductosNuevo(widget.tipoListado!);
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


        return FutureBuilder(
          future: widget.listadoProductos,
          builder: (context, AsyncSnapshot projectSnap) {
            if (projectSnap.connectionState == ConnectionState.done) {
                
                  print('Estos es el projectSnap $projectSnap');
                 
                    print("entro caja de productos nuevar");
                    print('esto son los productos en nuevar ${projectSnap.data}');
                    //return cajaProductosNueva(projectSnap.data['data']);
                    return cajaProductosNueva(projectSnap.data);

                
                  
            }else {
              return const Center(child:CircularProgressIndicator());
            }
          },

        );


  }




  
Widget cajaProductosNueva(Map products) {
  print('Estos son los productos en la nueva caja ${products['1181']} ');
  var size = MediaQuery.of(context).size;

  double width = MediaQuery.of(context).size.width;
  print("MEDIA QUERY");
  print(width);
  int widthCard = 180;
  int countRow = width ~/ widthCard;

  // Filtra los productos para asegurarte de que solo los mapas válidos se procesen
  var validProducts = products.entries
      .where((entry) => entry.value is Map<String, dynamic>)
      .toList();

  return GridView.count(
    childAspectRatio: (widthCard / 220),
    shrinkWrap: true,
    physics: const ClampingScrollPhysics(),
    crossAxisCount: countRow,
    children: List.generate(validProducts.length, (index) {
      var key = validProducts[index].key;
      var product = validProducts[index].value;
      print('Estos son los productos $product esto es $index');
      return Center(
        child: _productoDeLista(products, key),
      );
    }),
  );
}

  
  cajaProductosNuevaFlexible(products) {
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.only(top:10),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) => _productoDeLista(products,index),
      staggeredTileBuilder: (int index) => const StaggeredTile.fit(2),
      
      mainAxisSpacing:33.0,
      crossAxisSpacing: 0.0,
    );
    //final formatCurrency = new NumberFormat("#,##0.00", "en_US");

  }

_productoDeLista(products,index){
  print('Entre aqui en ${products[index]} y este es el idenx $index');
 String imagen='';
    if(products[index]['photo']!=null) {
      imagen = "$BASE_URL_IMAGEN_PRODUCTS" + products[index]['photo'];
    }else{
      imagen ="$BASE_URL_IMAGEN_PRODUCTS" + products[index]['photo'];
    }

      print('Esto es la imagen $imagen');

      String names = products[index]['name'];


      print('Esto es el nombres $names');


      double priceDolar=double.parse(products[index]['price']);
      String price= formatBolivar.format(double.parse(products[index]['price'])); 

      String precioDolarSinDescuento=formatDolar.format(double.parse(products[index]['price']));
      String precioBolivarSinDescuento=formatBolivar.format(double.parse(products[index]['price']));

      double precioDolar=double.parse(products[index]['price']);
      double precioBolivar=double.parse(products[index]['price']);



      double rating=double.parse(products[index]['user_rating']);
      String description_short=products[index]['description'].toString();
      int id=int.parse(products[index]['id'].toString());

      String otroId=products[index]['id'].toString();
      String calificado_por_mi=products[index]['user_rating'];
      int stock=int.parse(products[index]['qty_avaliable'].toString());
      int pedidoMaximo=int.parse(products[index]['qty_max'].toString());
      
      int promocion=int.parse(products[index]['is_combo'] ?? '0');
    //  int descuento=int.parse(products[index]['discount'] ?? '0');

      return Card(

 shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    side: const BorderSide(width: 1, color: Color(0xFFDDDDDD))
    ),
margin: const EdgeInsets.all(5),

//elevation: 2,

        semanticContainer: false,

        child:  SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(

              decoration:  BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                 
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),

                    spreadRadius: 2,
                    blurRadius: 7
                  )
                ]

              ) ,
            child: Column(
            
                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
            
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/producto',
                        arguments: Products(
                            image:imagen,
                            image_previa:imagen,
                            name:names,
                            precio: price ,
                            precioDolar:priceDolar,
                            precioBolivar:precioBolivar,
                            rating: rating,
                            description_short:description_short,
                            id:id,
                            calificado_por_mi: calificado_por_mi,
                            stock: stock,
                            pedidoMax: pedidoMaximo,
                            promocion:0,
                            evento: ModeloTime().evento
            
                          // message:'este argumento es extraido de producto.',
                        ),
                      ).then((val)=>{_capturarRetroceso()});
                    },
                    child: Stack(   
            
                            children: <Widget>[
                              Container(
                                
                                margin: const EdgeInsets.all(5),
                                  child:Center(
                                
                                child:CachedNetworkImage(
                                  
                                width: 130,
                                
                            fit: BoxFit.cover,
                            imageUrl: imagen,
                            placeholder: (context, url) => const Center(
                                child:  CircularProgressIndicator()
                            ),
                            errorWidget: (context, url, error) => const Icon(Pide.error),
                          ))
                              )
                              ,
            
                        Padding(padding: const EdgeInsets.only(top:130),
                        child: 
                        Container(alignment: Alignment.center,
                        
                        child: promocion ==1 ? Container(
                          width: 70,
                          height: 20,
                          decoration: const BoxDecoration(
            
                            color: Color(0xffF4901E),
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                             
                            )
                          ),
                          child: const Center(child: Text('Oferta',style: TextStyle(color: Colors.white),)),
                        ): const Text('') ,
                        
                        
                        
                        
                        
                        )
                        
                        
                        ),
                          
                            ],
                          )
            
                        ),
                        Center(child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(names,maxLines: 2,style: const TextStyle(fontSize: 13),textAlign: TextAlign.center,),
                        )),
                      // promocion==1 ? _precioOferta('$precioDolarSinDescuento/$precioBolivarSinDescuento','$priceDolar/$price') :  SizedBox(),
                  
                      ],
                    ),
          ),
        ),

              

);
              
    
    

    }

    _precioNormal(precio){
      return Center(child:Text(precio, style: TextStyle(color: Color(colorVerde),fontWeight: FontWeight.w700,fontSize: 13)));
    }
    _precioOferta(precio,precioCompararDiferencia){
      if(precio==precioCompararDiferencia){
        return const SizedBox();
      }else{
        return  Center(child:
                            Text(precio, style: const TextStyle(
                              fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough
                                        )),
                            );

            }
      }

}

class CircleButton extends StatelessWidget {
  final GestureTapCallback? onTap;
  final IconData? iconData;

  const CircleButton({Key? key, this.onTap, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 50.0;

    return InkResponse(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          color: Colors.black,
        ),
      ),
    );
  }
}