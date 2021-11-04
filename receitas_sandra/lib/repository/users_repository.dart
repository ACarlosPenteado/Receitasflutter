import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/users.dart';

class UsersRepository extends ChangeNotifier {
  late final FirebaseFirestore fireDb;
  late FirebaseAuth auth;
  List<Users> _lista = [];

  UsersRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    fireDb = FirebaseFirestore.instance;
  }

  static favoritar(String uid, String idrec) async {
    FirebaseFirestore fireDb = FirebaseFirestore.instance;
    await fireDb.collection('Users').doc(uid).update({
      'favoritas': FieldValue.arrayUnion([idrec])
    });
  }

  static Future<List> listFavoritas(String uid) async {
    List favoritaList = [];
    FirebaseFirestore fireDb = FirebaseFirestore.instance;

    DocumentSnapshot colRef = await fireDb.collection('Users').doc(uid).get();
    favoritaList = colRef.get('favoritas');
    return favoritaList;
  }
}
