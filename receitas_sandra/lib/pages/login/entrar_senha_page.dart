import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/pages/login/cadastrar_senha_page.dart';
import 'package:receitas_sandra/pages/login/entrar_page.dart';
import 'package:receitas_sandra/uteis/globais.dart';

class EntrarSenhaPage extends StatefulWidget {
  const EntrarSenhaPage({Key? key}) : super(key: key);
  final routeName = '/EntrarSenhaPage';

  @override
  _EntrarSenhaPageState createState() => _EntrarSenhaPageState();
}

class _EntrarSenhaPageState extends State<EntrarSenhaPage> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();

  final FocusNode _focusNome = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusSenha = FocusNode();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _senhaVisible = true;
  bool _enabledEmail = false;
  bool _enabledSenha = false;

  int qB = 0;

  @override
  initState() {
    super.initState();
    _focusNome.addListener(() {
      CollectionReference colRef =
          FirebaseFirestore.instance.collection('Users');
      colRef
          .where('nome', isEqualTo: nomeController.text)
          .snapshots()
          .listen((event) {
        if (event.docs.isNotEmpty) {
          Global.nome = event.docs[0]['nome'].toString();
          Global.email = event.docs[0]['email'].toString();
          Global.fone = event.docs[0]['fone'].toString();
          if (event.docs[0]['foto'].toString().isNotEmpty) {
            Global.foto = event.docs[0]['foto'].toString();
          } else {
            Global.foto =
                'https://www.auctus.com.br/wp-content/uploads/2017/09/sem-imagem-avatar.png';
          }
          emailController.text = Global.email;
          _enabledSenha = true;
        } else {
          emailController.text = '';
          senhaController.text = '';
          if (nomeController.text.isNotEmpty) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Nome não encontrado!'),
                    content: const Text('Esqueceu seu nome de acesso?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CadatrarSenhaPage()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text('Se cadastrar!'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _enabledEmail = true;
                            _enabledSenha = true;
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text('Tentar com email!'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EntrarPage()),
                              (Route<dynamic> route) => false);
                        },
                        child: const Text('Sair'),
                      ),
                    ],
                  );
                });
          }
        }
      });
    });
  }

  resetSenha() {
    _auth.sendPasswordResetEmail(email: emailController.text);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Verificação"),
            content: Text(
                'Um mensagem foi enviada para ${emailController.text}, por favor verifique!'),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  setState(() {
                    _enabledSenha = true;
                    qB = 1;
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    _focusNome.dispose();
    _focusEmail.dispose();
    _focusSenha.dispose();
  }

  bool isLogginIn = false;

  login(String email, String senha) async {
    setState(() {
      isLogginIn = true;
    });
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: senha)
          .then((result) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage(uid: _auth.currentUser!.uid.toString())));
      });
    } on FirebaseAuthException catch (e) {
      var mensagem = '';
      switch (e.code) {
        case 'invalid-email':
          mensagem = 'O email não é válido!';
          break;
        case 'user-disabled':
          mensagem = 'O email está desabilitado!';
          break;
        case 'user-not-found':
          mensagem = 'Email não encontrado!';
          break;
        case 'wrong-password':
          mensagem = 'Senha incorreta!';
          break;
        default:
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Falha para entrar!'),
              content: Text(mensagem),
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
        isLogginIn = false;
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
              welcomeTextRow(),
              signInTextRow(),
              form(),
              forgetPassTextRow(),
              !isLogginIn
                  ? button()
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;

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
                  ? _height / 50
                  : (_medium ? _height / 55 : _height / 50)),
          child: Image.network(
            'https://receitanatureba.com/wp-content/uploads/2020/04/LAYER-BASE-RECEITA-NATUREBA.jpg',
            height: _height / 3.5,
            width: _width / 3.5,
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 90),
      child: Row(
        children: <Widget>[
          Text(
            'Bem-vinda(o)',
            style: TextStyle(
              color: Colors.indigo.shade700,
              fontWeight: FontWeight.bold,
              fontSize: _large ? 60 : (_medium ? 50 : 40),
            ),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Entre em sua conta!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade200,
              fontSize: _large ? 20 : (_medium ? 17.5 : 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            nomeTextFormField(),
            SizedBox(
              height: _height / 40.0,
            ),
            emailTextFormField(),
            SizedBox(
              height: _height / 40.0,
            ),
            senhaTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget nomeTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: nomeController,
      focusNode: _focusNome,
      focus: true,
      enabled: true,
      icon: Icons.person,
      hint: "Nome",
      validator: (value) {
        if (qB == 0) {
          if (value.isEmpty) {
            return 'Entre com seu nome!';
          }
          return null;
        }
      },
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      icon: Icons.email,
      hint: "Email",
      focusNode: _focusEmail,
      focus: false,
      enabled: _enabledEmail,
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com seu email!';
        } else {
          if (!emailController.text.contains('@')) {
            return 'Email inválido!';
          }
        }
        return null;
      },
    );
  }

  Widget senhaTextFormField() {
    return Material(
      borderRadius: BorderRadius.circular(20.0),
      elevation: 10,
      child: TextFormField(
        controller: senhaController,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Colors.orange[200]!,
        enabled: _enabledSenha,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Entre com a senha!';
          }
          return null;
        },
        obscureText: _senhaVisible,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.indigoAccent,
            size: 20,
          ),
          suffixIcon: InkWell(
              child: _senhaVisible
                  ? const Icon(
                      Icons.visibility,
                      color: Colors.indigoAccent,
                      size: 20,
                    )
                  : const Icon(
                      Icons.visibility_off,
                      color: Colors.indigoAccent,
                      size: 20,
                    ),
              onTap: () {
                setState(() {
                  _senhaVisible = !_senhaVisible;
                });
              }),
          labelText: 'Senha',
          hintText: 'Digite sua Senha',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Esqueceu sua senha?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          const SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              if (emailController.text.isEmpty) {
                Fluttertoast.showToast(
                    msg: 'Digite seu email!',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    fontSize: 30.0);
                setState(() {
                  _enabledEmail = true;
                });
              } else {
                resetSenha();
              }
            },
            child: Text(
              "Alterar senha",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Colors.purple[300]!),
            ),
          )
        ],
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          login(emailController.text, senhaController.text);
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.blue[200]!, Colors.cyanAccent],
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          'Entrar',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 120.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Não tem uma conta?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          const SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadatrarSenhaPage(),
                  ));
            },
            child: Text(
              "Cadastre-se",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.purple[300]!,
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
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

class CustomTextField extends StatefulWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final IconData icon;
  final FormFieldValidator? validator;
  final FocusNode? focusNode;
  final bool focus;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.hint,
    required this.textEditingController,
    required this.keyboardType,
    required this.icon,
    this.validator,
    this.focusNode,
    required this.focus,
    required this.enabled,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late double _width;

  late double _pixelRatio;

  late bool large;

  late bool medium;

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(20.0),
      elevation: 10,
      child: TextFormField(
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        cursorColor: Colors.orange[200]!,
        validator: widget.validator,
        focusNode: widget.focusNode,
        autofocus: widget.focus,
        enabled: widget.enabled,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
            color: Colors.indigoAccent,
            size: 20,
          ),
          hintText: widget.hint,
          labelText: widget.hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
