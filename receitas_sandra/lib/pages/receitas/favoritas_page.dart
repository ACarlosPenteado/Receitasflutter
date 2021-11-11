import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/repository/receitas_repository.dart';
import 'package:receitas_sandra/repository/users_repository.dart';
import 'package:receitas_sandra/widgets/list_demo.dart';

class FavoritasPage extends StatefulWidget {
  final String tipo;
  const FavoritasPage({Key? key, required this.tipo}) : super(key: key);

  @override
  State<FavoritasPage> createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  List receitas = [];
  List favoritas = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireDB = FirebaseFirestore.instance;

  @override
  void initState() {
    listFav();
    listReceita();
    super.initState();
  }

  listReceita() {
    ReceitasRepository repoRec = ReceitasRepository(auth: auth);
    repoRec.listReceita(widget.tipo).then((List list) {
      setState(() {
        receitas = list;
      });
    }).whenComplete(() => receitas);
  }

  listFav() {
    fireDB.collection('Users').doc(auth.currentUser!.uid).get().then((value) {
      favoritas = value.data()!['favoritas'];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              favoritas.isNotEmpty
                  ? ListDemo(list: favoritas, receitas: receitas)
                  : const Text(
                      'Não há receitas favoritas!',
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 40,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
