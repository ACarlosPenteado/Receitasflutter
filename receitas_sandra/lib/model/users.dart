import 'package:receitas_sandra/model/favoritas.dart';

class Users {
  String id;
  String data;
  String email;
  List<Favoritas>? favoritas;
  String fone;
  String imagem;
  String nome;
  String provedor;

  Users({
    required this.id,
    required this.data,
    required this.email,
    this.favoritas,
    required this.fone,
    required this.imagem,
    required this.nome,
    required this.provedor,
  });

  factory Users.fromJson(Map<dynamic, dynamic> json) => Users(
        id: json['id'],
        data: json['data'],
        email: json['email'],
        favoritas: (json['favoritas'] as List)
            .map((e) => Favoritas.fromJson(e))
            .toList(),
        fone: json['fone'],
        imagem: json['imagem'],
        nome: json['nome'],
        provedor: json['provedor'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data,
        'email': email,
        'favoritas': favoritas,
        'fone': fone,
        'imagem': imagem,
        'nome': nome,
        'provedor': provedor,
      };

  /* @override
  String toString() {
    return '{ id: ${id}, data: ${data}, email: ${email}, favoritas: ${favoritas}, fone: ${fone}, imagem: ${imagem}, nome: ${nome} , provedor: ${provedor}, }';
  } */
}
