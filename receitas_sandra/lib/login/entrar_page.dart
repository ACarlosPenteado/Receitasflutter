import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/login/entrar_senha_page.dart';
import 'package:receitas_sandra/login/entrar_fone_page.dart';
import 'package:receitas_sandra/uteis/funtions.dart';
import 'package:receitas_sandra/uteis/globais.dart';

class EntrarPage extends StatefulWidget {
  static const routeName = '/EntrarPage';

  const EntrarPage({Key? key}) : super(key: key);

  @override
  _EntrarPageState createState() => _EntrarPageState();
}

class _EntrarPageState extends State<EntrarPage> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  FirebaseFirestore fireDb = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  String id = '';
  String nome = '';
  String email = '';
  String foto = '';
  String data = getDate;

  var loading = false;

  void _loginFacebook() async {
    setState(() {
      loading = true;
    });
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      await auth.signInWithCredential(facebookAuthCredential);

      id = auth.currentUser!.uid;
      email = userData['email'];
      foto = userData['picture']['data']['url'];
      nome = userData['name'];

      fireDb.collection('Users').doc(id).get().then((value) async {
        if (!value.exists) {
          await fireDb.collection('Users').doc(id).set({
            'data': data,
            'email': email,
            'fone': 'fone',
            'image': foto,
            'nome': nome,
            'provedor': 'Facebook',
          });
        }
      });
      Global.email = email;
      Global.nome = nome;
      Global.foto = foto;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomePage(uid: id)),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      var title = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          title = 'Esta conta existe com um provedor de login diferente!';
          break;
        case 'invalid-credential':
          title = 'Ocorreu um erro desconhecido!';
          break;
        case 'operation-not-allowed':
          title = 'Esta operação não é permitida!';
          break;
        case 'user-disabled':
          title = 'O usuário que você tentou acessar está desabilitado!';
          break;
        case 'User-not-found':
          title = 'O usuário que você tentou acessar não foi encontrado!';
          break;
        default:
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Entrar com Facebook falhou!'),
              content: Text(title),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void _loginGoogle() async {
    setState(() {
      loading = true;
    });
    final googleSignIn = GoogleSignIn(scopes: ['email']);

    try {
      final googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        setState(() {
          loading = false;
        });
        return;
      }
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await auth.signInWithCredential(credential);

      id = auth.currentUser!.uid;
      email = googleSignInAccount.email;
      foto = googleSignInAccount.photoUrl!;
      nome = googleSignInAccount.displayName!;

      fireDb.collection('Users').doc(id).get().then((value) async {
        if (!value.exists) {
          await fireDb.collection('Users').doc(id).set({
            'data': data,
            'email': email,
            'fone': 'fone',
            'image': foto,
            'nome': nome,
            'provedor': 'Google',
          });
        }
      });
      Global.email = email;
      Global.nome = nome;
      Global.foto = foto;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => HomePage(uid: id)),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      var title = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          title = 'Esta conta existe com um provedor de login diferente!';
          break;
        case 'invalid-credential':
          title = 'Ocorreu um erro desconhecido!';
          break;
        case 'operation-not-allowed':
          title = 'Esta operação não é permitida!';
          break;
        case 'user-disabled':
          title = 'O usuário que você tentou acessar está desabilitado!';
          break;
        case 'User-not-found':
          title = 'O usuário que você tentou acessar não foi encontrado!';
          break;
        default:
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Entrar com Google falhou!'),
              content: Text(title),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Entrar com Google falhou!'),
              content: const Text('Um erro desconhecido ocorreu'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    } finally {
      setState(() {
        loading = false;
      });
    }
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
        padding: const EdgeInsets.only(top: 48),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              clipShape(),
              if (loading) ...[
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
              if (!loading) ...[
                btnEmailSenha(),
                btnGoogle(),
                btnFacebook(),
                //btnFone(),
              ]
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
        const SizedBox(
          height: 40,
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 40
                  : (_medium ? _height / 33 : _height / 31)),
          child: Image.network(
            'https://receitanatureba.com/wp-content/uploads/2020/04/LAYER-BASE-RECEITA-NATUREBA.jpg',
            height: _height / 3.5,
            width: _width / 3.5,
          ),
        ),
      ],
    );
  }

  Widget btnEmailSenha() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SignInButton(
        Buttons.Email,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EntrarSenhaPage()));
        },
      ),
    );
  }

  Widget btnGoogle() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SignInButton(
        Buttons.Google,
        onPressed: () {
          _loginGoogle();
        },
      ),
    );
  }

  Widget btnFacebook() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SignInButton(
        Buttons.Facebook,
        onPressed: () {
          _loginFacebook();
        },
      ),
    );
  }

  Widget btnFone() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.cyanAccent,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ]),
          height: 35,
          width: 220,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              SizedBox(width: 10),
              Icon(Icons.phone),
              SizedBox(width: 20),
              Text(
                'Sign in with Mobile',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EntrarFonePage()));
        },
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
            const SizedBox(
              width: 30,
            ),
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
