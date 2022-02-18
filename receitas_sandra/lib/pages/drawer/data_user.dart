import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/image_select/select_image.dart';
import 'package:receitas_sandra/uteis/funtions.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';

class DataUserPage extends StatefulWidget {
  static const routeName = '/DataUserPage';
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
  final GlobalKey<FormState> _nomekey = GlobalKey();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer timer;
  CollectionReference colRef = FirebaseFirestore.instance.collection('Users');

  String imageUrl = '';

  bool isLogginIn = false;
  bool isChange = true;

  bool _senhaVisible = true;
  bool _confirmaVisible = true;
  bool _enabledNome = true;
  bool _enabledEmail = true;
  bool _enabledSenha = true;
  bool _enabledFone = true;

  @override
  void initState() {
    nomeController.text = Global.nome;
    emailController.text = Global.email;
    foneController.text = Global.fone;
    imageUrl = Global.foto;
    if (Global.provedor == 'Google' || Global.provedor == 'Facebook') {
      _enabledNome = false;
      _enabledEmail = false;
      isChange = false;
    } else if (Global.provedor == 'Fone') {
      _enabledFone = false;
      isChange = false;
    }
    super.initState();
  }

  cadastrar() {
    setState(() {
      isLogginIn = true;
    });
    User user = _auth.currentUser!;
    if (Global.provedor == 'Email') {
      if (Global.email != emailController.text) {
        Future<List<String>> providers = FirebaseAuth.instance
            .fetchSignInMethodsForEmail(emailController.text);
        providers.then((value) {
          print(value);
          if (value.isEmpty) {
            try {
              user.updateEmail(emailController.text).then((__) {
                user.sendEmailVerification();
                timer = Timer.periodic(const Duration(seconds: 5), (timer) {
                  checkEmailVerified();
                  if (user.emailVerified) {
                    colRef.doc(_auth.currentUser!.uid).update({
                      'data': getDate,
                      'email': emailController.text,
                      'fone': foneController.text,
                      'imagem': imageUrl,
                      'nome': nomeController.text,
                    }).then((value) {
                      setState(() {
                        Global.email = emailController.text;
                        Global.nome = nomeController.text;
                        Global.foto = imageUrl;
                      });
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
                        actions: const [
                          Center(
                            child: CircularProgressIndicator(),
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
        colRef.doc(_auth.currentUser!.uid).update({
          'data': getDate,
          'email': emailController.text,
          'fone': foneController.text,
          'imagem': imageUrl,
          'nome': nomeController.text,
        }).then((__) {
          setState(() {
            Global.email = emailController.text;
            Global.nome = nomeController.text;
            Global.foto = imageUrl;
          });
        });
      }
    } else if (Global.provedor == 'Facebook' || Global.provedor == 'Google') {
      try {
        colRef.doc(_auth.currentUser!.uid).update({
          'fone': foneController.text,
        });
        Global.fone = foneController.text;
      } finally {
        setState(() {
          isLogginIn = false;
        });
      }
    } else if (Global.provedor == 'Fone') {
      try {
        colRef.doc(_auth.currentUser!.uid).update({
          'data': getDate,
          'email': emailController.text,
          'imagem': imageUrl,
          'nome': nomeController.text,
        });
        Global.fone = foneController.text;
      } finally {
        setState(() {
          isLogginIn = false;
        });
      }
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  Future<void> checkEmailVerified() async {
    User user = _auth.currentUser!;
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
    User user = _auth.currentUser!;
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
        child: Container(
          width: _width - 20,
          height: 750,
          padding: const EdgeInsets.only(
            top: 50,
            left: 10,
            right: 10,
          ),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /* Flexible(
                flex: 2,
                fit: FlexFit.loose,
                child:  */
              clipShape(),
              //),
              /* Flexible(
                flex: 2,
                fit: FlexFit.loose,
                child:  */
              form(),
              //),
              const SizedBox(
                height: 25,
              ),
              if (isChange)
                SizedBox(
                  child: forgetPassTextRow(),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  button1(),
                  const SizedBox(
                    width: 30,
                  ),
                  button(),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildLandscape() => SingleChildScrollView(
        child: Container(
          width: _width - 20,
          height: 750,
          padding: const EdgeInsets.only(
            top: 50,
            left: 10,
            right: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              /* Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child:  */
              clipShape(),
              //),
              /* Flexible(
                flex: 3,
                fit: FlexFit.loose,
                child:  */
              form(),
              //),
              const SizedBox(
                height: 25,
              ),
              forgetPassTextRow(),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  button1(),
                  const SizedBox(
                    width: 30,
                  ),
                  button(),
                ],
              ),
            ],
          ),
        ),
      );

  Widget clipShape() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          imageUrl.isEmpty
              ? Container(
                  width: 120,
                  height: 120,
                  child: const CircleAvatar(
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.amber,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 25,
                        blurStyle: BlurStyle.outer,
                        spreadRadius: 0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      Global.foto,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 25,
                        blurStyle: BlurStyle.outer,
                        spreadRadius: 0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
          if (isChange)
            SelectImage(
              tip: 0,
              onFileChanged: (_imageUrl) {
                setState(() {
                  imageUrl = _imageUrl;
                  Global.foto = _imageUrl;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget form() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: _width,
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              nomeTextFormField(),
              const SizedBox(height: 10),
              emailTextFormField(),
              const SizedBox(height: 10),
              foneTextFormField(),
              if (isLogginIn)
                SizedBox(
                  child: senhaTextFormField(),
                ),
              if (isLogginIn)
                SizedBox(
                  child: confirmaTextFormField(),
                ),
            ],
          ),
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
      enabled: _enabledNome,
      hint: "Digite seu Nome",
      labelText: 'Nome',
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
      enabled: _enabledEmail,
      hint: "Digite seu Email",
      labelText: 'Email',
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
      hint: '(99)9999-9999',
      labelText: 'Telefone',
      enabled: _enabledFone,
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
      padding: const EdgeInsets.only(top: 10),
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
                      borderRadius: BorderRadius.circular(10),
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

  Widget button1() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      onPressed: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()));
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
          'Cancelar',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String hint;
  final String? labelText;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final TextInputFormatter mask;
  final TextInputAction inputAction;
  final bool obscureText;
  final bool enabled;
  final IconData icon;
  final FocusNode? focusNode;
  final FormFieldValidator? validator;

  const CustomTextField({
    Key? key,
    required this.hint,
    this.labelText,
    required this.textEditingController,
    required this.keyboardType,
    required this.inputAction,
    required this.mask,
    required this.icon,
    this.obscureText = false,
    this.enabled = true,
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
          focusNode: widget.focusNode,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.textEditingController,
          keyboardType: widget.keyboardType,
          textInputAction: widget.inputAction,
          inputFormatters: [widget.mask],
          cursorColor: Colors.cyan.shade400,
          validator: widget.validator,
          enabled: widget.enabled,
          decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              color: Colors.indigoAccent.shade100,
              size: 20,
            ),
            labelText: widget.labelText,
            hintText: widget.hint,
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
