import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/users.dart';

class UsersRepository extends ChangeNotifier {
  final String auth;
  List<Users> _lista = [];

  UsersRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    FirebaseFirestore fireDb;
    fireDb = FirebaseFirestore.instance;
  }

  favoritar(FirebaseAuth uid, String idrec) async {
    FirebaseFirestore fireDb = FirebaseFirestore.instance;
    await fireDb.collection('Users').doc(uid.currentUser!.uid).update({
      'favoritas': FieldValue.arrayUnion([idrec])
    });
    notifyListeners();
  }

  desfavoritar(FirebaseAuth uid, String idrec) async {
    FirebaseFirestore fireDb = FirebaseFirestore.instance;
    await fireDb.collection('Users').doc(uid.currentUser!.uid).update({
      'favoritas': FieldValue.arrayRemove([idrec])
    });
    notifyListeners();
  }

  Future<List> listFavoritas(String uid) async {
    List favoritaList = [];
    FirebaseFirestore fireDb = FirebaseFirestore.instance;

    DocumentSnapshot colRef = await fireDb.collection('Users').doc(uid).get();
    favoritaList = colRef.get('favoritas');
    return favoritaList;
  }
}
