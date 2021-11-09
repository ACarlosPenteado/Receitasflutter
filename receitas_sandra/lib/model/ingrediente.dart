import 'package:receitas_sandra/uteis/globais.dart';

class Ingrediente {
  late final String? quantidade;
  late final String? medida;
  late final String? descricao;

  Ingrediente({
    this.quantidade,
    this.medida,
    this.descricao,
  });

  get getQuantidade => this.quantidade;

  set setQuantidade(quantidade) => this.quantidade = quantidade;

  get getMedida => this.medida;

  set setMedida(medida) => this.medida = medida;

  get getDescricao => this.descricao;

  set setDescricao(descricao) => this.descricao = descricao;

  Map<String, dynamic> toMap() => {
        'quantidade': quantidade,
        'medida': medida,
        'descricao': descricao,
      };

  @override
  String toString() {
    return '{ quantidade: ${quantidade}, medida: ${medida}, descricao: ${descricao} }';
  }
}
