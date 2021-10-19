import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
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

  TextEditingController nomeController = TextEditingController();
  TextEditingController tempoController = TextEditingController();
  TextEditingController rendiController = TextEditingController();

  TextEditingController quanController = TextEditingController();
  TextEditingController mediController = TextEditingController();
  TextEditingController descController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey();

  showMaterialDialog({required BuildContext context, required Widget child}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  List<Ingrediente> listIngre = [];

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
                        child: const SizedBox(
                          width: 180,
                          height: 40,
                          child: DropdownSearchable(),
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
                        width: 280,
                        height: 40,
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
                          salvarIngre();
                        },
                      ),
                      ElevatedButton(
                        child: const Text("Cancela"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  salvarIngre() {}

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

  Widget nomeTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: nomeController,
      focus: true,
      ftm: 12,
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
      ftm: 12,
      focus: false,
    );
  }

  Widget rendiTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: rendiController,
      hint: "Rendimento",
      ftm: 12,
      focus: false,
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
        const Opacity(opacity: 0.88, child: CustomAppBar()),
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
              InkWell(
                onTap: () {
                  cadastraIngre();
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
            ],
          ),
        ),
      ],
    );
  }

  Widget quanTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: quanController,
      tm: 3,
      ftm: 15,
      focus: true,
      hint: 'QTD',
    );
  }

  Widget descTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: descController,
      tm: 40,
      ftm: 15,
      focus: false,
      hint: 'Descrição',
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
            IconButton(
                iconSize: 30,
                icon: const Icon(
                  Icons.save,
                ),
                onPressed: () {}),
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
