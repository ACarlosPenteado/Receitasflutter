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
import 'package:pinput/pin_put/pin_put.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class EntrarFonePage extends StatefulWidget {
  const EntrarFonePage({Key? key}) : super(key: key);

  @override
  _EntrarFonePageState createState() => _EntrarFonePageState();
}

class _EntrarFonePageState extends State<EntrarFonePage> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  late double _height;
  late double _width;

  final GlobalKey<FormState> _formkey = GlobalKey();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController foneController = TextEditingController();
  final TextEditingController _pinPutController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLogginIn = false;

  late Timer timer;
  CollectionReference colRef = FirebaseFirestore.instance.collection('Users');

  String verificationId = '';

  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.cyanAccent,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(
        color: Colors.black,
        blurRadius: 25,
        blurStyle: BlurStyle.outer,
        spreadRadius: 0,
        offset: Offset(0, 0),
      ),
    ],
    border: Border.all(
      color: Colors.indigoAccent,
    ),
  );

  bool showLoading = false;

  String imageUrl = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            showLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                    ? Flexible(
                        child: getMobileFormWidget(context),
                      )
                    : Flexible(
                        child: getOtpFormWidget(context),
                      ),
            const Padding(
              padding: EdgeInsets.all(16),
            ),
          ],
        ),
      ),
    );
  }

  /* void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      Fluttertoast.showToast(msg: e.message.toString());
    }
  } */

  getMobileFormWidget(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60),
      child: Container(
        width: _width - 20,
        height: 750,
        padding: const EdgeInsets.only(
          top: 40,
          left: 10,
          right: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              fit: FlexFit.loose,
              child: clipShape(),
            ),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: ElevatedButton(
                child: const Text(
                  "ENVIAR",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    showLoading = true;
                  });
                  await _auth.verifyPhoneNumber(
                    phoneNumber: '+55' + foneController.text,
                    verificationCompleted: (phoneAuthCredential) async {
                      setState(() {
                        showLoading = false;
                      });
                      //signInWithPhoneAuthCredential(phoneAuthCredential);
                    },
                    verificationFailed: (verificationFailed) async {
                      setState(() {
                        showLoading = false;
                      });
                      _scaffoldKey.currentState!.showSnackBar(SnackBar(
                          content:
                              Text(verificationFailed.message.toString())));
                    },
                    codeSent: (verificationId, resendingToken) async {
                      setState(() {
                        showLoading = false;
                        currentState =
                            MobileVerificationState.SHOW_OTP_FORM_STATE;
                        this.verificationId = verificationId;
                      });
                    },
                    codeAutoRetrievalTimeout: (verificationId) async {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget clipShape() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          imageUrl.isEmpty
              ? Container(
                  width: 120,
                  height: 120,
                  child: const CircleAvatar(
                    child: Icon(Icons.person, size: 60, color: Colors.amber),
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
          SelectImage(
            tip: 0,
            onFileChanged: (_imageUrl) {
              setState(() {
                imageUrl = _imageUrl;
                Global.foto = _imageUrl;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
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
        ],
      ),
    );
  }

  getOtpFormWidget(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60),
      child: Container(
        width: _width - 20,
        height: 750,
        padding: const EdgeInsets.only(
          top: 40,
          left: 10,
          right: 10,
        ),
        child: Column(
          children: [
            const Text(
              'Verifique o telefone: ',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 26,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(2, 2),
                    blurRadius: 3,
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              foneController.text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.cyanAccent,
                    offset: Offset(2, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Entre com o código enviado",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
              child: PinPut(
                fieldsCount: 6,
                textStyle: TextStyle(
                  fontSize: 35.0,
                  color: Colors.blueAccent.shade700,
                  fontWeight: FontWeight.bold,
                ),
                eachFieldWidth: 40.0,
                eachFieldHeight: 55.0,
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: pinPutDecoration,
                selectedFieldDecoration: pinPutDecoration,
                followingFieldDecoration: pinPutDecoration,
                pinAnimationType: PinAnimationType.fade,
                onSubmit: (pin) async {
                  try {
                    await _auth
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: pin))
                        .then((value) async {
                      if (value.user != null) {
                        print(value.user!.uid);
                        Global.provedor = 'Fone';
                        cadastrar(value.user!.uid);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                            (route) => false);
                      }
                    });
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    Fluttertoast.showToast(msg: 'Código Inválido');
                  }
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  cadastrar(String user) {
    if (Global.provedor == 'Fone') {
      try {
        colRef.doc(user).set({
          'email': emailController.text,
          'fone': foneController.text,
          'imagem': imageUrl,
          'nome': nomeController.text,
          'provedor': Global.provedor,
        }).then((value) {
          setState(() {
            Global.email = emailController.text;
            Global.nome = nomeController.text;
            Global.foto = imageUrl;
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
      }
    } /* else {
      colRef.doc(_auth.currentUser!.uid).update({
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
    } */
  }

  Widget nomeTextFormField() {
    return CustomTextField(
      textEditingController: nomeController,
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
      textEditingController: emailController,
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
      textEditingController: foneController,
      inputAction: TextInputAction.next,
      mask: MaskTextInputFormatter(
          mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')}),
      icon: Icons.phone,
      hint: '(99)9999-9999',
      labelText: 'Telefone',
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com seu celular!';
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
}
