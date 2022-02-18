import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/users.dart';
import 'package:receitas_sandra/uteis/globais.dart';

class UsersRepository extends ChangeNotifier {
  final String auth;
  late FirebaseFirestore fireDb;
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

  favoritar(FirebaseAuth uid, String idrec) async {
    await fireDb.collection('Users').doc(uid.currentUser!.uid).update({
      'favoritas': FieldValue.arrayUnion([idrec])
    });
    notifyListeners();
  }

  desfavoritar(FirebaseAuth uid, String idrec) async {
    await fireDb.collection('Users').doc(uid.currentUser!.uid).update({
      'favoritas': FieldValue.arrayRemove([idrec])
    });
    notifyListeners();
  }

  Future<List> listFavoritas(String uid) async {
    List favoritaList = [];
    DocumentSnapshot colRef = await fireDb.collection('Users').doc(uid).get();
    favoritaList = colRef.get('favoritas');
    return favoritaList;
  }

  Future<String> nomeUser(String idUser) async {
    String userNome;
    var doc =
        await FirebaseFirestore.instance.collection('Users').doc(idUser).get();
    userNome = doc.get('nome');
    return userNome;
  }

  Stream<QuerySnapshot> userDados() {
    Stream<QuerySnapshot<Map<String, dynamic>>> colRef =
        fireDb.collection('Users').snapshots();
    return colRef;
  }

  Stream<QuerySnapshot> foneUser(String fone) {
    Query<Map<String, dynamic>> colRef =
        fireDb.collection('Users').where("fone", isEqualTo: fone);
    return colRef.snapshots();
  }
}
