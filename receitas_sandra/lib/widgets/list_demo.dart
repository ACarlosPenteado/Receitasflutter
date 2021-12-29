import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/model/preparo.dart';
import 'package:receitas_sandra/model/receitas.dart';
import 'package:receitas_sandra/pages/receitas/mostrar_receitas_page.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';

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

  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double _screenWidth = 0.0;
  double size = 150;

  List favoritas = [];
  List<Ingrediente> listIngre = [];
  List<Preparo> listPrepa = [];

  @override
  void initState() {
    //print(widget.receitas);
    listFavoritas();
    super.initState();
  }

  listFavoritas() {
    for (var i = 0; i < widget.receitas.length; i++) {
      if (widget.list.contains(widget.receitas[i].id)) {
        favoritas.add(widget.receitas[i]);
      }
    }
    print(favoritas);
  }

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
      itemCount: favoritas.length,
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
                    children: [
                      Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 5),
                          height: size,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF213B6C),
                                  Color(0xFF0059A5),
                                ]),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.cyan,
                                blurRadius: 12,
                                offset: Offset(3, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              /* favoritas[index].imagem != 'Sem Imagem'
                                  ? Positioned(
                                      top: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        child: Image.network(
                                          favoritas[index].imagem,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    )
                                  : Positioned(
                                      top: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        child: Image.asset(
                                          'images/receitas/receitas.prn',
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ), */
                              Positioned(
                                top: 78,
                                left: 32,
                                width: _screenWidth - 100,
                                child: Container(
                                  height: 60,
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    border: Border.all(
                                      color: Colors.cyanAccent.shade400,
                                      width: 3.0,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        child: Text(
                                          favoritas[index].descricao,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.cyanAccent,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 30,
                                        left: 0,
                                        width: _screenWidth,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Tempo de Preparo: ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              favoritas[index].tempoPreparo,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.cyanAccent,
                                              ),
                                            ),
                                            const Text(
                                              ' minutos',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 50,
                                        left: 0,
                                        width: _screenWidth,
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Rendimento: ',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              favoritas[index].rendimento,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.cyanAccent,
                                              ),
                                            ),
                                            const Text(
                                              ' porções',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
