import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class RatingOrder extends StatefulWidget {

  String? nombre;
  String? calificado_por_mi;
  final int? orders_id;
  String? otroId;
  final ValueChanged<double>? onChanged;
  RatingOrder({Key? key, this.orders_id, this.onChanged,}) : super(key: key);
  @override
  _ratingOrderState createState() => _ratingOrderState();
}

class _ratingOrderState extends State<RatingOrder> {

  bool inicial=true;
  double rating=0.00;
  double ratingNuevo=0.00;
  double _miRating=0.00;
  String? opinion;
  Map? res;
  bool _cargando=false;
  bool _calificado=false; //para cambiar el calificado en tiempo real con setStatus sin consultar al servidor

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _estrellas(),
        ]
        ,);
  }

  _misEstrellas(){
    return RatingBar.builder(
      allowHalfRating: false,
      itemCount: 5,
      minRating: 1,
      initialRating: _miRating,
      unratedColor: Colors.amber.withAlpha(50),
      itemSize: 50.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
       itemBuilder: (context, _) => Icon(
             Icons.star,
            color: Colors.amber,
          ),
        onRatingUpdate: (value) {
          
          _miRating = value;
        },
        updateOnDrag: true,

    );
  }
  _estrellas(){
    return RatingBar.builder(
      allowHalfRating: false,
      itemCount: 5,
      minRating: 1,
      initialRating: _miRating,
      unratedColor: Colors.amber.withAlpha(50),
      itemSize: 50.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
       itemBuilder: (context, _) => Icon(
             Icons.star,
            color: Colors.amber,
          ),
        onRatingUpdate: (value) {
          
          _miRating = value;
        },
        updateOnDrag: true,

    );
  }
  estrellas(otro){

    return Row(children: <Widget>[
      
      RatingBar.builder(
      allowHalfRating: false,
      itemCount: 5,
      minRating: 1,
      initialRating: _miRating,
      unratedColor: Colors.amber.withAlpha(50),
      itemSize: 50.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
       itemBuilder: (context, _) => Icon(
             Icons.star,
            color: Colors.amber,
          ),
        onRatingUpdate: (value) {
          
          _miRating = value;
        },
        updateOnDrag: true,

    ),
    
    ],);
  }



}