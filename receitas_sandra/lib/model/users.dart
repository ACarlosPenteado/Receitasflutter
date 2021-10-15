class Users {
  late final String nome;
  late final String email;
  late final String fone;
  late final String provedor;
  late final String data;

  Users({
    required this.nome,
    required this.email,
    required this.fone,
    required this.provedor,
    required this.data,
  });

  get getNome => this.nome;

  set setNome(nome) => this.nome = nome;

  get getEmail => this.email;

  set setEmail(email) => this.email = email;

  get getFone => this.fone;

  set setFone(fone) => this.fone = fone;

  get getProvedor => this.provedor;

  set setProvedor(provedor) => this.provedor = provedor;

  get getData => this.data;

  set setData(data) => this.data = data;

  
}
