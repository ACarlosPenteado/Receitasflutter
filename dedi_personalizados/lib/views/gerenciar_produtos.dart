import 'package:dedi_personalizados/models/produtos.dart';
import 'package:dedi_personalizados/repository/produtos_repository.dart';
import 'package:dedi_personalizados/utils/funtions.dart';
import 'package:dedi_personalizados/utils/globais.dart';
import 'package:dedi_personalizados/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GerenciarProdutos extends StatefulWidget {
  final int tipo;
  const GerenciarProdutos({Key? key, required this.tipo}) : super(key: key);

  @override
  State<GerenciarProdutos> createState() => _GerenciarProdutosState();
}

class _GerenciarProdutosState extends State<GerenciarProdutos>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late double _height;
  late double _width;
  late double _pixelRatio;
  int? tip;
  TextEditingController quantidadeController = TextEditingController();
  TextEditingController produtoController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController precoController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();

  bool isLoading = false;

  FocusNode focusQua = FocusNode();
  FocusNode focusPro = FocusNode();
  FocusNode focusDes = FocusNode();
  FocusNode focusLin = FocusNode();
  FocusNode focusPre = FocusNode();

  String imageLk = 'imagens/caneca.jpg';

  ProdutosRepository produtosRepo = ProdutosRepository(auth: Global.id);

  @override
  void initState() {
    _initList();
    tip = widget.tipo;
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
    super.initState();
  }

  _initList() {
    ProdutosRepository produtosRepo = ProdutosRepository(auth: Global.id);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 233, 30, 216),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        title: const Text(
          'Dedi Personalizados',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(
                Icons.shopping_basket,
                color: Colors.white,
              ),
              onPressed: () {}),
        ],
      ),
      body: Container(
        height: _height,
        width: _width,
        padding: const EdgeInsets.only(top: 13, bottom: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 236, 157, 230),
              Colors.white,
            ],
          ),
        ),
        child: OrientationBuilder(
          builder: (context, orientation) => orientation == Orientation.portrait
              ? buildPortrait()
              : buildLandscape(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildPortrait() => SingleChildScrollView(
        child: Column(
          children: [
            tip == 0
                ? animeLetter('C', 'Incluir dados')
                : animeLetter('C', 'Alterar dados'),
            containerForm(),
          ],
        ),
      );

  Widget buildLandscape() => SingleChildScrollView(
        child: Column(
          children: [
            tip == 0
                ? animeLetter('C', 'Incluir dados')
                : animeLetter('C', 'Alterar dados'),
          ],
        ),
      );

  Widget animeLetter(String deonde, String text) => AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                colors: const [Colors.grey, Colors.black38, Colors.grey],
                stops: [
                  controller.value - 0.3,
                  controller.value,
                  controller.value + 0.3
                ],
              ).createShader(
                Rect.fromLTWH(0, 0, rect.width, rect.height),
              );
            },
            child: Column(
              children: [
                if (deonde == 'C')
                  tip == 0
                      ? Text(
                          text,
                          style: const TextStyle(
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                color: Colors.purpleAccent,
                                blurRadius: 5,
                                offset: Offset(1, 1),
                              ),
                            ],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          text,
                          style: const TextStyle(
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                color: Colors.purpleAccent,
                                blurRadius: 5,
                                offset: Offset(1, 1),
                              ),
                            ],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                if (deonde == 'B')
                  text == 'Cancelar'
                      ? Text(
                          text,
                          style: const TextStyle(
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                color: Colors.purpleAccent,
                                blurRadius: 5,
                                offset: Offset(1, 1),
                              ),
                            ],
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          text,
                          style: const TextStyle(
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                color: Colors.purpleAccent,
                                blurRadius: 5,
                                offset: Offset(1, 1),
                              ),
                            ],
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ],
            ),
            blendMode: BlendMode.srcIn,
          );
        },
      );

  Widget containerForm() => Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.black,
          child: AnimatedContainer(
            duration: const Duration(seconds: 5),
            height: 340,
            decoration: const BoxDecoration(
              //borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF213B6C),
                    Color(0xFF0059A5),
                  ]),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 5,
                  offset: Offset(3, 3),
                ),
              ],
            ),
            child: Form(
              key: _formkey,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 300,
                    child: quantidadeTextFormField(),
                  ),
                  Positioned(
                    top: 10,
                    left: 90,
                    right: 100,
                    child: produtoTextFormField(),
                  ),
                  Positioned(
                    top: 10,
                    left: 290,
                    right: 10,
                    child: precoTextFormField(),
                  ),
                  Positioned(
                    top: 80,
                    left: 10,
                    right: 10,
                    child: descricaoTextFormField(),
                  ),
                  Positioned(
                    top: 150,
                    left: 15,
                    right: 240,
                    bottom: 75,
                    child: imageLink(),
                  ),
                  Positioned(
                    top: 150,
                    left: 160,
                    right: 10,
                    bottom: 75,
                    child: linkImageTextFormField(),
                  ),
                  Positioned(
                    top: 300,
                    left: 10,
                    right: 10,
                    child: buttons1(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget quantidadeTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: quantidadeController,
      textInputAction: TextInputAction.next,
      focus: false,
      focusNode: focusQua,
      tm: 60,
      ftm: 12,
      maxLine: 1,
      labelText: 'Quantidade',
      validator: (value) {
        if (value.isEmpty || value == null) {
          return 'Digite a quantidade do produto!';
        }
        return null;
      },
    );
  }

  Widget produtoTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: produtoController,
      textInputAction: TextInputAction.next,
      focus: false,
      focusNode: focusPro,
      tm: 60,
      ftm: 12,
      maxLine: 1,
      labelText: 'Produto',
      validator: (value) {
        if (value.isEmpty || value == null) {
          return 'Digite o produto!';
        }
        return null;
      },
    );
  }

  Widget descricaoTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: descricaoController,
      textInputAction: TextInputAction.next,
      focus: false,
      focusNode: focusDes,
      tm: 60,
      ftm: 12,
      maxLine: 1,
      labelText: 'Descrição',
      validator: (value) {
        if (value.isEmpty || value == null) {
          return 'Digite a descrição do produto!';
        }
        return null;
      },
    );
  }

  Widget precoTextFormField() {
    return CustomTextField(
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      textEditingController: precoController,
      textInputAction: TextInputAction.next,
      focus: false,
      focusNode: focusPre,
      tm: 60,
      ftm: 12,
      maxLine: 1,
      labelText: 'Preço',
      validator: (value) {
        if (value.isEmpty || value == null) {
          return 'Digite o preço do produto!';
        }
        return null;
      },
    );
  }

  Widget imageLink() {
    return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        width: 140,
        height: 55,
        child: Stack(
          children: [
            linkController.text.isEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imageLk,
                      fit: BoxFit.fill,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageLk,
                      fit: BoxFit.fill,
                    ),
                  ),
          ],
        ));
  }

  Widget linkImageTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: linkController,
      textInputAction: TextInputAction.done,
      focus: false,
      focusNode: focusLin,
      tm: 500,
      ftm: 12,
      maxLine: 5,
      labelText: 'Link da Imagem',
      validator: (value) {
        if (value.isEmpty || value == null) {
          return 'Cole o link da imagem do produto!';
        }
        return null;
      },
      onSubmited: (value) {
        setState(() {
          imageLk = linkController.text;
        });
      },
    );
  }

  Widget buttons1() {
    return Container(
      width: 100,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          !isLoading
              ? Stack(
                  children: [
                    Container(
                      width: 120,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            spreadRadius: 1,
                            offset: Offset(1, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: animeLetter('B', 'Cancelar'),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Container(
                      width: 120,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            spreadRadius: 1,
                            offset: Offset(1, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: animeLetter('B', 'OK'),
                        ),
                        onPressed: () {
                          setState(() {
                            if (_formkey.currentState!.validate()) {
                              salvarDados();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }

  salvarDados() {
    Produtos produtos = Produtos(
        id: getId,
        quantidade: quantidadeController.text,
        produto: produtoController.text,
        descricao: descricaoController.text,
        linkImagem: linkController.text,
        preco: precoController.text);
    setState(() {
      isLoading = true;
    });
    produtosRepo.addProdutos(produtos);
    setState(() {
      isLoading = false;
    });
    imageLk = 'imagens/caneca.jpg';
    quantidadeController.text = '';
    produtoController.text = '';
    descricaoController.text = '';
    linkController.text = '';
    precoController.text = '';
  }
}
