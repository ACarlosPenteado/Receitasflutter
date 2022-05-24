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
    CollectionReference colRef = fireDb.collection('Receitas');
    colRef.where('tipo', isEqualTo: tipo).where('ativo', isEqualTo: true).get();
    return colRef.snapshots();
  }

  excluiReceita(String id) {
    FirebaseFirestore.instance
        .collection('Receitas')
        .doc(id)
        .update({'ativo': false});
  }
}
