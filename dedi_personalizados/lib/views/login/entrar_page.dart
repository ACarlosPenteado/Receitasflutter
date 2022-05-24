import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dedi_personalizados/utils/funtions.dart';
import 'package:dedi_personalizados/utils/globais.dart';
import 'package:dedi_personalizados/views/home_page.dart';
// import 'package:dedi_personalizados/views/login/entrar_fone_page.dart';
// import 'package:dedi_personalizados/views/login/entrar_senha_page.dart';
import 'package:dedi_personalizados/widgets/button_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  DateTime time = DateTime.now();

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
      Global.provedor = 'Facebook';
      Global.email = email;
      Global.nome = nome;
      Global.foto = foto;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => HomePage(uid: id)),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      var title = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          title = 'Esta conta existe com um provedor de pages.login diferente!';
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
      Global.provedor = 'Google';
      Global.email = email;
      Global.nome = nome;
      Global.foto = foto;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => HomePage(uid: id)),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      var title = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          title = 'Esta conta existe com um provedor de pages.login diferente!';
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
        appBar: AppBar(
          elevation: 12,
          centerTitle: true,
          title: Text(Global.title),
        ),
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
          children: <Widget>[
            clipShape(0),
            if (loading) ...[
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
            if (!loading) ...[
              btnEmailSenha(0),
              btnGoogle(0),
              btnFacebook(0),
              //btnFone(),
              const SizedBox(
                height: 20,
              ),
              //btnAjuda(),
            ]
          ],
        ),
      );

  Widget buildLandscape() => SingleChildScrollView(
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: <Widget>[
                  clipShape(1),
                  if (loading) ...[
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!loading) ...[
                    btnEmailSenha(1),
                    btnGoogle(1),
                    btnFacebook(1),
                    //btnFone(),
                    //const SizedBox(
                    //height: 20,
                    //),
                    //btnAjuda(),
                  ]
                ],
              ),
            ),
          ],
        ),
      );

  Widget clipShape(int mode) {
    return Stack(
      children: <Widget>[
        mode == 0
            ? Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 60),
                  child: Hero(
                    tag: 'imagerec',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Image.asset(
                        'imagens/caneca.jpg',
                        height: 200,
                        width: 300,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Hero(
                    tag: 'imagerec',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      child: Image.asset(
                        'imagens/caneca.jpg',
                        height: 200,
                        width: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget btnEmailSenha(int mode) {
    return Button_Login(
        mode: mode,
        color: Colors.white,
        image: const AssetImage('imagens/icones/email.png'),
        text: 'Entrar com seu Email',
        onPressed: () {
          /*  Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EntrarSenhaPage())); */
        });
  }

  Widget btnGoogle(int mode) {
    return Button_Login(
        mode: mode,
        color: Colors.white,
        image: const AssetImage('imagens/icones/google.png'),
        text: 'Entrar sua conta Google',
        onPressed: () {
          _loginGoogle();
        });
  }

  Widget btnFacebook(int mode) {
    return Button_Login(
        mode: mode,
        color: Colors.white,
        image: const AssetImage('imagens/icones/facebook.png'),
        text: 'Entrar sua conta Facebook',
        onPressed: () {
          _loginFacebook();
        });
  }

  Widget btnFone(int mode) {
    return Button_Login(
        mode: mode,
        color: Colors.white10,
        image: const AssetImage('imagens/icones/fone.png'),
        text: 'Entrar número celular',
        onPressed: () {
          /* Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EntrarFonePage())); */
        });
  }

  Widget btnAjuda(int mode) {
    return Button_Login(
        mode: mode,
        color: Colors.white10,
        image: const AssetImage('imagens/icones/duvida.png'),
        text: 'Problemas? Entre em contato!',
        onPressed: () {
          /* Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EntrarSenhaPage())); */
        });
  }
}
