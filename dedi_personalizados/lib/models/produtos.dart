import 'package:cloud_firestore/cloud_firestore.dart';

class Produtos {
  String id;
  String quantidade;
  String produto;
  String descricao;
  String linkImagem;
  String preco;

  Produtos({
    required this.id,
    required this.quantidade,
    required this.produto,
    required this.descricao,
    required this.linkImagem,
    required this.preco,
  });

  String get getId => this.id;

  set setId(String id) => this.id = id;

  get getQuantidade => this.quantidade;

  set setQuantidade(quantidade) => this.quantidade = quantidade;

  set setProduto(produto) => this.produto = produto;

  get getProduto => this.produto;

  get getDescricao => this.descricao;

  set setDescricao(descricao) => this.descricao = descricao;

  get getLinkImagem => this.linkImagem;

  set setLinkImagem(linkImagem) => this.linkImagem = linkImagem;

  set setPreco(preco) => this.preco = preco;

  get getPreco => this.preco;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantidade': quantidade,
      'produto': produto,
      'descricao': descricao,
      'linkImagem': linkImagem,
      'preco': preco,
    };
  }

  Produtos.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        quantidade = doc.data()!['quantidade'],
        produto = doc.data()!['produto'],
        descricao = doc.data()!['descricao'],
        linkImagem = doc.data()!['linkImagem'],
        preco = doc.data()!['preco'];

  @override
  String toString() {
    return '{ id: ${id}, quantidade: ${quantidade}, produto: ${produto}, descricao: ${descricao}, linkImagem: ${linkImagem}, preco: ${preco} }';
  }
}
