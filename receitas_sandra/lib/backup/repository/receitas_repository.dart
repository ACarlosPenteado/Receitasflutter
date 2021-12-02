import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/receitas.dart';
import 'package:receitas_sandra/uteis/globais.dart';

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
        .orderBy('descricao')
        .get();
    receitaList = colRef.docs;
    /*
    } else if (qual == 1) {
      QuerySnapshot<Map<String, dynamic>> colRef = await fireDb
          .collection('Receitas')
          .where('tipo', isEqualTo: tipo)
          .where('iduser', isEqualTo: auth)
          .orderBy('descricao')
          .get();
      receitaList = colRef.docs;
    }  else if (qual == 2) {
      QuerySnapshot<Map<String, dynamic>> colRef = await fireDb
          .collection('Receitas')
          .where('tipo', isEqualTo: tipo)
          .where('descricao', isEqualTo: Global.nomeRec)
          .get();
      receitaList = colRef.docs;
    } */

    return receitaList;
  }
}
