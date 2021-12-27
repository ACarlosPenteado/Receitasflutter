import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/model/preparo.dart';
import 'package:receitas_sandra/image_select/select_image.dart';
import 'package:receitas_sandra/pages/receitas/listar_receita_page.dart';
import 'package:receitas_sandra/pages/receitas/mostrar_receitas_page.dart';
import 'package:receitas_sandra/repository/users_repository.dart';
import 'package:receitas_sandra/uteis/funtions.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/autocomplete.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';
import 'package:receitas_sandra/widgets/listingre.dart';
import 'package:receitas_sandra/widgets/listprepa.dart';
import 'package:receitas_sandra/widgets/search.dart';
import 'package:receitas_sandra/widgets/text_field.dart';

class IncluirReceitaPage extends StatefulWidget {
  static const routeName = '/IncluirReceitaPage';
  final String tipo;
  const IncluirReceitaPage({Key? key, required this.tipo}) : super(key: key);

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
      nomeController.text = Global.descricao;
      tempoController.text = Global.tempoPreparo;
      rendiController.text = Global.rendimento;
      imageUrl = Global.imagem;
      id = Global.id;
    } else {
      id = getId;
      Global.ingredientes = [];
      Global.preparo = [];
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
            color: Colors.grey[100],
            width: 320,
            child: Padding(
              padding: const EdgeInsets.all(12),
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
            color: Colors.grey[100],
            width: 320,
            child: Padding(
              padding: const EdgeInsets.all(12),
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
    Global.ingredientes.add(
      Ingrediente(quantidade: quantidade, medida: medida, descricao: descricao),
    );
    limparIngre();
  }

  salvarPrepa(String descricao) {
    listPrepa.add(
      Preparo(descricao: descricao),
    );
    Global.preparo.add(
      Preparo(descricao: descricao),
    );
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              clipShape(),
            ],
          ),
        ),
      ),
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
    );
  }

  Widget tipoRec(String qtipo) {
    return Text(
      qtipo + ' Receita',
      style: const TextStyle(
        fontSize: 25,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        color: Color(0xFF01579B),
      ),
    );
  }

  Widget clipShape() {
    return Column(
      children: <Widget>[
        Container(
          width: _width,
          height: 200,
          //padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          color: Colors.white,
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
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                Positioned(
                  left: 0.0,
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
                  top: 5.0,
                  left: 120.0,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 250,
                        child: nomeTextFormField(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 60,
                    left: 120,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 115,
                              child: tempoTextFormField(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 115,
                              child: rendiTextFormField(),
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 5,
          color: Colors.purple,
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            if (nomeController.text.isNotEmpty) {
              cadastraIngre();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1, color: Colors.purple),
            ),
            child: const Text(
              'Ingredientes',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (Global.qual == 'I')
          ListIngre(
            list: listIngre,
            fontSize: 15,
            qq: 'i',
          )
        else
          ListIngre(
            list: Global.ingredientes,
            fontSize: 15,
            qq: 'i',
          ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          height: 5,
          color: Colors.purple,
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            if (nomeController.text.isNotEmpty) {
              cadastraPrepa();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1, color: Colors.purple),
            ),
            child: const Text(
              'Modo de Preparo',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (Global.qual == 'I')
          ListPrepa(
            list: listPrepa,
            fontSize: 15,
          )
        else
          ListPrepa(
            list: Global.preparo,
            fontSize: 15,
          ),
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
          const Text('Cadastrar Ingredientes'),
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
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  elevation: 10,
                  child: const SizedBox(
                    width: 160,
                    height: 40,
                    child: AutoCompleteText(text: ''),
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
                child: const Text("Salva"),
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
                child: const Text("Cancela"),
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

  Widget medidasDropDown() {
    return DropdownSearchable(
      focusNode: focusDropDow,
      validator: (value) {
        if (value.isEmpty) {
          selecionado = '-';
        } else {
          selecionado = value;
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
          const Text('Cadastrar Modo de Preparo'),
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
    print(Global.ingredientes);
    print(Global.preparo);
    if (Global.ingredientes.isNotEmpty) {
      for (var i = 0; i < Global.ingredientes.length; i++) {
        ingMap.add({
          'quantidade': Global.ingredientes.elementAt(i).quantidade,
          'medida': Global.ingredientes.elementAt(i).medida,
          'descricao': Global.ingredientes.elementAt(i).descricao,
        });
      }
    }
    if (Global.preparo.isNotEmpty) {
      for (var i = 0; i < Global.preparo.length; i++) {
        preMap.add({
          'descricao': Global.preparo.elementAt(i).descricao,
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
          builder: (context) => ListarReceitaPage(tipo: widget.tipo),
        ),
      );
    });
  }
}
