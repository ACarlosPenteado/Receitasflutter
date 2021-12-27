import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:receitas_sandra/repository/users_repository.dart';
import 'package:uuid/uuid.dart';

FirebaseAuth auth = FirebaseAuth.instance;

String get getDate {
  String data = DateTime.now().toString();
  var inputFormat = DateFormat('yyyy-MM-dd');
  var inputDate = inputFormat.parse(data);
  var outputFormat = DateFormat('dd/MM/yyyy');
  return outputFormat.format(inputDate);
}

String get getId {
  var uid = Uuid();
  var v4 = uid.v4();
  String novo = v4.toString();
  return novo;
}

String get getUser {
  var uid = Uuid();
  var v4 = uid.v1();
  String novo = v4.toString();
  return novo;
}

Future<String> getNome(String idUser) {
  var userRepo = UsersRepository(auth: auth.currentUser!.uid);
  Future<String> userNome = userRepo.nomeUser(idUser);
  return userNome;
}
