import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:receitas_sandra/pages/login/cadastrar_senha_page.dart';
import 'package:receitas_sandra/pages/login/entrar_page.dart';
import 'package:receitas_sandra/uteis/globais.dart';

class FormUsuario extends StatefulWidget {
  final TextEditingController nomeController;
  final TextEditingController emailController;
  final TextEditingController? foneController;
  final TextEditingController? senhaController;
  final TextEditingController confirmaController;

  const FormUsuario({
    Key? key,
    required this.nomeController,
    required this.emailController,
    this.foneController,
    this.senhaController,
    required this.confirmaController,
  });

  @override
  _FormUsuarioState createState() => _FormUsuarioState();
}

class _FormUsuarioState extends State<FormUsuario> {

  final FocusNode _focusNome = FocusNode();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusSenha = FocusNode();

  bool _senhaVisible = true;
  bool _enabledEmail = false;
  bool _enabledSenha = false;

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
        widget.emailController.text = Global.email;
        _enabledSenha = true;
      } else {
        Global.nome = widget.nomeController.text;
        widget.emailController.text = '';
        widget.senhaController!.text = '';
        if (widget.nomeController.text.isNotEmpty) {
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

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Center(
      child: Form(
        child: Container(
          child: Form(
            key: widget.key,
            child: Column(
              children: <Widget>[
                nomeTextFormField(),
                SizedBox(height: _height / 60.0),
                emailTextFormField(),
                SizedBox(height: _height / 60.0),
                foneTextFormField(),
                SizedBox(height: _height / 60.0),
                senhaTextFormField(),
                SizedBox(height: _height / 60.0),            
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
      textEditingController: widget.emailController,
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
        controller: widget.senhaController,
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
        key: widget.key,
        focusNode: widget.focusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        textInputAction: widget.inputAction,
        inputFormatters: [widget.mask],
        cursorColor: Colors.cyan[400]!,
        validator: widget.validator,
        enabled: widget.enabled,
        decoration: InputDecoration(
          prefixIcon:
              Icon(widget.icon, color: Colors.indigoAccent[100]!, size: 20),
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
          labelText: widget.labelText,
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
    );
  }
}
