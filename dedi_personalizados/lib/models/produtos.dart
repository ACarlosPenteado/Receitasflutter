import 'package:cloud_firestore/cloud_firestore.dart';

class Produtos {
  String id;
  String categoria;
  String descricao;
  String linkImagem;

  Produtos({
    required this.id,
    required this.categoria,
    required this.descricao,
    required this.linkImagem,
  });

  String get getId => this.id;

  set setId(String id) => this.id = id;

  get getCategoria => this.categoria;

  set setCategoria(categoria) => this.categoria = categoria;

  get getDescricao => this.descricao;

  set setDescricao(descricao) => this.descricao = descricao;

  get getLinkImagem => this.linkImagem;

  set setLinkImagem(linkImagem) => this.linkImagem = linkImagem;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoria': categoria,
      'descricao': descricao,
      'linkImagem': linkImagem,
    };
  }

  Produtos.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        categoria = doc.data()!['categoria'],
        descricao = doc.data()!['descricao'],
        linkImagem = doc.data()!['linkImagem'];

  @override
  String toString() {
    return '{ id: ${id}, categoria: ${categoria}, descricao: ${descricao}, linkImagem: ${linkImagem} }';
  }
}
