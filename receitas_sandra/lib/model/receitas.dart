class Receitas {
  String? id;
  String data;
  String descricao;
  bool favorita;
  String id_user;
  String imagem;
  List<String> ingredientes;
  List<String> preparo;
  String rendimento;
  String tempoPreparo;
  String tipo;

  Receitas({
    this.id,
    required this.data,
    required this.descricao,
    required this.favorita,
    required this.id_user,
    required this.imagem,
    required this.ingredientes,
    required this.preparo,
    required this.rendimento,
    required this.tempoPreparo,
    required this.tipo,
  });
}
