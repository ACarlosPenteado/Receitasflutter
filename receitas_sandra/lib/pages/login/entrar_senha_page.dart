import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/model/users.dart';
import 'package:receitas_sandra/pages/login/cadastrar_senha_page.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';
import 'package:receitas_sandra/widgets/dialog1_custom.dart';

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

  late FocusNode _focusNome;
  late FocusNode _focusEmail;
  late FocusNode _focusSenha;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _senhaVisible = true;
  bool _enabledNome = true;
  bool _enabledEmail = false;
  bool _enabledSenha = false;

  int qB = 0;

  String imageUrl =
      'https://www.auctus.com.br/wp-content/uploads/2017/09/sem-imagem-avatar.png';

  @override
  initState() {
    super.initState();
    _focusNome = FocusNode();
    _focusEmail = FocusNode();
    _focusSenha = FocusNode();
    Global.provedor = 'Email';
    _focusNome.addListener(() {
      //nomeController.text = 'Miguel';
      //getData(nomeController.text);
    });
  }

  getData(String nome) async {
    var doc = await FirebaseFirestore.instance
        .collection('Users')
        .where('nome', isEqualTo: nome)
        .where('provedor', isEqualTo: 'Email');
    doc.get().then((event) {
      if (event.docs.isNotEmpty) {
        Users(
          data: event.docs.elementAt(0).get('data'),
          email: event.docs.elementAt(0).get('email'),
          fone: event.docs.elementAt(0).get('fone'),
          imagem: event.docs.elementAt(0).get('imagem'),
          nome: event.docs.elementAt(0).get('nome'),
          provedor: event.docs.elementAt(0).get('provedor'),
        );
        Global.nome = event.docs.elementAt(0).get('nome');
        Global.email = event.docs.elementAt(0).get('email');
        Global.fone = event.docs.elementAt(0).get('fone');
        if (event.docs.elementAt(0).get('imagem').isNotEmpty) {
          Global.foto = event.docs.elementAt(0).get('imagem');
        } else {
          Global.foto = imageUrl;
        }
        setState(() {
          _enabledEmail = true;
          emailController.text = Global.email;
          FocusScope.of(context).requestFocus(_focusSenha);
          _enabledSenha = true;
        });
      } else {
        Global.nome = nomeController.text;
        emailController.text = '';
        senhaController.text = '';
        if (nomeController.text.isNotEmpty) {
          setState(() {
            _enabledNome = false;
            _enabledEmail = true;
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Dialog1Custom(
                    qchama: 1,
                    txtTitle: 'Nome não encontrado',
                    txtBtn1: 'Se cadastrar',
                    txtBtn2: 'Tentar com email',
                    txtBtn3: 'Sair');
              });
        }
      }
    });
  }

  getEmail(String email) async {
    var doc = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .where('provedor', isEqualTo: 'Email');
    doc.get().then((event) {
      if (event.docs.isNotEmpty) {
        Global.nome = event.docs.elementAt(0).get('nome');
        Global.email = event.docs.elementAt(0).get('email');
        if (event.docs.elementAt(0).get('imagem').isNotEmpty) {
          Global.foto = event.docs.elementAt(0).get('imagem');
        } else {
          Global.foto = imageUrl;
        }
        emailController.text = Global.email;
        setState(() {
          nomeController.text = Global.nome;
          _enabledSenha = true;
        });
      } else {
        Global.email = emailController.text;
        nomeController.text = '';
        senhaController.text = '';
        if (emailController.text.isNotEmpty) {
          setState(() {
            _enabledNome = false;
            _enabledEmail = false;
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return const Dialog1Custom(
                    qchama: 1,
                    txtTitle: 'Email não encontrado',
                    txtBtn1: 'Se cadastrar',
                    txtBtn2: 'Tentar com email',
                    txtBtn3: 'Sair');
              });
        }
      }
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
        title: const Text('Minhas Receitas'),
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
          ),
        ),
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

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 90),
      child: Row(
        children: const <Widget>[
          Center(
            child: Text(
              'Bem-vinda(o)',
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 3,
                      offset: Offset(2, 2),
                    ),
                  ]),
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
              color: Colors.indigo.shade600,
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
    return Material(
      borderRadius: BorderRadius.circular(12.0),
      elevation: 12,
      color: Colors.black26,
      child: Container(
        width: _width - 20,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: TextFormField(
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          controller: nomeController,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          cursorColor: Colors.cyan.shade400,
          validator: (value) {
            if (qB == 0) {
              if (value!.isEmpty) {
                return 'Entre com seu nome!';
              }
              return null;
            }
          },
          onFieldSubmitted: (txt) {
            setState(() {
              getData(txt);
            });
          },
          focusNode: _focusNome,
          autofocus: true,
          enabled: _enabledNome,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.person,
              color: Colors.indigoAccent,
              size: 20,
            ),
            hintText: 'Digite seu nome',
            labelText: 'Nome',
            labelStyle: TextStyle(
              color: Colors.blue.shade200,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                  color: Colors.black,
                  blurRadius: 5,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Colors.blue.shade900,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.indigoAccent,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      inputAction: TextInputAction.next,
      icon: Icons.email,
      hint: "Email",
      focusNode: _focusEmail,
      focus: false,
      enabled: _enabledEmail,
      onFieldSubmitted: (txt) {
        getEmail(txt);
      },
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
      borderRadius: BorderRadius.circular(12.0),
      elevation: 12,
      color: Colors.black26,
      child: Container(
        width: _width - 20,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: TextFormField(
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          controller: senhaController,
          keyboardType: TextInputType.visiblePassword,
          cursorColor: Colors.cyan.shade400,
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
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none),
            labelStyle: TextStyle(
              color: Colors.blue.shade200,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                  color: Colors.black,
                  blurRadius: 5,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Colors.blue.shade900,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.indigoAccent,
                width: 2.0,
              ),
            ),
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

/* class CustomAppBar extends StatefulWidget {
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
*/
class CustomTextField extends StatefulWidget {
  final String hint;
  final String? labelText;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final IconData icon;
  final TextInputAction inputAction;
  final FormFieldValidator? validator;
  final Function(String txt)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool focus;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.hint,
    this.labelText,
    required this.textEditingController,
    required this.keyboardType,
    required this.inputAction,
    required this.icon,
    this.validator,
    this.onFieldSubmitted,
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
      borderRadius: BorderRadius.circular(12.0),
      elevation: 12,
      color: Colors.black26,
      child: Container(
        width: _width - 20,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: TextFormField(
          style: const TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          key: widget.key,
          controller: widget.textEditingController,
          keyboardType: widget.keyboardType,
          cursorColor: Colors.cyan.shade400,
          validator: widget.validator,
          onFieldSubmitted: widget.onFieldSubmitted,
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
            labelText: widget.labelText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none),
            labelStyle: TextStyle(
              color: Colors.blue.shade200,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              shadows: const [
                Shadow(
                  color: Colors.black,
                  blurRadius: 5,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Colors.blue.shade900,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.indigoAccent,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
