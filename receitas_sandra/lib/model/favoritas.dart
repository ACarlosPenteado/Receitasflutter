class Favoritas {
  String? idrec;

  Favoritas({
    this.idrec,
  });

  factory Favoritas.fromJson(Map<dynamic, dynamic> json) => Favoritas(
        idrec: json['idrec'],
      );

  Map<String, dynamic> toJson() => {
        'idrec': idrec,
      };

  @override
  String toString() {
    return '{ idrec: ${idrec} }';
  }
}
