import 'package:cloud_firestore/cloud_firestore.dart';

class Produtos {
  String id;
  String quantidade;
  String descricao;
  String linkImagem;

  Produtos({
    required this.id,
    required this.quantidade,
    required this.descricao,
    required this.linkImagem,
  });

  String get getId => this.id;

  set setId(String id) => this.id = id;

  get getQuantidade => this.quantidade;

  set setQuantidade(quantidade) => this.quantidade = quantidade;

  get getDescricao => this.descricao;

  set setDescricao(descricao) => this.descricao = descricao;

  get getLinkImagem => this.linkImagem;

  set setLinkImagem(linkImagem) => this.linkImagem = linkImagem;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantidade': quantidade,
      'descricao': descricao,
      'linkImagem': linkImagem,
    };
  }

  Produtos.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        quantidade = doc.data()!['quantidade'],
        descricao = doc.data()!['descricao'],
        linkImagem = doc.data()!['linkImagem'];

  @override
  String toString() {
    return '{ id: ${id}, quantidade: ${quantidade}, descricao: ${descricao}, linkImagem: ${linkImagem} }';
  }
}
