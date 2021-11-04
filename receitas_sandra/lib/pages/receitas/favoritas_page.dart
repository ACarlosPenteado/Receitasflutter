import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/receitas.dart';
import 'package:receitas_sandra/repository/users_repository.dart';
import 'package:receitas_sandra/widgets/list_demo.dart';

class FavoritasPage extends StatefulWidget {
  final String uid;
  final List<Receitas> receitas;

  const FavoritasPage({Key? key, required this.uid, required this.receitas})
      : super(key: key);

  @override
  State<FavoritasPage> createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  List favoritas = [];

  @override
  void initState() {
    UsersRepository.listFavoritas(widget.uid).then((List list) {
      setState(() {
        favoritas = list;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    favoritas.clear();
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
                  ? ListDemo(list: favoritas, receitas: widget.receitas)
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
