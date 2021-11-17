class IdUsers {
  late final String id;
  late final String idrec;

  IdUsers({
    required this.id,
    required this.idrec,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'idrec': idrec,
      };

  @override
  String toString() {
    return '{ id: ${id}, idrec: ${idrec} }';
  }
}
