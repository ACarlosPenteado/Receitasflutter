import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:receitas_sandra/pages/drawer/busca.dart';
import 'package:receitas_sandra/pages/drawer/data_user.dart';
import 'package:receitas_sandra/pages/login/entrar_page.dart';
import 'package:receitas_sandra/pages/receitas/escolhe_receita_page.dart';
import 'package:receitas_sandra/pages/receitas/listar_receita_page.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';
import 'package:receitas_sandra/widgets/dialog_custom.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';
  final String? uid;

  const HomePage({Key? key, this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  GlobalKey<ScaffoldState> mkey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final Color primary = Colors.blueGrey.shade300;
  final Color active = Colors.cyanAccent;
  final Color divider = Colors.black;

  String nome = '';
  String email = '';
  String imagem = '';

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    setState(() {
      getData();
    });
    mkey = _key;

    super.initState();
  }

  Future<List> getData() async {
    List dados = [];
    FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uid)
        .get()
        .then((event) {
      setState(() {
        Global.nome = event.data()!['nome'];
        Global.email = event.data()!['email'];
        Global.fone = event.data()!['fone'];
        Global.provedor = event.data()!['provedor'];
        Global.foto = event.data()!['imagem'];
      });
      dados.add(event);
    });
    /* doc.then((value) {
      if (value == null) {
        Fluttertoast.showToast(msg: 'Complete seus dados!');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DataUserPage()),
          (Route<dynamic> route) => false,
        );
      }
    }); */
    return dados;
  }

  DateTime time = DateTime.now();

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

    return WillPopScope(
      onWillPop: () async {
        final diff = DateTime.now().difference(time);
        final isExit = diff >= const Duration(seconds: 2);

        time = DateTime.now();

        if (isExit) {
          Fluttertoast.showToast(
            msg: 'Pressione novamente para sair',
            fontSize: 18,
            textColor: Colors.amber,
            backgroundColor: Colors.grey.shade700,
          );
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        key: _key,
        drawer: _buildDrawer(),
        appBar: AppBar(
          elevation: 12,
          centerTitle: true,
          leading: IconButton(
            iconSize: 30,
            icon: const Icon(
              Icons.menu,
            ),
            onPressed: () {
              mkey.currentState!.openDrawer();
            },
          ),
        ),
        body: Container(
          height: _height,
          width: _width,
          padding: const EdgeInsets.only(top: 63, bottom: 20),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.cyanAccent,
            ],
          )),
          child: OrientationBuilder(
            builder: (context, orientation) =>
                orientation == Orientation.portrait
                    ? buildPortrait()
                    : buildLandscape(),
          ),
        ),
      ),
    );
  }

  Widget buildPortrait() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            clipShape(),
            animeLetter(),
            const SizedBox(
              height: 60,
            ),
            buttonRec(),
          ],
        ),
      );

  Widget buildLandscape() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            clipShape(),
            animeLetter(),
            const SizedBox(
              height: 30,
            ),
            buttonRec(),
          ],
        ),
      );

  Widget buttonRec() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        InkWell(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Image.asset(
                  'images/receitas/doces.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
              const Text(
                'DOCES',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          onTap: () => Navigator.push(
            context,
            PageTransition(
              child: const ListarReceitaPage(tipo: 'Doces'),
              type: PageTransitionType.rotate,
              alignment: Alignment.bottomCenter,
              duration: const Duration(milliseconds: 600),
              reverseDuration: const Duration(milliseconds: 600),
            ),
          ),
        ),
        InkWell(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Image.asset(
                  'images/receitas/salgadas.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ),
              const Text(
                'SALGADAS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          onTap: () => Navigator.push(
            context,
            PageTransition(
              child: const ListarReceitaPage(tipo: 'Salgadas'),
              type: PageTransitionType.rotate,
              alignment: Alignment.bottomCenter,
              duration: const Duration(milliseconds: 600),
              reverseDuration: const Duration(milliseconds: 600),
            ),
          ),
        ),
      ],
    );
  }

  _buildDrawer() {
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        backgroundColor: Colors.blue,
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
            color: primary,
            /* boxShadow: const [
              BoxShadow(
                color: Colors.black45,
              ),
            ], */
          ),
          width: 400,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: active,
                      ),
                      onPressed: () {
                        _auth.signOut().then((res) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EntrarPage()),
                              (Route<dynamic> route) => false);
                        });
                      },
                    ),
                  ),
                  if (Global.foto != null)
                    Container(
                      height: 90,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [Colors.orange, Colors.deepOrange])),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(Global.foto),
                      ),
                    ),
                  const SizedBox(height: 15.0),
                  Text(
                    Global.nome,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    Global.email,
                    style: TextStyle(color: active, fontSize: 16.0),
                  ),
                  const Divider(
                    height: 5,
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 30.0),
                  _buildRow(Icons.search, "Busca na Internet"),
                  _buildDivider(),
                  _buildRow(Icons.person_pin, "Dados do Usuário"),
                  _buildDivider(),
                  _buildRow(Icons.settings, "Configuração"),
                  _buildDivider(),
                  _buildRow(Icons.email, "Contate-nos"),
                  _buildDivider(),
                  _buildRow(Icons.info_outline, "Ajuda"),
                  _buildDivider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Widget _buildRow(IconData icon, String title) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        child: Row(
          children: [
            Icon(
              icon,
              color: active,
            ),
            const SizedBox(width: 10.0),
            Text(
              title,
              style: tStyle,
            ),
            const Spacer(),
          ],
        ),
        onTap: () async {
          switch (title) {
            case 'Busca na Internet':
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return const DialogCustom(
                      qchama: 1,
                      txt: 'Que receita procura?',
                      label: 'Receita',
                      txtBtnCancel: 'Cancelar',
                      txtBtnOk: 'Buscar',
                    );
                  });
              break;
            case 'Dados do Usuário':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DataUserPage()),
              );
              break;
            case 'Configuração':
              print("Configuração");
              break;
            case 'Contate-nos':
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return const DialogCustom(
                      qchama: 2,
                      txt: 'Quer falar sobre oquê?',
                      labelrec: 'para: Receitas da Sandra',
                      labelsub: 'Assunto',
                      labelbod: 'Escrever mensagem',
                      txtBtnCancel: 'Cancelar',
                      txtBtnOk: 'Enviar',
                    );
                  });
              break;
            case 'Ajuda':
              print('Ajuda');
              break;
            default:
          }
        },
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
              colors: const [Colors.grey, Colors.white, Colors.grey],
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
              const Text(
                'Receitas da(o) ',
                style: TextStyle(fontSize: 25),
              ),
              Text(
                Global.nome,
                style: const TextStyle(fontSize: 25),
              ),
            ],
          ),
          blendMode: BlendMode.srcIn,
        );
      },
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            padding: const EdgeInsets.only(top: 60),
            child: Hero(
              tag: 'imagerec',
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Image.asset(
                  'images/receitas/receitas.jpg',
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Material(
      child: Container(
        height: 40,
        width: width,
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.blue[200]!, Colors.cyanAccent]),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: SizedBox(
                height: 30,
                width: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    padding: const EdgeInsets.only(top: 2, left: 4),
                    //elevation: 10,
                    alignment: Alignment.centerLeft,
                  ),
                  onPressed: () {
                    widget.mkey.currentState?.openDrawer();
                  },
                  child: Icon(Icons.menu, color: Colors.indigo.shade900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
