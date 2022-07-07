import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';


FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class DatabaseModel {
  String? type;
  String? location;
  String? facilities;
  String? price;
  String contact;
  String? name;
  String? imageUrl;
  String? email;
  String? dp;


  DatabaseModel({
    required this.location,
    required this.type,
    required this.facilities,
    required this.price,
    required this.contact,
    required this.name,
    required this.imageUrl,
    required this.email,
    required this.dp,

  });

  //taking data from the server
  factory DatabaseModel.fromMap(map) {
    return DatabaseModel(
        location: map['location'],
        type: map['type'],
        facilities: map['facilities'],
        price: map['price'],
        contact: map['contact'],
        name: map['name'],
        imageUrl: map['imageUrl'],
        email: map['email'],
        dp: map['dp'],
    );
  }


  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'type': type,
      'facilities': facilities,
      'price': price,
      'contact': contact,
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'dp': dp,

    };
  }
}



