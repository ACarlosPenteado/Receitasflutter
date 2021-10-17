import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:receitas_sandra/model/receitas.dart';
import 'package:receitas_sandra/repository/receitas_repository.dart';

class FavoritasRepository extends ChangeNotifier {
  List<Receitas> _lista = [];

  UnmodifiableListView<Receitas> get lista => UnmodifiableListView(_lista);

  saveAll(List<Receitas> receitas) {
    receitas.forEach((receita) {
      if (!_lista.contains(receita)) _lista.add(receita);
    });
    notifyListeners();
  }

  remove(Receitas receita) {
    _lista.remove(receita);
    notifyListeners();
  }
}
