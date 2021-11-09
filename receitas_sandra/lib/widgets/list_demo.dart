import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/model/preparo.dart';
import 'package:receitas_sandra/model/receitas.dart';
import 'package:receitas_sandra/pages/receitas/mostrar_receitas_page.dart';
import 'package:receitas_sandra/uteis/globais.dart';

class ListDemo extends StatefulWidget {
  final List list;
  final List receitas;

  const ListDemo({Key? key, required this.list, required this.receitas})
      : super(key: key);

  @override
  State<ListDemo> createState() => _ListDemoState();
}

class _ListDemoState extends State<ListDemo> {
  FirebaseFirestore fbDb = FirebaseFirestore.instance;

  List<Receitas> receFav = [];
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double size = 150;

  @override
  void initState() {
    for (var i = 0; i < widget.receitas.length; i++) {
      for (var j = 0; j < widget.list.length; j++) {
        if (widget.receitas[i].id == widget.list.elementAt(j)) {
          receFav.add(widget.receitas[i]);
        }
      }
    }
    super.initState();
  }

  List<Ingrediente> listIngre = [];
  List<Preparo> listPrepa = [];

  preencheListIngre(List<dynamic> list) async {
    listIngre.clear();
    for (var i = 0; i < list.length; i++) {
      listIngre.add(
        Ingrediente(
            quantidade: list.elementAt(i)['quantidade'],
            medida: list.elementAt(i)['medida'],
            descricao: list.elementAt(i)['descricao']),
      );
    }
    Global.ingredientes = listIngre;
    Global.tamListI += list.length;
  }

  preencheListPrepa(List<dynamic> list) async {
    listPrepa.clear();
    for (var i = 0; i < list.length; i++) {
      listPrepa.add(
        Preparo(descricao: list.elementAt(i)['descricao']),
      );
    }
    Global.preparo = listPrepa;
    Global.tamListP += list.length;
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    final primaryColor = Theme.of(context).primaryColor;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: receFav.length,
      itemBuilder: (_, index) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Container(
                height: size,
                width: _width,
                margin: const EdgeInsets.only(
                    left: 16, top: 0, right: 16, bottom: 5),
                child: InkWell(
                  child: Stack(
                    children: <Widget>[
                      Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: Colors.white,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 36),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFF213B6C), Color(0xFF0059A5)]),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.cyan,
                                blurRadius: 12,
                                offset: Offset(3, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              receFav[index].imagem != 'Sem Imagem'
                                  ? Image.network(
                                      receFav[index].imagem,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      'images/receitas/receitas.prn',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.fill,
                                    ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      receFav[index].descricao,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Tempo de Preparo: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          receFav[index].tempoPreparo,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pinkAccent,
                                          ),
                                        ),
                                        const Text(
                                          ' minutos',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Rendimento: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          receFav[index].rendimento,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pinkAccent,
                                          ),
                                        ),
                                        const Text(
                                          ' porções',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 8,
                        top: 8,
                        child: Icon(
                          Icons.star,
                          size: 32,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      preencheListIngre(receFav[index].ingredientes);
                      preencheListPrepa(receFav[index].preparo);
                      Global.descricao = receFav[index].descricao;
                      Global.id = receFav[index].id!;
                      Global.iduser = receFav[index].iduser;
                      Global.imagem = receFav[index].imagem;
                      Global.rendimento = receFav[index].rendimento;
                      Global.tempoPreparo = receFav[index].tempoPreparo;

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MostrarReceitaPage()));
                    });
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ResponsiveWidget {
  static bool isScreenLarge(double width, double pixel) {
    return width * pixel >= 1440;
  }

  static bool isScreenMedium(double width, double pixel) {
    return width * pixel < 1440 && width * pixel >= 1080;
  }

  static bool isScreenSmall(double width, double pixel) {
    return width * pixel <= 720;
  }
}
