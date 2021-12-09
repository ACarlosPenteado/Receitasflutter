import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/transitions/transitions.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  User? result = FirebaseAuth.instance.currentUser;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    Timer(const Duration(seconds: 5), () {
      if (result != null) {
        Global.nome = result!.displayName.toString();
        print(Global.nome);
        Navigator.pushAndRemoveUntil(
            context,
            CustomPageRoute(HomePage(uid: result!.uid)),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushReplacementNamed('/EntrarPage');
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();

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
      key: _key,
      body: Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue.shade200,
            Colors.cyanAccent,
          ],
        )),
        child: OrientationBuilder(
          builder: (context, orientation) => orientation == Orientation.portrait
              ? buildPortrait()
              : buildLandscape(),
        ),
      ),
    );
  }

  Widget buildPortrait() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            clipShape(),
            Center(
              child: Hero(
                tag: 'imagerec',
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  child: Image.asset(
                    'images/receitas/receitas.jpg',
                    height: 200,
                    width: 200,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            animeLetter(),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Carregando...',
              style: TextStyle(
                fontSize: 30,
                color: Colors.cyan,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(3.0, 3.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(55, 0, 162, 232),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blue),
              strokeWidth: 5.0,
            ),
          ],
        ),
      );

  Widget buildLandscape() => SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            clipShapeL(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: [
                    Hero(
                      tag: 'image1',
                      child: Container(
                        //alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        margin: EdgeInsets.only(
                            top: _large
                                ? _height / 60
                                : (_medium ? _height / 65 : _height / 60)),
                        child: Image.asset(
                          'images/receitas/receitas.jpg',
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    animeLetter(),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Carregando...',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.cyan,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(3.0, 3.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(55, 0, 162, 232),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.purple),
                      strokeWidth: 5.0,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

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
      ],
    );
  }

  Widget clipShapeL() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              width: _large
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
              width: _large
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
      ],
    );
  }

  Widget animeLetter() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, widget) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              colors: const [Colors.blue, Colors.white, Colors.blue],
              stops: [
                controller.value - 0.3,
                controller.value,
                controller.value + 0.3
              ],
            ).createShader(
              Rect.fromLTWH(0, 0, rect.width, rect.height),
            );
          },
          child: Column(
            children: const [
              Text(
                'Receitas',
                style: TextStyle(fontSize: 40),
              ),
            ],
          ),
          blendMode: BlendMode.srcIn,
        );
      },
    );
  }
}
