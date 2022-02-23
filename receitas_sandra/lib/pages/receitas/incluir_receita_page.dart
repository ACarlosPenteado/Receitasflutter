import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/model/preparo.dart';
import 'package:receitas_sandra/image_select/select_image.dart';
import 'package:receitas_sandra/model/receitas.dart';
import 'package:receitas_sandra/uteis/funtions.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/autocomplete.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';
import 'package:receitas_sandra/widgets/listingre.dart';
import 'package:receitas_sandra/widgets/listprepa.dart';
import 'package:receitas_sandra/widgets/text_field.dart';

class IncluirReceitaPage extends StatefulWidget {
  static const routeName = '/IncluirReceitaPage';
  final String tipo;
  final Receitas? receita;

  const IncluirReceitaPage({Key? key, required this.tipo, this.receita})
      : super(key: key);

  @override
  _IncluirReceitaPageState createState() => _IncluirReceitaPageState();
}

class _IncluirReceitaPageState extends State<IncluirReceitaPage> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController nomeController = TextEditingController();
  TextEditingController tempoController = TextEditingController();
  TextEditingController rendiController = TextEditingController();

  TextEditingController quanController = TextEditingController();
  TextEditingController mediController = TextEditingController();
  TextEditingController descController = TextEditingController();

  TextEditingController prepaController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey();
  final GlobalKey<FormState> _formkeyI = GlobalKey();
  final GlobalKey<FormState> _formkeyP = GlobalKey();

  FocusNode focusQtd = FocusNode();
  FocusNode focusDropDow = FocusNode();
  FocusNode focusDescI = FocusNode();
  FocusNode focusDescP = FocusNode();

  String selecionado = '';

  String data = getDate;
  String id = '';

  List<Ingrediente> listIngre = [];
  List<Preparo> listPrepa = [];

  String imageUrl = 'Sem Imagem';

  @override
  void initState() {
    if (Global.qual == 'E') {
      nomeController.text = widget.receita!.descricao;
      tempoController.text = widget.receita!.tempoPreparo;
      rendiController.text = widget.receita!.rendimento;
      imageUrl = widget.receita!.imagem;
      listIngre = widget.receita!.ingredientes!;
      listPrepa = widget.receita!.preparo!;
      id = Global.id;
    } else {
      id = getId;
      Global.ingredientes = [];
      Global.preparo = [];
      Global.tamListI = 0;
      Global.tamListP = 0;
    }
    super.initState();
  }

  cadastraIngre() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 320,
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF259cda), Color(0xFF6bbce6)]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.cyan,
                  blurRadius: 12,
                  offset: Offset(3, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: formIngre(),
            ),
          ),
        );
      },
    );
  }

  cadastraPrepa() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 320,
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF259cda), Color(0xFF6bbce6)]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.cyan,
                  blurRadius: 12,
                  offset: Offset(3, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: formPrepa(),
            ),
          ),
        );
      },
    );
  }

  salvarIngre(String quantidade, String medida, String descricao) {
    listIngre.add(
      Ingrediente(quantidade: quantidade, medida: medida, descricao: descricao),
    );
    Global.tamListI = listIngre.length;
    limparIngre();
  }

  salvarPrepa(String descricao) {
    listPrepa.add(
      Preparo(descricao: descricao),
    );
    Global.tamListP = listPrepa.length;
    limparPrepa();
  }

  limparIngre() {
    quanController.text = '';
    selecionado = '';
    descController.text = '';
  }

  limparPrepa() {
    prepaController.text = '';
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (Global.qual == 'I') tipoRec('Incluir') else tipoRec('Alterar'),
          ],
        ),
        actions: [
          IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.save,
              ),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  salvarReceitas();
                }
              }),
        ],
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
          child: OrientationBuilder(
            builder: ((context, orientation) =>
                orientation == Orientation.portrait
                    ? buildPortrait()
                    : buildLandscape()),
          )),
    );
  }

  Widget buildPortrait() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            clipShape(),
          ],
        ),
      );

  Widget buildLandscape() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            clipShape1(),
          ],
        ),
      );

  Widget tipoRec(String qtipo) {
    return Text(
      qtipo + ' Receita',
      style: const TextStyle(
          fontSize: 25,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          color: Colors.lightBlueAccent,
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 5.0,
              offset: Offset(1, 1),
            ),
          ]),
    );
  }

  Widget clipShape() {
    return Column(
      children: <Widget>[
        Container(
          width: _width,
          height: _height - 600,
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF213B6C), Color(0xFF0059A5)]),
            boxShadow: const [
              BoxShadow(
                color: Colors.cyan,
                blurRadius: 12,
                offset: Offset(3, 5),
              ),
            ],
          ),
          child: Form(
            key: _formkey,
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                if (imageUrl != 'Sem Imagem')
                  Positioned.fill(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                Positioned(
                  left: 20,
                  bottom: 5.0,
                  child: SelectImage(
                    tip: 1,
                    onFileChanged: (_imageUrl) {
                      setState(() {
                        imageUrl = _imageUrl;
                      });
                    },
                  ),
                ),
                Positioned(
                  top: 15.0,
                  left: _width / 20,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: _width - 80,
                        child: nomeTextFormField(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 80.0,
                  left: _width / 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 115,
                            child: tempoTextFormField(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 80.0,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 115,
                            child: rendiTextFormField(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          height: 5,
          color: Colors.purple,
        ),
        const SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () {
            if (nomeController.text.isNotEmpty) {
              cadastraIngre();
            } else {
              Fluttertoast.showToast(
                msg: 'Inclua o nome da receita',
                gravity: ToastGravity.CENTER,
                textColor: Colors.yellow,
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.purple),
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade700,
                    Colors.black26,
                  ]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.deepOrange,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Ingredientes',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (Global.tamListI > 0)
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            height: Global.tamListI.toDouble() * 25,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade100,
                    Colors.black45,
                  ]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.cyan,
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: ListIngre(
              list: listIngre,
              fontSize: 15,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 10,
          color: Colors.purple,
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            if (nomeController.text.isNotEmpty) {
              cadastraPrepa();
            } else {
              Fluttertoast.showToast(
                msg: 'Inclua o nome da receita',
                gravity: ToastGravity.CENTER,
                textColor: Colors.yellow,
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.purple),
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade700,
                    Colors.black26,
                  ]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.deepOrange,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Modo de Preparo',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (Global.tamListP > 0)
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            height: Global.tamListP.toDouble() * 25,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade100,
                    Colors.black45,
                  ]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.cyan,
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: ListPrepa(
              list: listPrepa,
              fontSize: 15,
            ),
          )
      ],
    );
  }

  Widget clipShape1() {
    return Column(
      children: <Widget>[
        Container(
          width: 400,
          height: 180,
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF213B6C), Color(0xFF0059A5)]),
            boxShadow: const [
              BoxShadow(
                color: Colors.cyan,
                blurRadius: 12,
                offset: Offset(3, 5),
              ),
            ],
          ),
          child: Form(
            key: _formkey,
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: [
                if (imageUrl != 'Sem Imagem')
                  Positioned.fill(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                Positioned(
                  left: 20,
                  bottom: 5.0,
                  child: SelectImage(
                    tip: 1,
                    onFileChanged: (_imageUrl) {
                      setState(() {
                        imageUrl = _imageUrl;
                      });
                    },
                  ),
                ),
                Positioned(
                  top: 15.0,
                  left: _width / 20,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        width: _width - 80,
                        child: nomeTextFormField(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 80.0,
                  left: _width / 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 115,
                            child: tempoTextFormField(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 80.0,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 115,
                            child: rendiTextFormField(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          height: 5,
          color: Colors.purple,
        ),
        const SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () {
            if (nomeController.text.isNotEmpty) {
              cadastraIngre();
            } else {
              Fluttertoast.showToast(
                msg: 'Inclua o nome da receita',
                gravity: ToastGravity.CENTER,
                textColor: Colors.yellow,
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.purple),
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade700,
                    Colors.black26,
                  ]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.deepOrange,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Ingredientes',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (Global.tamListI > 0)
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            height: Global.tamListI.toDouble() * 25,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade100,
                    Colors.black45,
                  ]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.cyan,
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: ListIngre(
              list: listIngre,
              fontSize: 15,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 10,
          color: Colors.purple,
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            if (nomeController.text.isNotEmpty) {
              cadastraPrepa();
            } else {
              Fluttertoast.showToast(
                msg: 'Inclua o nome da receita',
                gravity: ToastGravity.CENTER,
                textColor: Colors.yellow,
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.purple),
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade700,
                    Colors.black26,
                  ]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.add,
                  color: Colors.deepOrange,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Modo de Preparo',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (Global.tamListP > 0)
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            height: Global.tamListP.toDouble() * 25,
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey.shade100,
                    Colors.black45,
                  ]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.cyan,
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: ListPrepa(
              list: listPrepa,
              fontSize: 15,
            ),
          )
      ],
    );
  }

  Widget nomeTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: nomeController,
      focus: true,
      tm: 60,
      ftm: 12,
      maxLine: 1,
      hint: "Nome da receita",
      validator: (value) {
        if (value.isEmpty) {
          return 'Digite o nome da receita!';
        }
        return null;
      },
    );
  }

  Widget tempoTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: tempoController,
      hint: "Tempo de Preparo",
      sufix: 'minutos',
      maxLine: 1,
      tm: 3,
      ftm: 12,
      focus: false,
    );
  }

  Widget rendiTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: rendiController,
      hint: "Rendimento",
      sufix: 'porções',
      maxLine: 1,
      tm: 3,
      ftm: 12,
      focus: false,
    );
  }

  Widget formIngre() {
    return Form(
      key: _formkeyI,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Cadastrar Ingredientes',
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
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 85,
                height: 40,
                child: quanTextFormField(),
              ),
              const SizedBox(
                width: 35,
              ),
              Material(
                borderRadius: BorderRadius.circular(12.0),
                shadowColor: Colors.black26,
                elevation: 12,
                color: Colors.black26,
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  width: 160,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.shade900,
                      width: 2.0,
                    ),
                  ),
                  child: const AutoCompleteText(
                    text: 'gramas',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 285,
                height: 80,
                child: descITextFormField(),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: const Text(
                  "Salva",
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
                onPressed: () {
                  setState(() {
                    if (_formkeyI.currentState!.validate()) {
                      salvarIngre(quanController.text, Global.ing_med,
                          descController.text);
                      limparIngre();
                    }
                  });
                },
              ),
              ElevatedButton(
                child: const Text(
                  "Cancela",
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
                onPressed: () {
                  limparIngre();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget quanTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: quanController,
      tm: 3,
      ftm: 15,
      maxLine: 1,
      hint: 'QTD',
      focus: true,
      focusNode: focusQtd,
      onChange: (value) {
        if (value.length == 3) {
          FocusScope.of(context).requestFocus(focusDropDow);
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com a quantidade';
        }
        return null;
      },
    );
  }

  Widget descITextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: descController,
      tm: 40,
      maxLine: 2,
      ftm: 15,
      focus: false,
      focusNode: focusDescI,
      hint: 'Descrição',
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com a descrição';
        }
        return null;
      },
    );
  }

  Widget formPrepa() {
    return Form(
      key: _formkeyP,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Cadastrar Modo de Preparo',
            style: TextStyle(
              color: Colors.white54,
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
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 285,
                height: 80,
                child: descPTextFormField(),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: const Text("Salva"),
                onPressed: () {
                  setState(() {
                    if (_formkeyP.currentState!.validate()) {
                      salvarPrepa(prepaController.text);
                      limparPrepa();
                    }
                  });
                },
              ),
              ElevatedButton(
                child: const Text("Cancela"),
                onPressed: () {
                  limparPrepa();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget descPTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: prepaController,
      tm: 40,
      maxLine: 2,
      ftm: 15,
      focus: false,
      focusNode: focusDescP,
      hint: 'Descrição',
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com a descrição';
        }
        return null;
      },
    );
  }

  Widget pick() {
    return Positioned(
      left: 8,
      top: 8,
      child: InkWell(
        onTap: () {},
        child: const Icon(
          Icons.add_a_photo,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  FirebaseFirestore fireDb = FirebaseFirestore.instance;

  List ingMap = [];
  List preMap = [];

  salvarReceitas() {
    if (listIngre.isNotEmpty) {
      for (var i = 0; i < listIngre.length; i++) {
        ingMap.add({
          'quantidade': listIngre.elementAt(i).quantidade,
          'medida': listIngre.elementAt(i).medida,
          'descricao': listIngre.elementAt(i).descricao,
        });
      }
    }
    if (listPrepa.isNotEmpty) {
      for (var i = 0; i < listPrepa.length; i++) {
        preMap.add({
          'descricao': listPrepa.elementAt(i).descricao,
        });
      }
    }
    if (Global.qual == 'I') {
      fireDb.collection('Receitas').doc(id).set({
        'ativo': true,
        'data': getDate,
        'descricao': nomeController.text,
        'id': id,
        'iduser': auth.currentUser!.uid,
        'imagem': imageUrl,
        'ingredientes': ingMap,
        'preparo': preMap,
        'rendimento': rendiController.text,
        'tempoPreparo': tempoController.text,
        'tipo': widget.tipo,
      }, SetOptions(merge: true)).then((_) {});

      Fluttertoast.showToast(msg: 'Receita Salva');
    } else {
      fireDb.collection('Receitas').doc(id).update({
        'ativo': true,
        'descricao': nomeController.text,
        'imagem': imageUrl,
        'ingredientes': ingMap,
        'preparo': preMap,
        'rendimento': rendiController.text,
        'tempoPreparo': tempoController.text,
      });
      Fluttertoast.showToast(msg: 'Receita Alterada');
    }
    setState(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  }
}
