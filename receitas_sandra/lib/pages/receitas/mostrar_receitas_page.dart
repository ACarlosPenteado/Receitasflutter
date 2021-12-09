import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/receitas.dart';
import 'package:receitas_sandra/pages/receitas/incluir_receita_page.dart';
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

  @override
  void initState() {
    super.initState();
    size = 220;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    size = 150;
    Global.tamListI = 1;
    Global.tamListP = 1;
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
            fontSize: 30,
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => IncluirReceitaPage(tipo: Global.tipo),
                ),
              );
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
                  child: Stack(
                    children: [
                      widget.receitas.imagem != 'Sem Imagem'
                          ? Positioned(
                              top: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Hero(
                                tag: 'image' + widget.receitas.descricao,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    widget.receitas.imagem,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            )
                          : Positioned(
                              top: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Hero(
                                tag: 'image' + widget.receitas.descricao,
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
                            ),
                      Positioned(
                        top: 78,
                        left: 32,
                        //width: _screenWidth,
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
                                child: Hero(
                                  tag: 'sub1' + widget.receitas.descricao,
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
                              ),
                              Positioned(
                                top: 30,
                                left: 0,
                                width: _screenWidth,
                                child: Hero(
                                  tag: 'sub2' + widget.receitas.descricao,
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
                height: Global.tamListI.toDouble() * 8,
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
                child:
                    ListIngre(fontSize: 15, list: widget.receitas.ingredientes),
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
                height: Global.tamListP.toDouble() * 8,
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
                child: ListPrepa(fontSize: 15, list: widget.receitas.preparo),
              ),
            ],
          ),
      ],
    );
  }
}

class CustomAppBar extends StatefulWidget {
  final String title;
  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        height: 40,
        width: width,
        padding: const EdgeInsets.only(left: 0, top: 5, right: 5),
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.blue[200]!, Colors.cyanAccent]),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                iconSize: 30,
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            IconButton(
                iconSize: 30,
                icon: const Icon(
                  Icons.edit,
                ),
                onPressed: () {
                  Global.qual = 'E';
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            IncluirReceitaPage(tipo: Global.tipo)),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
