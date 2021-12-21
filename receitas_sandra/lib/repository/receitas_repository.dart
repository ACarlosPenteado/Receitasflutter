import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReceitasRepository extends ChangeNotifier {
  late FirebaseFirestore fireDb;
  late String auth;

  ReceitasRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    fireDb = FirebaseFirestore.instance;
  }

  Stream<QuerySnapshot> listReceita(String tipo) {
    FirebaseFirestore fireDb = FirebaseFirestore.instance;
    CollectionReference colRef = fireDb.collection('Receitas');
    colRef.where('tipo', isEqualTo: tipo).get();

    return colRef.snapshots();
  }
}
