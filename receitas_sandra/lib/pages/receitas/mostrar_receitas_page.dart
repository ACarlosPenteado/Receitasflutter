import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:receitas_sandra/model/receitas.dart';
import 'package:receitas_sandra/pages/receitas/incluir_receita_page.dart';
import 'package:receitas_sandra/pages/receitas/listar_receita_page.dart';
import 'package:receitas_sandra/repository/receitas_repository.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';
import 'package:receitas_sandra/widgets/listingre.dart';
import 'package:receitas_sandra/widgets/listprepa.dart';

class MostrarReceitaPage extends StatefulWidget {
  static const routeName = '/MostrarReceitaPage';
  final Receitas receitas;
  const MostrarReceitaPage({Key? key, required this.receitas})
      : super(key: key);

  @override
  _MostrarReceitaPageState createState() => _MostrarReceitaPageState();
}

class _MostrarReceitaPageState extends State<MostrarReceitaPage> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  double _screenWidth = 0.0;
  late double size;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore fireDb = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    size = 220;
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
  }

  void confirma(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.black45,
          content: Container(
            width: _screenWidth,
            height: 50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Text(
                  'Confirma Exclusão',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Ok',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent,
                ),
              ),
              onPressed: () {
                if (widget.receitas.iduser == _auth.currentUser!.uid) {
                  exclui(widget.receitas.id);
                  Fluttertoast.showToast(msg: 'Receita Excluída');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          ListarReceitaPage(tipo: widget.receitas.tipo),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(msg: 'Receita de outro usuário');
                }
              },
            ),
            TextButton(
              child: const Text(
                'Cancela',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void exclui(String? id) {
    ReceitasRepository recRepo =
        ReceitasRepository(auth: _auth.currentUser!.uid);
    recRepo.excluiReceita(id!);
  }

  @override
  void dispose() {
    size = 150;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Scaffold(
      body: Container(
        height: _height,
        width: _width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.cyanAccent,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              clipShape(),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 12,
        centerTitle: true,
        leading: IconButton(
          iconSize: 30,
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          widget.receitas.descricao,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.purpleAccent,
          ),
        ),
        actions: [
          IconButton(
            iconSize: 30,
            icon: const Icon(
              Icons.edit,
            ),
            onPressed: () {
              Global.qual = 'E';
              Global.id = widget.receitas.id!;
              Global.imagem = widget.receitas.imagem;
              Global.descricao = widget.receitas.descricao;
              Global.tempoPreparo = widget.receitas.tempoPreparo;
              Global.rendimento = widget.receitas.rendimento;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => IncluirReceitaPage(tipo: Global.tipo),
                ),
              );
            },
          ),
          IconButton(
            iconSize: 30,
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () {
              confirma(widget.receitas.id!);
            },
          ),
        ],
      ),
    );
  }

  Widget clipShape() {
    return Column(
      children: [
        SafeArea(
          child: Center(
            child: Container(
              height: 150,
              width: _width,
              margin: const EdgeInsets.only(
                  left: 16, top: 16, right: 16, bottom: 5),
              child: Card(
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
                        colors: [Color(0xFF213B6C), Color(0xFF0059A5)]),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.cyan,
                        blurRadius: 12,
                        offset: Offset(3, 5),
                      ),
                    ],
                  ),
                  child: Hero(
                    tag: 'card' + widget.receitas.descricao,
                    child: Stack(
                      children: [
                        widget.receitas.imagem != 'Sem Imagem'
                            ? Positioned(
                                top: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    widget.receitas.imagem,
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
                                    'images/receitas/receitas.png',
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
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
                                  width: _screenWidth,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        widget.receitas.tempoPreparo,
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
                                ),
                                Positioned(
                                  top: 30,
                                  left: 0,
                                  width: _screenWidth,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        widget.receitas.rendimento,
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
          ),
        ),
        if (Global.tamListI > 1)
          Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              const Divider(
                height: 5,
                color: Colors.purple,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.purple),
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey.shade700,
                        Colors.black26,
                      ]),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'Ingredientes',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                height: 5,
                color: Colors.purple,
              ),
              const SizedBox(
                height: 5,
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 5),
                height: Global.tamListI.toDouble() * 25,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey.shade100,
                        Colors.black45,
                      ]),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.cyan,
                      blurRadius: 8,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: ListIngre(
                  fontSize: 15,
                  list: widget.receitas.ingredientes,
                  qq: 'm',
                ),
              ),
            ],
          ),
        if (Global.tamListP > 1)
          Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              const Divider(
                height: 5,
                color: Colors.purple,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.purple),
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey.shade700,
                        Colors.black26,
                      ]),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: const Text(
                  'Modo de Preparo',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                height: 5,
                color: Colors.purple,
              ),
              const SizedBox(
                height: 5,
              ),
              AnimatedContainer(
                duration: const Duration(seconds: 5),
                height: Global.tamListP.toDouble() * 25,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.grey.shade100,
                        Colors.black45,
                      ]),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.cyan,
                      blurRadius: 8,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: ListPrepa(
                  fontSize: 15,
                  list: widget.receitas.preparo,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
