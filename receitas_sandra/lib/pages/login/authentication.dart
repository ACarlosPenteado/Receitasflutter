import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Authent extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String email;
  String get getEmail {
    return email;
  }

  Future registrar(String email, String senha) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: senha);

    User? user = userCredential.user;
    email = user!.email!;
    notifyListeners();
    return user.uid;
  }

  Future login(String email, String senha) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: senha);

    User? user = userCredential.user;
    email = user!.email!;
    notifyListeners();
    return user.uid;
  }
}
