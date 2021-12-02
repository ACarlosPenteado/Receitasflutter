import 'package:receitas_sandra/uteis/globais.dart';

class Preparo {
  late final String? descricao;

  Preparo({
    this.descricao,
  });

  get getDescricao => this.descricao;

  set setDescricao(descricao) => this.descricao = descricao;

  Map<String, dynamic> toMap() => {
        'descricao': descricao,
      };

  @override
  String toString() {
    return '{ descricao: ${descricao} }';
  }

}
