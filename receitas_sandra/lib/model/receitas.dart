class Receitas {
  String? id;
  String data;
  String descricao;
  bool favorita;
  String iduser;
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
    required this.iduser,
    required this.imagem,
    required this.ingredientes,
    required this.preparo,
    required this.rendimento,
    required this.tempoPreparo,
    required this.tipo,
  });

  @override
  String toString() {
    return '{ id: ${id}, data: ${data}, descricao: ${descricao}, favorita: ${favorita}, iduser: ${iduser}, imagem: ${imagem}, ingredientes: ${ingredientes}, preparo: ${preparo}, rendimento: ${rendimento}, tempoPreparo: ${tempoPreparo}, tipo: ${tipo}, }';
  }
}
