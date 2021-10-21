import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/receitas.dart';

class ReceitasRepository extends ChangeNotifier {
  List<Receitas> _lista = [];
  late FirebaseFirestore fireDb;
  late FirebaseAuth auth;
  late String? tipo;

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

  static favoritar(String id, bool fav) async {
    FirebaseFirestore fireDb = FirebaseFirestore.instance;
    await fireDb.collection('Receitas').doc(id).update({'favorita': fav});
  }

  static Future<List> listFavoritas(String tipo) async {
    List? favoritaList = [];
    FirebaseFirestore fireDb = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> colRef = await fireDb
        .collection('Receitas')
        .where('tipo', isEqualTo: tipo)
        .where('favorita', isEqualTo: true)
        .get();
    favoritaList = colRef.docs;
    return favoritaList;
  }

  saveAll(List<Receitas> receitas) async {
    receitas.forEach((receita) async {
      if (!_lista.any((atual) => atual.id == receita.id)) {
        _lista.add(receita);
        await fireDb.collection('Receitas').doc(auth.currentUser!.uid).set({
          'data': receita.data,
          'descricao': receita.descricao,
          'id_user': receita.iduser,
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
    await fireDb.collection('Receitas').doc(receitas.id).delete();
    _lista.remove(receitas);
    notifyListeners();
  }
}
