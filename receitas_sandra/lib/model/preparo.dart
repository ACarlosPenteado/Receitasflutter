class Preparo {
  late final String descricao;

  Preparo({
    required this.descricao,
  });

  get getDescricao => this.descricao;

  set setDescricao(descricao) => this.descricao = descricao;

  @override
  String toString() {
    return '{ descricao: ${descricao} }';
  }
}
