import 'package:flutter/material.dart';
import 'package:receitas_sandra/pages/drawer/busca.dart';
import 'package:receitas_sandra/widgets/anim3card.dart';
import 'package:receitas_sandra/widgets/dialog.dart';

class TestePage extends StatefulWidget {
  const TestePage({Key? key}) : super(key: key);

  @override
  _TestePageState createState() => _TestePageState();
}

class _TestePageState extends State<TestePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DialogCustom(
        txt: 'Quer procurar qual receita?',
        label: 'Nome da Receita',
        txtBtnCancel: 'Cancelar',
        txtBtnOk: 'Buscar',
        page: BuscaPage(),
      ),
    );
  }
}
