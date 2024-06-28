import 'package:flutter/material.dart';

class User {
  String? username;
  String? email;
  String? password;
  var tipo={
    'tipoRif': 'V',
    'rif': '',
    'name': '',
    'email': '',
    'password': '',
    'birthdate':'',
    'tlf':''
  };
  String? rif;
  User({ Key? key ,this.username, this.email, this.password});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['username'],
        email: json['email'],
        password: json['password']
    );
  }
}

class UserCredential {
  String? usernameOrEmail;
  String? password;
  UserCredential({this.usernameOrEmail, this.password});
}
