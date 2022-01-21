import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/image_select/select_image.dart';
import 'package:receitas_sandra/pages/drawer/data_user.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/form_usuario.dart';

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
  final TextEditingController nomeControle = TextEditingController();
  final TextEditingController emailControle = TextEditingController();
  final TextEditingController foneControle = TextEditingController();
  final TextEditingController otpControle = TextEditingController();
  final TextEditingController confirmaControle = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId = '';

  bool showLoading = false;
  bool _enabledFone = false;

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
        )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            showLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                    ? getMobileFormWidget(context)   
                    : getOtpFormWidget(context),
          ],
        ),
      ),
    );
  }

  void signInWithPhoneAuthCredential(
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
  }

  getMobileFormWidget(context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 70,
        left: 10,
        right: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          clipShape(),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
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
                phoneNumber: foneControle.text,
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
                      content: Text(verificationFailed.message.toString())));
                },
                codeSent: (verificationId, resendingToken) async {
                  setState(() {
                    showLoading = false;
                    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId = verificationId;
                  });
                },
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget clipShape() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          imageUrl.isEmpty
              ? CircleAvatar(
                  child: Icon(Icons.person,
                      size: 60, color: Theme.of(context).primaryColor),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    Global.foto,
                    width: 100,
                    height: 100,
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
          FormUsuario(
            nomeController: nomeControle,
            emailController: emailControle,
            foneController: foneControle,
            confirmaController: confirmaControle,
          ),
        ],
      ),
    );
  }

  /* Widget form() {
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
          ],
        ),
      ),
    );
  }

  Widget nomeTextFormField() {
    return CustomTextField(
      textEditingController: nomeControle,
      mask: MaskTextInputFormatter(mask: ''),
      inputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      icon: Icons.person,
      enabled: true,
      hint: "Nome",
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com seu nome!';
        } else {
          _enabledFone = true;
        }
        return null;
      },
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailControle,
      inputAction: TextInputAction.next,
      mask: MaskTextInputFormatter(mask: ''),
      icon: Icons.email,
      hint: "Email",
      enabled: true,
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
      textEditingController: foneControle,
      inputAction: TextInputAction.next,
      mask: MaskTextInputFormatter(
          mask: '+55 (##) #####-####', filter: {"#": RegExp(r'[0-9]')}),
      icon: Icons.phone,
      hint: "(99) 99999-9999",
      enabled: _enabledFone,
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com seu celular!';
        }
        return null;
      },
    );
  }*/

  getOtpFormWidget(context) {
    return Column(
      children: [
        const Spacer(),
        TextField(
          controller: otpControle,
          decoration: const InputDecoration(
            hintText: "Enter OTP",
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: otpControle.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: const Text(
            "VERIFIQUE",
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
        ),
        const Spacer(),
      ],
    );
  }
}
