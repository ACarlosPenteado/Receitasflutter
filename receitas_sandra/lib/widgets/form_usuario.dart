import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/pages/drawer/data_user.dart';
import 'package:receitas_sandra/pages/login/cadastrar_senha_page.dart';
import 'package:receitas_sandra/pages/login/entrar_page.dart';
import 'package:receitas_sandra/uteis/globais.dart';

class FormUsuario extends StatefulWidget {
  final String qChama;
  final GlobalKey<FormState> formkey;
  final TextEditingController nomeController;
  final TextEditingController emailController;
  final TextEditingController? foneController;
  final TextEditingController? senhaController;
  final TextEditingController confirmaController;
  final String? imageUrl;

  const FormUsuario({
    Key? key,
    required this.formkey,
    required this.qChama,
    required this.nomeController,
    required this.emailController,
    this.foneController,
    this.senhaController,
    required this.confirmaController,
    this.imageUrl,
  });

  @override
  _FormUsuarioState createState() => _FormUsuarioState();
}

class _FormUsuarioState extends State<FormUsuario> {
  final FocusNode _focusNome = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusFone = FocusNode();
  final FocusNode _focusSenha = FocusNode();

  bool _senhaVisible = true;
  bool _confirmaVisible = true;
  bool _enabledEmail = false;
  bool _enabledSenha = false;
  bool _enabledFone = false;
  bool isLogginIn = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer timer;
  CollectionReference colRef = FirebaseFirestore.instance.collection('Users');

  late double _height;
  late double _width;

  String imageUrl =
      'https://www.auctus.com.br/wp-content/uploads/2017/09/sem-imagem-avatar.png';

  @override
  initState() {
    super.initState();
    _focusNome.addListener(() {
      //nomeController.text = 'Miguel';
      //getData(widget.nomeController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Center(
      child: Form(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: _width,
          child: Form(
            key: widget.key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                nomeTextFormField(),
                const SizedBox(
                  height: 10,
                ),
                emailTextFormField(),
                const SizedBox(
                  height: 10,
                ),
                foneTextFormField(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nomeTextFormField() {
    return CustomTextField(
      textEditingController: widget.nomeController,
      mask: MaskTextInputFormatter(mask: ''),
      inputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      icon: Icons.person,
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
      textEditingController: widget.emailController,
      inputAction: TextInputAction.next,
      mask: MaskTextInputFormatter(mask: ''),
      icon: Icons.email,
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
      textEditingController: widget.foneController!,
      inputAction: TextInputAction.next,
      mask: MaskTextInputFormatter(
          mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')}),
      icon: Icons.phone,
      hint: '(99) 9999-9999',
      labelText: 'Telefone',
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com seu celular!';
        } else {
          Global.fone = widget.foneController!.text;
        }
        return null;
      },
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
/* 
  getData(String nome) async {
    var doc = await FirebaseFirestore.instance
        .collection('Users')
        .where('nome', isEqualTo: nome);
    doc.get().then((event) {
      if (event.docs.isNotEmpty) {
        Global.nome = event.docs.elementAt(0).get('nome');
        Global.email = event.docs.elementAt(0).get('email');
        Global.fone = event.docs.elementAt(0).get('fone');
        if (event.docs.elementAt(0).get('imagem').isNotEmpty) {
          Global.foto = event.docs.elementAt(0).get('imagem');
        } else {
          Global.foto = imageUrl;
        }
        emailController.text = Global.email;
        _enabledSenha = true;
      } else {
        Global.nome = nomeController.text;
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
                blurRadius: 5,
                offset: Offset(1, 1),
              ),
            ],
          ),
          controller: senhaController,
          focusNode: _focusSenha,
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
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.indigoAccent.shade100,
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
          const Text(
            "Quer alterar sua senha?",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
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
                //alteraSenha();
              }
            },
            child: Text(
              "Click aqui",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.purple.shade300,
              ),
            ),
          )
        ],
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
        elevation: 10,
      ),
      onPressed: () {
        if (_formkey.currentState!.validate()) {
          //cadastrar;
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.blue[200]!, Colors.cyanAccent],
          ),
        ),
        child: const Text(
          'Cadastrar',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget button1() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      onPressed: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()));
      },
      child: Container(
        alignment: Alignment.center,
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.blue[200]!, Colors.cyanAccent],
          ),
        ),
        child: const Text(
          'Cancelar',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
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
*/
}
