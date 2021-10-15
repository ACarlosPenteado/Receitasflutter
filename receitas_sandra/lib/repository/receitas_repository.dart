import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/receitas.dart';

class ReceitasRepository extends ChangeNotifier {
  List<Receitas> _lista = [];
  late FirebaseFirestore firedb;
  late FirebaseAuth auth;
  late String? tipo;

  ReceitasRepository({required this.auth, this.tipo}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await readReceitas(tipo!);
  }

  _startFirestore() {
    firedb = FirebaseFirestore.instance;
  }

  readReceitas(String tipo) async {
    await firedb
        .collection('Receitas')
        .where('tipo', isEqualTo: tipo)
        .get()
        .then((QuerySnapshot query) {
      query.docs.forEach((doc) {
        print(query.docs);
      });
    });
    notifyListeners();
  }

  saveAll(List<Receitas> receitas) async {
    receitas.forEach((receita) async {
      if (!_lista.any((atual) => atual.id == receita.id)) {
        _lista.add(receita);
        await firedb.collection('Receitas').doc(auth.currentUser!.uid).set({
          'data': receita.data,
          'descricao': receita.descricao,
          'id_user': receita.id_user,
          'imagem': receita.imagem,
          'ingredientes': receita.ingredientes,
          'preparo': receita.preparo,
          'rendimento': receita.rendimento,
          'tempoPreparo': receita.tempoPreparo,
          'tipo': receita.tipo,
        });
      }
    });
    notifyListeners();
  }

  remove(Receitas receitas) async {
    await firedb.collection('Receitas').doc(receitas.id).delete();
    _lista.remove(receitas);
    notifyListeners();
  }
}
