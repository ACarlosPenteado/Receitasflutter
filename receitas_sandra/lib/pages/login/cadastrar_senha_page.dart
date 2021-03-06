import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/image_select/select_image.dart';
import 'package:receitas_sandra/pages/login/termos_page.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';

class CadatrarSenhaPage extends StatefulWidget {
  static const routeName = '/CadatrarSenhaPage';

  const CadatrarSenhaPage({Key? key}) : super(key: key);

  @override
  _CadatrarSenhaPageState createState() => _CadatrarSenhaPageState();
}

class _CadatrarSenhaPageState extends State<CadatrarSenhaPage> {
  bool checkBoxValue = false;
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

  late FocusNode _focusNome;
  late FocusNode _focusEmail;
  late FocusNode _focusFone;
  late FocusNode _focusSenha;
  late FocusNode _focusConfirma;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  Timer? timer;
  CollectionReference colRef = FirebaseFirestore.instance.collection('Users');

  bool _senhaVisible = true;
  bool _confirmaVisible = true;

  bool isLogginIn = false;

  String imageUrl = '';

  @override
  initState() {
    _focusNome = FocusNode();
    _focusEmail = FocusNode();
    _focusFone = FocusNode();
    _focusSenha = FocusNode();
    _focusConfirma = FocusNode();
    /*nomeController.text = 'Miguel';
    emailController.text = 'acarlos.penteado@gmail.com';
    foneController.text = '1199999999';
    senhaController.text = 'Ac@1234';
    confirmaController.text = 'Ac@1234';*/
    super.initState();
    nomeController.text = Global.nome;
  }

  cadastrar() async {
    Future<List<String>> providers =
        FirebaseAuth.instance.fetchSignInMethodsForEmail(emailController.text);
    providers.then((value) async {
      print('provider: $value');
      if (value.isEmpty) {
        try {
          await _auth.createUserWithEmailAndPassword(
              email: emailController.text, password: senhaController.text);
          user = _auth.currentUser!;
          print('user: $user');
          user.sendEmailVerification();
          timer = Timer.periodic(const Duration(seconds: 5), (timer) {
            isLogginIn = true;
            checkEmailVerified();
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Verifica????o"),
                  content: Text(
                      'Um mensagem foi enviada para ${emailController.text}, por favor verifique seu email!'),
                  actions: const [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              });
        } on FirebaseAuthException catch (e) {
          var mensagem = '';
          switch (e.code) {
            case "ERROR_INVALID_EMAIL":
            case 'invalid-email':
              mensagem = 'O email n??o ?? v??lido!';
              break;
            case "ERROR_EMAIL_ALREADY_IN_USE":
            case "account-exists-with-different-credential":
            case 'email-already-in-use':
              mensagem = 'Email j?? foi usado por outro usu??rio!';
              break;
            case 'requires-recent-login':
              mensagem =
                  'Tempo para entrar n??o atende aos requisitos de seguran??a!';
              break;
            default:
              mensagem = "Login falhou. Por favor tente novamente!";
              break;
          }
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Falha ao cadastrar!"),
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
      } else {
        Fluttertoast.showToast(msg: 'Email j?? cadastrado!');
      }
    });
  }

  Future<void> checkEmailVerified() async {
    user = _auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      user.updateDisplayName(nomeController.text);
      user.updatePhotoURL(imageUrl);
      var result = await colRef.doc(_auth.currentUser!.uid).set({
        'data': user.metadata.creationTime,
        'email': user.email,
        'favoritas': [],
        'fone': foneController.text,
        'imagem': user.photoURL,
        'nome': user.displayName,
        'provedor': 'Email',
      }).then((value) {
        Global.email = user.email!;
        Global.nome = user.displayName!;
        Global.foto = user.photoURL!;
        Global.provedor = 'Email';
      });
      timer!.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  dispose() {
    super.dispose();
    nomeController.dispose();
    emailController.dispose();
    foneController.dispose();
    senhaController.dispose();
    confirmaController.dispose();
    _focusNome.dispose();
    _focusEmail.dispose();
    _focusFone.dispose();
    _focusSenha.dispose();
    _focusConfirma.dispose();
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
        title: const Text('Cadastrar Usu??rio'),
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
              form(),
              aceitarTermsTextRow(),
              const SizedBox(
                height: 25,
              ),
              button(),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            height: _height / 5.5,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    spreadRadius: 0.0,
                    color: Colors.black45,
                    offset: Offset(1.0, 10.0),
                    blurRadius: 20.0),
              ],
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                imageUrl.isEmpty
                    ? Positioned(
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        bottom: 0.0,
                        child: CircleAvatar(
                          child: Icon(Icons.person,
                              size: 60, color: Theme.of(context).primaryColor),
                        ),
                      )
                    : Positioned(
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        bottom: 0.0,
                        child: ClipRRect(
                          child: Image.network(Global.foto),
                        ),
                      ),
                Positioned(
                  top: 100.0,
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: SelectImage(
                    tip: 0,
                    onFileChanged: (_imageUrl) {
                      setState(() {
                        imageUrl = _imageUrl;
                        Global.foto = _imageUrl;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
        left: _width / 12.0,
        right: _width / 12.0,
        top: _height / 15.0,
      ),
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
            foneTextFormField(),
            SizedBox(
              height: _height / 40.0,
            ),
            senhaTextFormField(),
            SizedBox(
              height: _height / 40.0,
            ),
            confirmaTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget nomeTextFormField() {
    return CustomTextField(
      textEditingController: nomeController,
      mask: MaskTextInputFormatter(mask: ''),
      inputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      focus: false,
      icon: Icons.person,
      hintText: "Digite seu Nome",
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
      focus: true,
      icon: Icons.email,
      hintText: "Digite seu email",
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
      focus: false,
      mask: MaskTextInputFormatter(
          mask: '(##)#####-####', filter: {"#": RegExp(r'[0-9]')}),
      icon: Icons.phone,
      hintText: "(99)99999-9999",
      labelText: 'Telefone',
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com seu celular!';
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
          key: widget.key,
          focusNode: _focusSenha,
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
                            setState(() {
                              senhaController.clear();
                              Navigator.of(context).pop();
                            });
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
                return 'Senha tem que ter o m??nimo de 6 d??gitos!';
              }
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

  Widget confirmaTextFormField() {
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
          focusNode: _focusConfirma,
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
          onFieldSubmitted: (txt) {
            if (txt != senhaController.text) {
              Fluttertoast.showToast(
                msg: 'Contra-Senha deve ser igual a senha!',
                fontSize: 20,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.amber,
                backgroundColor: Colors.black,
              );
            }
          },
          obscureText: _confirmaVisible,
          decoration: InputDecoration(
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
            labelText: 'Repita Senha',
            hintText: 'Confirme sua Senha',
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

  Widget aceitarTermsTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.blue[200]!,
              value: checkBoxValue,
              onChanged: (bool? newValue) {
                setState(() {
                  if (newValue != null) checkBoxValue = newValue;
                });
              }),
          Text(
            "Eu aceito todos os termos e condi????es",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const TermosPage()));
            },
            child: const Text('clique aqui'),
          ),
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
          if (checkBoxValue == true) {
            cadastrar();
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("AVISO"),
                    content: const Text('Favor aceitar os termos'),
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
          }
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

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final TextInputFormatter? mask;
  final TextInputAction inputAction;
  final bool obscureText;
  final IconData icon;
  final FocusNode? focusNode;
  final bool focus;
  final FormFieldValidator? validator;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.textEditingController,
    required this.keyboardType,
    required this.inputAction,
    required this.mask,
    required this.icon,
    this.obscureText = false,
    this.focusNode,
    required this.focus,
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
          inputFormatters: [widget.mask!],
          cursorColor: Colors.cyan[400]!,
          validator: widget.validator,
          autofocus: widget.focus,
          decoration: InputDecoration(
            prefixIcon:
                Icon(widget.icon, color: Colors.indigoAccent[200]!, size: 20),
            hintText: widget.hintText,
            labelText: widget.labelText,
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
}
