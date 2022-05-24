import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dedi_personalizados/models/produtos.dart';
import 'package:flutter/material.dart';

class ProdutosRepository extends ChangeNotifier {
  late FirebaseFirestore fireDb;

  ProdutosRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    fireDb = FirebaseFirestore.instance;
  }

  Stream<QuerySnapshot> listProdutos(String id) {
    CollectionReference colRef = fireDb.collection('Produtos');
    colRef.where('id', isEqualTo: id).get();
    return colRef.snapshots();
  }

  addProdutos(Produtos produtos) {
    fireDb.collection('Dedi_Personalizados').add(produtos.toMap());
  }

  excluiReceita(String id) {
    FirebaseFirestore.instance
        .collection('Receitas')
        .doc(id)
        .update({'ativo': false});
  }
}
