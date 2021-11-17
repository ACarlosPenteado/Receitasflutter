import 'package:receitas_sandra/model/iduser.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/model/preparo.dart';

class Global {
  static String nome = '';
  static String email = '';
  static String fone = '';
  static String foto = '';

  static String nomeRec = '';

  static String id = '';
  static String data = '';
  static String descricao = '';
  static List iduser = [];
  static String imagem = '';
  static List<Ingrediente> ingredientes = [];
  static List<Preparo> preparo = [];
  static String rendimento = '';
  static String tempoPreparo = '';
  static String tipo = '';

  static String senhaMessage = '''* Mínimo 6 caracteres, sendo:
* Mínimo 1 letra maiúscula;  
* Mínimo 1 letra minúscula;
* Mínimo 1 Número;
* Mínimo 1 caractere especial;''';

  static int tamListI = 1;
  static int tamListP = 1;

  static String qual = '';
}
