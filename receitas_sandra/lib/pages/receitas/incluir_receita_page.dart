import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/model/preparo.dart';
import 'package:receitas_sandra/image_select/select_image.dart';
import 'package:receitas_sandra/pages/receitas/listar_receita_page.dart';
import 'package:receitas_sandra/pages/receitas/mostrar_receitas_page.dart';
import 'package:receitas_sandra/uteis/funtions.dart';
import 'package:receitas_sandra/uteis/globais.dart';
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

  String imageUrl = '';

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
                setState(() {});
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
        /* if (Global.qual == 'I')
          Opacity(
            opacity: 0.88,
            child: CustomAppBar(
              data: data,
              descricao: nomeController.text,
              id: id,
              iduser: auth.currentUser!.uid,
              imagem: imageUrl,
              ingredientes: listIngre,
              preparo: listPrepa,
              rendimento: rendiController.text,
              tempoPreparo: tempoController.text,
              tipo: widget.tipo!,
            ),
          )
        else
          Opacity(
            opacity: 0.88,
            child: CustomAppBar(
              data: data,
              descricao: nomeController.text,
              id: id,
              iduser: auth.currentUser!.uid,
              imagem: imageUrl,
              ingredientes: Global.ingredientes,
              preparo: Global.preparo,
              rendimento: rendiController.text,
              tempoPreparo: tempoController.text,
              tipo: widget.tipo!,
            ),
          ),
         */
        Container(
          width: _width,
          height: 200,
          //padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          color: Colors.white,
          child: Stack(
            clipBehavior: Clip.antiAlias,
            children: [
              if (imageUrl.isNotEmpty)
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
              Material(
                borderRadius: BorderRadius.circular(20.0),
                elevation: 10,
                child: SizedBox(
                  width: 180,
                  height: 40,
                  child: medidasDropDown(),
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
                      salvarIngre(quanController.text, selecionado,
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
}

class CustomAppBar extends StatefulWidget {
  String data;
  String descricao;
  String id;
  String iduser;
  String imagem;
  List<Ingrediente> ingredientes;
  List<Preparo> preparo;
  String rendimento;
  String tempoPreparo;
  String tipo;

  CustomAppBar(
      {Key? key,
      required this.data,
      required this.descricao,
      required this.id,
      required this.iduser,
      required this.imagem,
      required this.ingredientes,
      required this.preparo,
      required this.rendimento,
      required this.tempoPreparo,
      required this.tipo})
      : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  FirebaseFirestore fireDb = FirebaseFirestore.instance;

  late Ingrediente ingMap;
  late Preparo preMap;

  salvarReceitas(
      String data,
      String descricao,
      String id,
      String iduser,
      String imagem,
      List<Ingrediente> ingredientes,
      List<Preparo> preparo,
      String rendimento,
      String tempo,
      String tipo) {
    // ignore: prefer_is_empty
    if (ingredientes.length < 0) {
      for (var i = 0; i < ingredientes.length; i++) {
        ingMap = Ingrediente(
            quantidade: ingredientes[i].quantidade,
            medida: ingredientes[i].medida,
            descricao: ingredientes[i].descricao);
      }
    } else {
      ingMap = Ingrediente(quantidade: '', medida: '', descricao: '');
    }
    // ignore: prefer_is_empty
    if (preparo.length < 0) {
      for (var i = 0; i < preparo.length; i++) {
        preMap = Preparo(descricao: preparo[i].descricao);
      }
    } else {
      preMap = Preparo(descricao: '');
    }

    fireDb.collection('Receitas').doc(id).set({
      'data': data,
      'descricao': descricao,
      'id': id,
      'iduser': iduser,
      'imagem': imagem,
      'ingredientes': FieldValue.arrayUnion([ingMap]),
      'preparo': FieldValue.arrayUnion([preMap]),
      'rendimento': rendimento,
      'tempoPreparo': tempo,
      'tipo': tipo
    }, SetOptions(merge: true)).then((_) {
      Global.descricao = descricao;
      Global.imagem = imagem;
      Global.ingredientes = ingredientes;
      Global.preparo = preparo;
      Global.tempoPreparo = tempo;
      Global.rendimento = rendimento;
      Fluttertoast.showToast(msg: 'Receita Salva');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ListarReceitaPage(tipo: widget.tipo),
        ),
      );
    });
  }

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
            IconButton(
                iconSize: 30,
                icon: const Icon(
                  Icons.save,
                ),
                onPressed: () {
                  setState(() {
                    salvarReceitas(
                        widget.data,
                        widget.descricao,
                        widget.id,
                        widget.iduser,
                        widget.imagem,
                        widget.ingredientes,
                        widget.preparo,
                        widget.rendimento,
                        widget.tempoPreparo,
                        widget.tipo);
                  });
                }),
          ],
        ),
      ),
    );
  }
}
