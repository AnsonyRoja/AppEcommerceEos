import 'package:flutter/material.dart';
import '../config.dart';
import '../funciones_generales.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Rating extends StatefulWidget {
  double? rating;

  String? nombre;
  String? calificado_por_mi;
  int? products_id;
  String? otroId;

  Rating({Key? key, this.rating, this.nombre, this.calificado_por_mi, this.products_id}) : super(key: key);
  @override
  _ratingState createState() => _ratingState();
}

class _ratingState extends State<Rating> {
  bool inicial = true;
  double rating = 0.00;
  double ratingNuevo = 0.00;
  double _miRating = 0.00;
  String? opinion;
  Map? res;
  bool _cargando = false;
  bool _calificado = false; //para cambiar el calificado en tiempo real con setStatus sin consultar al servidor

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final int? produ = widget.products_id;
    if (_calificado == false) {
      _miRating = double.parse(widget.calificado_por_mi!);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: (double.parse(widget.calificado_por_mi!) > 0 || _calificado == true) ? [_estrellas(produ)] : [_estrellas(produ)],
    );
  }

  _misEstrellas() {
    return RatingBar.builder(
      allowHalfRating: false,
      itemCount: 5,
      minRating: 1,
       unratedColor: Colors.amber.withAlpha(50),
      initialRating: _miRating,
      itemSize: 50.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
             Icons.star,
            color: Colors.amber,
            
          ),
             onRatingUpdate: (rating) {
            setState(() {
              _miRating = rating;
            });
          },
          updateOnDrag: true,

    );
  }

  _estrellas(produ) {
    return RatingBar.builder(
      allowHalfRating: false,
      itemCount: 5,
      minRating: 1,
       unratedColor: Colors.amber.withAlpha(50),
      initialRating: _miRating,
      itemSize: 20.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
             Icons.star,
            color: Colors.amber,
            
          ),
             onRatingUpdate: (rating) {
            setState(() {
              _miRating = rating;

            });
              calificarProducto(context, produ);
            print('Esta es la opinion $opinion');
          },
          updateOnDrag: true,

    );
  }

  estrellas(otro) {
    return Row(
      children: <Widget>[
        RatingBar.builder(
      allowHalfRating: false,
      itemCount: 5,
      minRating: 1,
       unratedColor: Colors.amber.withAlpha(50),
      initialRating: _miRating,
      itemSize: 20.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
             Icons.star,
            color: Colors.amber,
            
          ),
             onRatingUpdate: (rating) {
            setState(() {
              _miRating = otro;
            });

            
          },
          updateOnDrag: true,

    ),
      ],
    );
  }

  calificarProducto(context, products_id) {
    //print("AQUI $products_id"+widget.products_id.toString());
    guardarCalificacion(products_id);
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Column(
                children: <Widget>[Text("Gracias por calificar a: ${widget.nombre!}"), estrellas(rating)],
              ),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    return validar('todo', value!, true);
                  },
                  onSaved: (value) {
                    setState(() {
                      print("procesado: $value");
                      opinion = value!;
                    });
                  },
                  decoration: InputDecoration(
                    //hintText: 'Dejanos tu comentario sobre este producto:',
                    labelText: 'Comenta este producto:',
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar')),
                TextButton(
                    onPressed: () async {
                      print("Calificado");
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        guardarOpinion();
                        Navigator.pop(context);
                      }
                    },
                    child: _cargando ? CircularProgressIndicator() : Text('Ok')),
              ],
            ));
  }

  Future guardarOpinion() async {
    String url;
    String datos = 'guardarOpinion&opinion=$opinion&products_id=' + widget.products_id.toString();
    url = await UrlLogin(datos);
    var uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      msj(res!['msj_general']);
    } else {
      msj(res!['msj_general']);
    }
  }

  Future<Map> guardarCalificacion(int products_id) async {
    print(products_id);
    String url;
    String datos = 'guardarCalificacion&products_id=' + widget.products_id.toString() + '&rating=' + rating.round().toString();
    url = await UrlLogin(datos);
    print('Url Guardar calificacion $url');
    var uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {"Accept": "application/json"},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      // setState(() {
      //widget.calificado_por_mi='1';
      // });
      res = jsonDecode(response.body);
      if (res!['success'] == true) {
        //msj(res['msj_general']);
      } else {
        msj(res!['msj_general']);
      }
    } else {
      res = jsonDecode(response.body);
    }
  return res!;
  }
}
