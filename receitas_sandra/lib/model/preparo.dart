import 'package:receitas_sandra/uteis/globais.dart';

class Preparo {
  String? descricao;

  Preparo({
    this.descricao,
  });

  factory Preparo.fromJson(Map<dynamic, dynamic> json) => Preparo(
        descricao: json['descricao'],
      );

  Map<String, dynamic> toJson() => {
        'descricao': descricao,
      };

  @override
  String toString() {
    return '{ descricao: ${descricao} }';
  }
}
