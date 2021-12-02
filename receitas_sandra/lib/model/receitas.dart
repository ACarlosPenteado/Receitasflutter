import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/model/preparo.dart';

class Receitas {
  String? id;
  String data;
  String descricao;
  String iduser;
  String imagem;
  List<Ingrediente>? ingredientes;
  List<Preparo>? preparo;
  String rendimento;
  String tempoPreparo;
  String tipo;

  Receitas({
    this.id,
    required this.data,
    required this.descricao,
    required this.iduser,
    required this.imagem,
    this.ingredientes,
    this.preparo,
    required this.rendimento,
    required this.tempoPreparo,
    required this.tipo,
  });

  factory Receitas.fromJson(Map<dynamic, dynamic> json) => Receitas(
        data: json['data'],
        descricao: json['descricao'],
        iduser: json['iduser'],
        imagem: json['imagem'],
        ingredientes: (json['ingredientes'] as List)
            .map((e) => Ingrediente.fromJson(e))
            .toList(),
        preparo:
            (json['preparo'] as List).map((e) => Preparo.fromJson(e)).toList(),
        rendimento: json['rendimento'],
        tempoPreparo: json['tempoPreparo'],
        tipo: json['tipo'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data,
        'descricao': descricao,
        'iduser': iduser,
        'imagem': imagem,
        'ingredientes': ingredientes,
        'preparo': preparo,
        'rendimento': rendimento,
        'tempoPreparo': tempoPreparo,
        'tipo': tipo,
      };

  @override
  String toString() {
    return '{ id: ${id}, data: ${data}, descricao: ${descricao}, iduser: ${iduser}, imagem: ${imagem}, ingredientes: ${ingredientes}, preparo: ${preparo}, rendimento: ${rendimento}, tempoPreparo: ${tempoPreparo}, tipo: ${tipo}, }';
  }
}
