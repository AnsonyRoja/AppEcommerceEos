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
      print("ENTRO A LISTADO");
      _getTaskAsync =widget.listadoProductos;
    }else{
      _getTaskAsync = ModeloTime().listarProductosNuevo(widget.tipoListado!);
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


        return FutureBuilder(
          future: _getTaskAsync,
          builder: (context, AsyncSnapshot projectSnap) {
            if (projectSnap.connectionState == ConnectionState.done) {
                try {
                  if (projectSnap.data['success'] == true) {
                    print("entro caja de productos nuevar");
                    print('esto son los productos en nuevar ${projectSnap.data}');
                    //return cajaProductosNueva(projectSnap.data['data']);
                    return cajaProductosNueva(projectSnap.data);

                  } else {
                    return Padding(
                        padding: EdgeInsets.only(bottom: 50, left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //Icon(Pide.do_not_disturb,size: 50,),

                            //"Ups, nos hemos encontrado productos que coincidan con tu búsqueda, intenta más tarde."
                            Center(child: Text(projectSnap.data['msj_general'],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(colorRojo),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),),),


                            //Text("No hay productos, intente mas tarde.",style: TextStyle(fontSize: 30),)
                          ],)
                    );
                  }
                }catch(_){
                  return noInternet();
                }
            }else {
              return Center(child:CircularProgressIndicator());
            }
          },

        );


  }




  
  cajaProductosNueva(Map products) {
  print('Estos son los productos en la nueva caja ${products['1181']} ');
  var size = MediaQuery.of(context).size;

  //  final double itemHeight = (size.height - kToolbarHeight ) / 3;
  //  final double itemWidth = size.width / 2;
  double width = MediaQuery.of(context).size.width;
  print("MEDIA QUERY");
  print(width);
  int widthCard = 180;

  int countRow = width ~/ widthCard;

  return GridView.count(
    //childAspectRatio: (itemWidth / 220),
    childAspectRatio: (widthCard / 220),
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),
    crossAxisCount: countRow,
    children: List.generate(products.length, (index) {
      var key = products.keys.elementAt(index);
      print('Estos son los productos ${products[key]} esto es $index');
      return Center(
        child: _productoDeLista(products, key),
      );
    }),
  );
}

  
  cajaProductosNuevaFlexible(products) {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.only(top:10),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) => _productoDeLista(products,index),
      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
      
      mainAxisSpacing:33.0,
      crossAxisSpacing: 0.0,
    );
    //final formatCurrency = new NumberFormat("#,##0.00", "en_US");

  }

_productoDeLista(products,index){
  print('Entre aqui en ${products[index]} y este es el idenx $index');
      String imagen='';
    if(products[index]['photo']!=null) {
      imagen = "$BASE_URL_IMAGEN" + products[index]['photo'];
    }else{
      imagen ="$BASE_URL_IMAGEN" + products[index]['photo'];
    }
      //print("ENTRO");
      String imagen_grande=products[index]['photo'];


      String name=products[index]['name'];

      String priceDolar=formatDolar.format(double.parse(products[index]['price']));
      String price=formatBolivar.format(double.parse(products[index]['price'])); 

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
      print('Llegue aqui en producto de lista ${products[index]['name']} ');
     // int descuento=int.parse(products[index]['discount'] ?? '0');

      return Card(

 shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    side: BorderSide(width: 1, color: Color(0xFFDDDDDD))
    ),
margin: EdgeInsets.all(5),

//elevation: 2,

        semanticContainer: false,

        child:  Column(

                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(

                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/producto',
                    arguments: Products(
                        image:imagen_grande,
                        image_previa:imagen,
                        name:name,
                        precio:"$priceDolar/$price",
                        precioDolar:precioDolar,
                        precioBolivar:precioBolivar,
                        rating: rating,
                        description_short:description_short,
                        id:id,
                        calificado_por_mi:calificado_por_mi,
                        stock: stock,
                        pedidoMax: pedidoMaximo,
                        promocion:promocion,
                        evento: ModeloTime().evento

                      // message:'este argumento es extraido de producto.',
                    ),
                  ).then((val)=>{_capturarRetroceso()});
                },
                child: Stack(   

                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(5),
                              child:Center(
                            
                            child:CachedNetworkImage(

                            width: 140,
                        //fit: BoxFit.cover,
                        imageUrl: imagen,
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator()
                        ),
                        errorWidget: (context, url, error) => Icon(Pide.error),
                      ))
                          )
                          ,

                    Padding(padding: EdgeInsets.only(top:130),
                    child: 
                    Container(alignment: Alignment.center,
                    
                    child: promocion==1 ? Container(
                      width: 70,
                      height: 20,
                      decoration: BoxDecoration(

                        color: Color(0xffF4901E),
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                         
                        )
                      ),
                      child: Center(child: Text('Oferta',style: TextStyle(color: Colors.white),)),
                    ) : Text(''),
                    
                    
                    
                    
                    
                    )
                    
                    
                    ),
                      
                        ],
                      )

                    ),
                    Center(child:Text(name,maxLines: 2,style: TextStyle(fontSize: 13),textAlign: TextAlign.center,)),
                  // promocion==1 ? _precioOferta('$precioDolarSinDescuento/$precioBolivarSinDescuento','$priceDolar/$price') :  SizedBox(),
                    _precioNormal('$priceDolar/$price'),
                   Spacer(),
                    AddCarrito(id: id,stock:stock,pedidoMaximo:pedidoMaximo,priceB: precioBolivar,priceD: precioDolar)
                     
                  ],
                ),

              

);
              
    
    

    }

    _precioNormal(precio){
      return Center(child:Text(precio, style: TextStyle(color: Color(colorVerde),fontWeight: FontWeight.w700,fontSize: 13)));
    }
    _precioOferta(precio,precioCompararDiferencia){
      if(precio==precioCompararDiferencia){
        return SizedBox();
      }else{
        return  Center(child:
                            Text(precio, style: TextStyle(
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
        decoration: BoxDecoration(
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