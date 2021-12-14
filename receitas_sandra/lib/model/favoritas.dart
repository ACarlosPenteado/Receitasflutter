class Favoritas {
  late final String? iduser;
  late final String? idrec;

  Favoritas({
    this.iduser,
    this.idrec,
  });

  factory Favoritas.fromJson(Map<dynamic, dynamic> json) => Favoritas(
        iduser: json['iduser'],
        idrec: json['idrec'],
      );

  Map<String, dynamic> toJson() => {
        'iduser': iduser,
        'idrec': idrec,
      };

  @override
  String toString() {
    return '{ iduser: ${iduser}, idrec: ${idrec} }';
  }
}
