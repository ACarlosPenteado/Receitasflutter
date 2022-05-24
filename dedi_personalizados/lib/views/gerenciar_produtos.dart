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

  @override
  void initState() {
    tip = widget.tipo;
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
    super.initState();
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
            animeLetter(),
            containerForm(),
          ],
        ),
      );

  Widget buildLandscape() => SingleChildScrollView(
        child: Column(
          children: [
            animeLetter(),
          ],
        ),
      );

  Widget animeLetter() => AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                colors: const [Colors.grey, Colors.white, Colors.grey],
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
                tip == 0
                    ? const Text(
                        'Incluir dados',
                        style: TextStyle(
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
                    : const Text(
                        'Alterar dados',
                        style: TextStyle(
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
            height: 150,
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
              child: Stack(
                children: const [
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: TextField(
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Categoria',
                        labelStyle: TextStyle(
                          color: Colors.cyanAccent,
                        ),
                        alignLabelWithHint: false,
                        filled: true,
                      ),
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
