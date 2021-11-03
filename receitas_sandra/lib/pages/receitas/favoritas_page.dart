import 'package:flutter/material.dart';
import 'package:receitas_sandra/repository/receitas_repository.dart';
import 'package:receitas_sandra/repository/users_repository.dart';
import 'package:receitas_sandra/widgets/widgets.dart';

class FavoritasPage extends StatefulWidget {
  final String uid;

  const FavoritasPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<FavoritasPage> createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  List favoritas = [];

  @override
  void initState() {
    super.initState();
    UsersRepository.listFavoritas(widget.uid).then((List list) {
      setState(() {
        favoritas = list;
      });
    });
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
                  ? ListDemo(list: favoritas)
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
