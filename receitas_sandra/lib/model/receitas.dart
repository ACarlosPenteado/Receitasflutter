import 'package:receitas_sandra/model/iduser.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/model/preparo.dart';

class Receitas {
  String? id;
  String data;
  String descricao;
  List<IdUsers> iduser;
  String imagem;
  List<Ingrediente> ingredientes;
  List<Preparo> preparo;
  String rendimento;
  String tempoPreparo;
  String tipo;

  Receitas({
    this.id,
    required this.data,
    required this.descricao,
    required this.iduser,
    required this.imagem,
    required this.ingredientes,
    required this.preparo,
    required this.rendimento,
    required this.tempoPreparo,
    required this.tipo,
  });

  @override
  String toString() {
    return '{ id: ${id}, data: ${data}, descricao: ${descricao}, iduser: ${iduser}, imagem: ${imagem}, ingredientes: ${ingredientes}, preparo: ${preparo}, rendimento: ${rendimento}, tempoPreparo: ${tempoPreparo}, tipo: ${tipo}, }';
  }
}
