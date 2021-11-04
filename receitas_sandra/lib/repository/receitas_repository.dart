import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/receitas.dart';

class ReceitasRepository extends ChangeNotifier {
  late FirebaseFirestore fireDb;
  late FirebaseAuth auth;
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

  static Future<List> listReceita(String tipo) async {
    List? receitaList = [];
    FirebaseFirestore fireDb = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> colRef = await fireDb
        .collection('Receitas')
        .where('tipo', isEqualTo: tipo)
        .get();
    receitaList = colRef.docs;
    return receitaList;
  }

  

  /* remove(Receitas receitas) async {
    await fireDb.collection('Receitas').doc(receitas.id).delete();
    _lista.remove(receitas);
    notifyListeners();
  } */
}
