class Ingrediente {
  late final String quantidade;
  late final String medida;
  late final String descricao;

  Ingrediente({
    required this.quantidade,
    required this.medida,
    required this.descricao,
  });

  get getQuantidade => this.quantidade;

  set setQuantidade(quantidade) => this.quantidade = quantidade;

  get getMedida => this.medida;

  set setMedida(medida) => this.medida = medida;

  get getDescricao => this.descricao;

  set setDescricao(descricao) => this.descricao = descricao;

  @override
  String toString() {
    return '{ quantidade: ${quantidade}, medida: ${medida}, descricao: ${descricao} }';
  }
}
