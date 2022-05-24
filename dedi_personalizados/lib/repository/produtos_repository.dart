import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dedi_personalizados/models/produtos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProdutosRepository extends ChangeNotifier {
  late FirebaseFirestore fireDb;
  final String auth;

  ProdutosRepository({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    fireDb = FirebaseFirestore.instance;
  }

  Stream<QuerySnapshot> listProdutos() {
    CollectionReference colRef = fireDb.collection('Dedi_Personalizados');
    colRef.get();
    return colRef.snapshots();
  }

  addProdutos(Produtos produtos) {
    fireDb.collection('Dedi_Personalizados').add(produtos.toMap());
  }

  excluiProduto(String id) {
    FirebaseFirestore.instance
        .collection('Dedi_Personalizados')
        .doc(id)
        .delete();
  }
}
