import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/image_select/select_image.dart';
import 'package:receitas_sandra/uteis/funtions.dart';
import 'package:receitas_sandra/uteis/globais.dart';

class DataUserPage extends StatefulWidget {
  const DataUserPage({Key? key}) : super(key: key);

  @override
  _DataUserPageState createState() => _DataUserPageState();
}

class _DataUserPageState extends State<DataUserPage> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController foneController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmaController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();
  final GlobalKey<FormFieldState> _nomekey = GlobalKey<FormFieldState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  CollectionReference colRef = FirebaseFirestore.instance.collection('Users');

  bool _senhaVisible = true;
  bool _confirmaVisible = true;

  String imageUrl = '';

  bool isLogginIn = false;

  @override
  void initState() {
    nomeController.text = Global.nome;
    emailController.text = Global.email;
    foneController.text = Global.fone;
    imageUrl = Global.foto;
    super.initState();
  }

  cadastrar() {
    setState(() {
      isLogginIn = true;
    });

    if (Global.email != emailController.text) {
      Future<List<String>> providers = FirebaseAuth.instance
          .fetchSignInMethodsForEmail(emailController.text);
      providers.then((value) {
        if (value.isEmpty) {
          try {
            _auth.currentUser!.updateEmail(emailController.text).then((__) {
              user = _auth.currentUser!;
              user.sendEmailVerification();
              timer = Timer.periodic(const Duration(seconds: 5), (timer) {
                checkEmailVerified();
                if (user.emailVerified) {
                  colRef.doc(_auth.currentUser!.uid).set({
                    'data': getDate,
                    'email': emailController.text,
                    'fone': foneController.text,
                    'imagem': imageUrl,
                    'nome': nomeController.text,
                    'provedor': 'Email',
                  }).then((value) {
                    Global.email = emailController.text;
                    Global.nome = nomeController.text;
                    Global.foto = imageUrl;
                  });
                }
              });
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
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            });
          } on FirebaseAuthException catch (e) {
            var mensagem = '';
            switch (e.code) {
              case 'invalid-email':
                mensagem = 'O email não é válido!';
                break;
              case 'email-already-in-use':
                mensagem = 'Email já for usado por outro usuário!';
                break;
              case 'requires-recent-login':
                mensagem =
                    'Tempo para entrar não atende aos requisitos de segurança!';
                break;
              case 'weak-password':
                mensagem = 'A senha não for forte o suficiente.';
                break;
              default:
            }
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Falha ao alterar dados!"),
                    content: Text(mensagem),
                    actions: [
                      TextButton(
                        child: const Text("Ok"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          } finally {
            setState(() {
              isLogginIn = false;
            });
          }
        }
      });
    } else {
      colRef.doc(_auth.currentUser!.uid).set({
        'data': getDate,
        'email': emailController.text,
        'fone': foneController.text,
        'imagem': imageUrl,
        'nome': nomeController.text,
        'provedor': 'Email',
      }).then((__) {
        setState(() {
          Global.email = emailController.text;
          Global.nome = nomeController.text;
          Global.foto = imageUrl;
        });
      });
    }
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()));
  }

  Future<void> checkEmailVerified() async {
    user = _auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  alteraSenha() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 10,
            title: const Center(
              child: Text(
                "Alteração de Senha",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            content: Container(
              margin: EdgeInsets.only(
                  left: _width / 12.0,
                  right: _width / 12.0,
                  top: _height / 20.0),
              width: 400,
              height: 200,
              decoration: BoxDecoration(
                //color: Colors.black45,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: senhaTextFormField(),
                  ),
                  SizedBox(height: _height / 50.0),
                  Expanded(
                    child: confirmaTextFormField(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  "Cancela",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  "Ok",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void alterei() async {
    user = _auth.currentUser!;
    user.updatePassword(senhaController.text).then((__) {
      Fluttertoast.showToast(msg: 'Senha alterada');
    }).catchError((onError) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Falha ao alterar dados!"),
              content: Text(onError.toString()),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  @override
  dispose() {
    super.dispose();
    nomeController.dispose();
    emailController.dispose();
    foneController.dispose();
    senhaController.dispose();
    confirmaController.dispose();
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
        padding: const EdgeInsets.only(top: 48, bottom: 20),
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
          builder: (context, orientation) => orientation == Orientation.portrait
              ? buildPortrait()
              : buildLandscape(),
        ),
      ),
    );
  }

  Widget buildPortrait() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            clipShape(),
            form(),
            const SizedBox(
              height: 25,
            ),
            forgetPassTextRow(),
            const SizedBox(height: 25),
            button(),
          ],
        ),
      );

  Widget buildLandscape() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            clipShape(),
            form(),
            const SizedBox(
              height: 25,
            ),
            forgetPassTextRow(),
            const SizedBox(
              height: 25,
            ),
            button(),
          ],
        ),
      );

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        key: _formkey,
        child: Column(
          children: <Widget>[
            nomeTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            foneTextFormField(),
            SizedBox(height: _height / 60.0),
            /* senhaTextFormField(),
            SizedBox(height: _height / 60.0),
            confirmaTextFormField(), */
          ],
        ),
      ),
    );
  }

  Widget nomeTextFormField() {
    return CustomTextField(
      key: _nomekey,
      textEditingController: nomeController,
      mask: MaskTextInputFormatter(mask: ''),
      inputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "Nome",
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com seu nome!';
        }
        return null;
      },
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      inputAction: TextInputAction.next,
      mask: MaskTextInputFormatter(mask: ''),
      icon: Icons.email,
      hint: "Email",
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com seu email!';
        }
        return null;
      },
    );
  }

  Widget foneTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: foneController,
      inputAction: TextInputAction.next,
      mask: MaskTextInputFormatter(
          mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')}),
      icon: Icons.phone,
      hint: "(99) 99999-9999",
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com seu celular!';
        }
        return null;
      },
    );
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Quer alterar sua senha?",
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
              } else {
                alteraSenha();
              }
            },
            child: Text(
              "Click aqui",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Colors.purple[300]!),
            ),
          )
        ],
      ),
    );
  }

  Widget senhaTextFormField() {
    return TextFormField(
      controller: senhaController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (txt) {
        bool passValid = RegExp(
                "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?:{}|<>]).*")
            .hasMatch(txt);
        if (!passValid) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Center(
                    child: Text(
                      'Senha muito fraca!',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  content: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.cyan.shade100,
                    ),
                    padding: const EdgeInsets.all(15),
                    width: 200,
                    height: 100,
                    child: Text(
                      Global.senhaMessage,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        "OK",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        }
      },
      cursorColor: Colors.cyan[400]!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Entre com a senha';
        } else {
          if (value.length < 6) {
            return 'Senha tem que ter o mínimo de 6 dígitos!';
          }
        }
        return null;
      },
      obscureText: _senhaVisible,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 4.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
        hintStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget confirmaTextFormField() {
    return TextFormField(
      controller: confirmaController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      cursorColor: Colors.cyan[400]!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Confirme a senha';
        } else {
          if (value != senhaController.text) {
            return 'Deve ser igual a senha!';
          } else {}
        }
        return null;
      },
      obscureText: _confirmaVisible,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 4.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(
          Icons.lock,
          color: Colors.indigoAccent,
          size: 20,
        ),
        suffixIcon: InkWell(
            child: _confirmaVisible
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
                _confirmaVisible = !_confirmaVisible;
              });
            }),
        labelText: 'Redigite Senha',
        hintText: 'Confirme sua Senha',
        hintStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
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
          cadastrar();
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
          'Cadastrar',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
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
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Container(
              height: _height / 5.5,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                /* boxShadow: [
                  BoxShadow(
                      spreadRadius: 0.0,
                      color: Colors.black45,
                      offset: Offset(1.0, 10.0),
                      blurRadius: 20.0),
                ], */
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SelectImage(
                    onFileChanged: (_imageUrl) {
                      setState(() {
                        imageUrl = _imageUrl;
                        Global.foto = imageUrl;
                      });
                    },
                  ),
                ],
              )),
        ),
      ],
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
  final TextInputFormatter mask;
  final TextInputAction inputAction;
  final bool obscureText;
  final IconData icon;
  final FocusNode? focusNode;
  final FormFieldValidator? validator;

  const CustomTextField({
    Key? key,
    required this.hint,
    required this.textEditingController,
    required this.keyboardType,
    required this.inputAction,
    required this.mask,
    required this.icon,
    this.obscureText = false,
    this.focusNode,
    this.validator,
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
      borderRadius: BorderRadius.circular(30.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
        key: widget.key,
        focusNode: widget.focusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        textInputAction: widget.inputAction,
        inputFormatters: [widget.mask],
        cursorColor: Colors.cyan[400]!,
        validator: widget.validator,
        decoration: InputDecoration(
          prefixIcon:
              Icon(widget.icon, color: Colors.indigoAccent[200]!, size: 20),
          hintText: widget.hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
