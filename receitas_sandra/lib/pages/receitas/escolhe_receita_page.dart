import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:receitas_sandra/pages/receitas/listar_receita_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';

class EscolherReceitaPage extends StatefulWidget {
  static const routeName = '/EscolherReceitaPage';
  final String tipo;

  EscolherReceitaPage({Key? key, required this.tipo}) : super(key: key);

  @override
  _EscolherReceitaPageState createState() => _EscolherReceitaPageState();
}

class _EscolherReceitaPageState extends State<EscolherReceitaPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  int currentItem = 0;
  String qual = '';

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    super.initState();
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _key,
        body: Container(
          height: _height,
          width: _width,
          padding: const EdgeInsets.only(top: 48, bottom: 20),
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
          child: OrientationBuilder(
            builder: (context, orientation) =>
                orientation == Orientation.portrait
                    ? buildPortrait()
                    : buildLandscape(),
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: currentItem,
          showElevation: true,
          itemCornerRadius: 8,
          curve: Curves.easeInBack,
          onItemSelected: (index) => setState(() {
            currentItem = index;
            if (index == 0) {
              qual = 'Todas';
            } else if (index == 1) {
              qual = 'Minhas';
            } else if (index == 2) {
              qual = 'Compartilhadas';
            }
          }),
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.all_inbox),
              title: const Text('Todas'),
              activeColor: Colors.cyan,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Minhas'),
              activeColor: Colors.cyan.shade100,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.share),
              title: const Text('Compartilhadas'),
              activeColor: Colors.cyan.shade800,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPortrait() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            clipShape(),
            const SizedBox(
              height: 60,
            ),
            animec(),
          ],
        ),
      );

  Widget buildLandscape() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            clipShape(),
            animec(),
          ],
        ),
      );

  Widget animec() => AnimatedContainer(
        duration: const Duration(seconds: 5),
        padding: const EdgeInsets.all(10),
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
        child: Column(
          children: [],
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
        Opacity(opacity: 0.88, child: CustomAppBar(mkey: _key)),
        const SizedBox(
          height: 60,
        ),
        Container(
          padding: const EdgeInsets.only(top: 70),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
          ),
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 50
                  : (_medium ? _height / 55 : _height / 50)),
          child: Text(
            qual,
            style: const TextStyle(
              color: Colors.indigo,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 40, 0);
    path.quadraticBezierTo(
        size.width, size.height / 4, size.width, size.height / 2);
    path.quadraticBezierTo(size.width, size.height - (size.height / 4),
        size.width - 40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustomAppBar extends StatefulWidget {
  GlobalKey<ScaffoldState> mkey = GlobalKey<ScaffoldState>();
  CustomAppBar({Key? key, required this.mkey}) : super(key: key);

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
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
                        Icons.menu_book,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
