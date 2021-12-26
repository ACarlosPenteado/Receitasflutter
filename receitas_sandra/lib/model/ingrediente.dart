class Ingrediente {
  String? quantidade;
  String? medida;
  String? descricao;

  Ingrediente({
    this.quantidade,
    this.medida,
    this.descricao,
  });

  factory Ingrediente.fromJson(Map<dynamic, dynamic> json) => Ingrediente(
        quantidade: json['quantidade'],
        medida: json['medida'],
        descricao: json['descricao'],
      );

  Map<String, dynamic> toJson() => {
        'quantidade': quantidade,
        'medida': medida,
        'descricao': descricao,
      };

  @override
  String toString() {
    return '{ quantidade: ${quantidade}, medida: ${medida}, descricao: ${descricao} }';
  }
}
