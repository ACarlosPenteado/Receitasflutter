import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:receitas_sandra/model/users.dart';

class Authent extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Users? usuario;
  final bool isLoading = true;

  Authent() {
    _authCheck();
  }

  void _authCheck() async {
    

    notifyListeners();
  }
}
