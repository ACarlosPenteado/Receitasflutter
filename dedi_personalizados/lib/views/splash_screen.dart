import 'dart:async';
import 'package:dedi_personalizados/transitions/transitions.dart';
import 'package:dedi_personalizados/utils/globais.dart';
import 'package:dedi_personalizados/views/home_page.dart';
import 'package:dedi_personalizados/views/login/entrar_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        Global.id = result!.uid;
        Global.nome = result!.displayName.toString();
        print(Global.nome);
        Navigator.pushAndRemoveUntil(
            context,
            CustomPageRoute(HomePage(uid: Global.id)),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            CustomPageRoute(const EntrarPage()),
            (Route<dynamic> route) => false);
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
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              clipShape(0),
              const SizedBox(
                height: 40,
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
        ),
      );

  Widget buildLandscape() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: [
                      clipShape(1),
                    ],
                  ),
                  const SizedBox(
                    width: 60,
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
        ),
      );

  Widget clipShape(int mode) {
    return Center(
      child: Hero(
        tag: 'imagerec',
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: Image.asset(
            'imagens/FB_IMG_1.jpg',
            height: 200,
            width: 200,
            fit: BoxFit.fill,
          ),
        ),
      ),
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
            children: [
              Text(
                Global.title,
                style: const TextStyle(fontSize: 30),
              ),
            ],
          ),
          blendMode: BlendMode.srcIn,
        );
      },
    );
  }
}
