import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/model/preparo.dart';
import 'package:receitas_sandra/model/receitas.dart';
import 'package:receitas_sandra/repository/receitas_repository.dart';
import 'package:receitas_sandra/uteis/funtions.dart';
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

  FocusNode focusQtd = FocusNode();
  FocusNode focusDropDow = FocusNode();
  FocusNode focusDesc = FocusNode();

  String selecionado = '';

  String data = getDate;
  String id = getId;

  List<Ingrediente> listIngre = [];
  List<Preparo> listPrepa = [];

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
    limparIngre();
  }

  salvarPrepa(String descricao) {
    listPrepa.add(
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
        padding: const EdgeInsets.only(top: 48),
        child: SingleChildScrollView(
          child: clipShape(),
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
        Opacity(
          opacity: 0.88,
          child: CustomAppBar(
            data: data,
            descricao: nomeController.text,
            favorita: false,
            id: id,
            iduser: auth.currentUser!.uid.toString(),
            imagem:
                'https://receitanatureba.com/wp-content/uploads/2020/04/LAYER-BASE-RECEITA-NATUREBA.jpg',
            ingredientes: listIngre,
            preparo: listPrepa,
            rendimento: rendiController.text,
            tempoPreparo: tempoController.text,
            tipo: widget.tipo,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 10
                  : (_medium ? _height / 13 : _height / 11)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                          /* image: DecorationImage(
                        image: NetworkImage(
                            'https://receitanatureba.com/wp-content/uploads/2020/04/LAYER-BASE-RECEITA-NATUREBA.jpg'),
                        fit: BoxFit.fill,
                      ), */
                        ),
                        child: pick(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 250,
                            child: nomeTextFormField(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
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
                      )
                    ],
                  )
                ],
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
              ListIngre(list: listIngre),
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
              ListPrepa(list: listPrepa),
            ],
          ),
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
      key: _formkey,
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
                width: 100,
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
                width: 290,
                height: 80,
                child: descTextFormField(),
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
                    if (_formkey.currentState!.validate()) {
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

  Widget descTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: descController,
      tm: 40,
      maxLine: 2,
      ftm: 15,
      focus: false,
      focusNode: focusDesc,
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
      key: _formkey,
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
                width: 290,
                height: 80,
                child: descTextFormField(),
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
                    if (_formkey.currentState!.validate()) {
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

class CustomAppBar extends StatefulWidget {
  String data;
  String descricao;
  bool favorita;
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
      required this.favorita,
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

  List<Ingrediente> ingres = [];
  List<Preparo> prepas = [];

  salvarReceitas(
      String data,
      String descricao,
      bool favorita,
      String id,
      String iduser,
      String imagem,
      List<Ingrediente> ingredientes,
      List<Preparo> preparo,
      String rendimento,
      String tempo,
      String tipo) {
    for (var i = 0; i < ingredientes.length; i++) {
      ingMap = Ingrediente(
          quantidade: ingredientes[i].quantidade,
          medida: ingredientes[i].medida,
          descricao: ingredientes[i].descricao);
      fireDb.collection('Receitas').doc(id).set({
        'data': data,
        'descricao': descricao,
        'favorita': favorita,
        'id': id,
        'iduser': iduser,
        'imagem': imagem,
        'ingredientes': FieldValue.arrayUnion([ingMap.toMap()]),
        'preparo': FieldValue.arrayUnion([preMap.toMap()]),
        'rendimento': rendimento,
        'tempoPreparo': tempo,
        'tipo': tipo
      }, SetOptions(merge: true));
    }

    for (var i = 0; i < preparo.length; i++) {
      preMap = Preparo(descricao: ingredientes[i].descricao);
      fireDb.collection('Receitas').doc(id).set({
        'data': data,
        'descricao': descricao,
        'favorita': favorita,
        'id': id,
        'iduser': iduser,
        'imagem': imagem,
        'ingredientes': FieldValue.arrayUnion([ingMap.toMap()]),
        'preparo': FieldValue.arrayUnion([preMap.toMap()]),
        'rendimento': rendimento,
        'tempoPreparo': tempo,
        'tipo': tipo,
      }, SetOptions(merge: true));
    }
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
                  salvarReceitas(
                      widget.data,
                      widget.descricao,
                      widget.favorita,
                      widget.id,
                      widget.iduser,
                      widget.imagem,
                      widget.ingredientes,
                      widget.preparo,
                      widget.rendimento,
                      widget.tempoPreparo,
                      widget.tipo);
                }),
          ],
        ),
      ),
    );
  }
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
