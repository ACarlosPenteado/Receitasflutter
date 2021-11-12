import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/pages/receitas/incluir_receita_page.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/listingre.dart';
import 'package:receitas_sandra/widgets/listprepa.dart';

class MostrarReceitaPage extends StatefulWidget {
  static const routeName = '/MostrarReceitaPage';

  const MostrarReceitaPage({Key? key}) : super(key: key);

  @override
  _MostrarReceitaPageState createState() => _MostrarReceitaPageState();
}

class _MostrarReceitaPageState extends State<MostrarReceitaPage> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  late double size;

  @override
  void initState() {
    super.initState();
    size = 220;
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
        )),
        padding: const EdgeInsets.only(top: 48),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              clipShape(),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200]!, Colors.cyanAccent],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[200]!, Colors.cyanAccent],
                ),
              ),
            ),
          ),
        ),
        const Opacity(opacity: 0.88, child: CustomAppBar()),
        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(top: 30),
          //_large ? _height / 40 : (_medium ? _height / 33 : _height / 31),
          child: Column(
            children: [
              SafeArea(
                child: Center(
                  child: Container(
                    height: _height,
                    width: _width,
                    margin: const EdgeInsets.only(
                        left: 16, top: 0, right: 16, bottom: 5),
                    child: Stack(
                      children: [
                        Card(
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          color: Colors.white,
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 5),
                            height: Global.tamListI.toDouble() > 1
                                ? size + Global.tamListI.toDouble() * 50
                                : size,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF213B6C),
                                    Color(0xFF0059A5)
                                  ]),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.cyan,
                                  blurRadius: 12,
                                  offset: Offset(3, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image.network(
                                      Global.imagem,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.fill,
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            Global.descricao,
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
                                                Global.tempoPreparo,
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
                                                Global.rendimento,
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
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  height: 5,
                                  color: Colors.purple,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (Global.tamListI > 1)
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.purple),
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
                                  height: 10,
                                ),
                                if (Global.tamListI > 1)
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 5),
                                      height: size +
                                          Global.tamListI.toDouble() * 50,
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
                                          list: Global.ingredientes),
                                    ),
                                  ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  height: 5,
                                  color: Colors.purple,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (Global.tamListP > 1)
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.purple),
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
                                  height: 10,
                                ),
                                if (Global.tamListP > 1)
                                  Expanded(
                                    child: AnimatedContainer(
                                      duration: const Duration(seconds: 5),
                                      height: size +
                                          Global.tamListP.toDouble() * 50,
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
                                          fontSize: 15, list: Global.preparo),
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
            ],
          ),
        ),
      ],
    );
  }

  Widget tipoRec() {
    return Text(
      Global.descricao,
      style: const TextStyle(
        fontSize: 30,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        color: Color(0xFF01579B),
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 70);

    var firstEndPoint = Offset(size.width * .5, size.height - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 50.0);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 50.0);
    var secondControlPoint = Offset(size.width * .75, size.height - 10);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class CustomShapeClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 20);

    var firstEndPoint = Offset(size.width * .5, size.height - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 50.0);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 5);
    var secondControlPoint = Offset(size.width * .75, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

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
            const Text(
              'Receitas da Sandra',
              style: TextStyle(
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
                  print(Global.ingredientes);
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
