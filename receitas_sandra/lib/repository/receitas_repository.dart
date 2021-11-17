import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/receitas.dart';

class ReceitasRepository extends ChangeNotifier {
  late FirebaseFirestore fireDb;
  late String auth;
  late String? tipo;
  List<Receitas> _lista = [];

  ReceitasRepository({required this.auth, this.tipo}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    fireDb = FirebaseFirestore.instance;
  }

  Future<List> listReceita(String tipo) async {
    List? receitaList = [];
    QuerySnapshot<Map<String, dynamic>> colRef = await fireDb
        .collection('Receitas')
        .where('tipo', isEqualTo: tipo)
        .get();
    receitaList = colRef.docs;
    return receitaList;
  }

  addUser(FirebaseAuth uid, String idrec) async {
    await fireDb.collection('Receitas').doc(idrec).update({
      'iduser': FieldValue.arrayUnion([uid])
    });
    notifyListeners();
  }

  Future<List> listUsers(String idrec) async {
    List userList = [];
    DocumentSnapshot colRef =
        await fireDb.collection('Receitas').doc(idrec).get();
    userList = colRef.get('iduser');
    return userList;
  }
}
