import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/model/preparo.dart';
import 'package:receitas_sandra/model/receitas.dart';
import 'package:receitas_sandra/pages/receitas/mostrar_receitas_page.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';

class ListFavoritas extends StatefulWidget {
  final List list;
  final List receitas;

  const ListFavoritas({Key? key, required this.list, required this.receitas})
      : super(key: key);

  @override
  State<ListFavoritas> createState() => _ListFavoritasState();
}

class _ListFavoritasState extends State<ListFavoritas> {
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

  preencheListIngre(int ql, List list) async {
    listIngre = [];
    Global.tamListI = 0;
    if (ql == 0) {
      for (var i = 0; i < list.length; i++) {
        listIngre.add(
          Ingrediente(
              quantidade: list.elementAt(i)['quantidade'],
              medida: list.elementAt(i)['medida'],
              descricao: list.elementAt(i)['descricao']),
        );
      }
    } else {
      for (var i = 0; i < list.length; i++) {
        listIngre.add(
          Ingrediente(
              quantidade: list.elementAt(i).quantidade,
              medida: list.elementAt(i).medida,
              descricao: list.elementAt(i).descricao),
        );
      }
    }
    Global.tamListI += listIngre.length;
  }

  preencheListPrepa(int ql, List list) async {
    listPrepa = [];
    Global.tamListP = 0;
    if (ql == 0) {
      for (var i = 0; i < list.length; i++) {
        listPrepa.add(
          Preparo(descricao: list.elementAt(i)['descricao']),
        );
      }
    } else {
      for (var i = 0; i < list.length; i++) {
        listPrepa.add(
          Preparo(descricao: list.elementAt(i).descricao),
        );
      }
    }
    Global.tamListP += listPrepa.length;
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
                  child: Hero(
                    tag: 'card' + favoritas[index].descricao,
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
                                favoritas[index].imagem == 'Sem Imagem'
                                    ? Positioned(
                                        top: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          child: Image.asset(
                                            'images/receitas/receitas.png',
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      )
                                    : Positioned(
                                        top: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        bottom: 0.0,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          child: Image.network(
                                            favoritas[index].imagem,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                Positioned(
                                  top: 70,
                                  left: 32,
                                  width: 290,
                                  child: Container(
                                    height: 70,
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
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
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 5,
                                                    offset: Offset(1, 1),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        Positioned(
                                          top: 30,
                                          left: 0,
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
                                                    shadows: [
                                                      Shadow(
                                                        color:
                                                            Colors.cyanAccent,
                                                        blurRadius: 5,
                                                        offset: Offset(1, 1),
                                                      ),
                                                    ]),
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
                                                    shadows: [
                                                      Shadow(
                                                        color:
                                                            Colors.cyanAccent,
                                                        blurRadius: 5,
                                                        offset: Offset(1, 1),
                                                      ),
                                                    ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 45,
                                          left: 0,
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Rendimento: ',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    shadows: [
                                                      Shadow(
                                                        color:
                                                            Colors.cyanAccent,
                                                        blurRadius: 5,
                                                        offset: Offset(1, 1),
                                                      ),
                                                    ]),
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
                                                    shadows: [
                                                      Shadow(
                                                        color:
                                                            Colors.cyanAccent,
                                                        blurRadius: 5,
                                                        offset: Offset(1, 1),
                                                      ),
                                                    ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 8,
                                  top: 8,
                                  child: Icon(
                                    Icons.star,
                                    size: 32,
                                    color: Colors.indigoAccent.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      preencheListIngre(1, favoritas[index].ingredientes);
                      preencheListPrepa(1, favoritas[index].preparo);
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          fullscreenDialog: true,
                          transitionDuration:
                              const Duration(milliseconds: 1000),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return MostrarReceitaPage(
                              receitas: Receitas(
                                ativo: favoritas[index].ativo,
                                id: favoritas[index].id,
                                data: favoritas[index].data,
                                descricao: favoritas[index].descricao,
                                iduser: favoritas[index].iduser,
                                imagem: favoritas[index].imagem,
                                ingredientes: listIngre,
                                preparo: listPrepa,
                                rendimento: favoritas[index].rendimento,
                                tempoPreparo: favoritas[index].tempoPreparo,
                                tipo: favoritas[index].tipo,
                              ),
                            );
                          },
                          transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
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
