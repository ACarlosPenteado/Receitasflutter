import 'package:carousel_slider/carousel_slider.dart';
import 'package:dedi_personalizados/models/produtos.dart';
import 'package:dedi_personalizados/repository/produtos_repository.dart';
import 'package:dedi_personalizados/utils/globais.dart';
import 'package:dedi_personalizados/views/gerenciar_produtos.dart';
import 'package:dedi_personalizados/widgets/listview_home.dart';
import 'package:dedi_personalizados/widgets/procura_produtos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime time = DateTime.now();
  late double _height;
  late double _width;
  late double _pixelRatio;
  final List _listaProdutos = [];

  late final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 99,
    keepScrollOffset: true,
  );

  final urlImagens = [
    'imagens/FB_IMG_1.jpg',
    'imagens/FB_IMG_2.jpg',
    'imagens/FB_IMG_3.jpg',
    'imagens/FB_IMG_4.jpg',
    'imagens/FB_IMG_5.jpg',
  ];

  @override
  void initState() {
    _initList();
    super.initState();
  }

  _initList() {
    ProdutosRepository produtosRepo = ProdutosRepository(auth: widget.uid);
    produtosRepo.listProdutos().listen((e) {
      if (e.docs.isNotEmpty) {
        for (var i = 0; i < e.docs.length; i++) {
          _listaProdutos.add(Produtos(
            id: e.docs.elementAt(i).get('id'),
            quantidade: e.docs.elementAt(i).get('quantidade'),
            descricao: e.docs.elementAt(i).get('descricao'),
            linkImagem: e.docs.elementAt(i).get('linkImagem'),
          ));
          print(_listaProdutos);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return WillPopScope(
      onWillPop: () async {
        final diff = DateTime.now().difference(time);
        final isExit = diff >= const Duration(seconds: 2);
        time = DateTime.now();
        if (isExit) {
          Fluttertoast.showToast(
            msg: 'Pressione novamente para sair',
            fontSize: 18,
            textColor: Colors.amber,
            backgroundColor: Colors.grey.shade700,
          );
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 233, 30, 216),
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          title: Text(
            Global.title,
            style: const TextStyle(
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
          bottom: PreferredSize(
              preferredSize: const Size(300, 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Procura_Produtos(),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const GerenciarProdutos(tipo: 0),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              )),
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
            builder: (context, orientation) =>
                orientation == Orientation.portrait
                    ? buildPortrait()
                    : buildLandscape(),
          ),
        ),
      ),
    );
  }

  Widget buildPortrait() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 1,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
              ),
              //child: const Flexible(
              child: const ListView_Home(),
              //),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 2,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
              ),
              //child: Expanded(
              child: gridView(),
              //),
            ),
          ),
        ],
      );

  Widget buildLandscape() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: gridView(),
            ),
          ),
        ],
      );

  Widget gridView() {
    return GridView.builder(
      controller: _scrollController,
      itemCount: _listaProdutos.length,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        mainAxisSpacing: 0,
      ),
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(_listaProdutos[index]),
          background: Container(
            margin: const EdgeInsets.only(left: 10, top: 5, bottom: 30),
            alignment: Alignment.centerLeft,
            color: Colors.black,
            child: Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  Text(
                    'Exclui produto',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          secondaryBackground: Container(
            margin: const EdgeInsets.only(left: 10, top: 5, bottom: 30),
            alignment: Alignment.centerRight,
            color: Colors.black,
            child: Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  Text(
                    'Exclui produto',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              alignment: Alignment.centerRight,
            ),
          ),
          direction: DismissDirection.endToStart,
          resizeDuration: const Duration(milliseconds: 200),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  top: 0.0,
                  left: 20.0,
                  right: 20.0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    child: /* Image.network(
                      _listaProdutos[index].linkImagem,
                      height: 120,
                      fit: BoxFit.fill,
                    ), */
                        Text(
                      _listaProdutos[index].quantidade,
                      style: const TextStyle(
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            color: Colors.purpleAccent,
                            blurRadius: 5,
                            offset: Offset(1, 1),
                          ),
                        ],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 35,
                  right: 35,
                  child: Text(
                    _listaProdutos[index].descricao,
                    style: const TextStyle(
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          color: Colors.purpleAccent,
                          blurRadius: 5,
                          offset: Offset(1, 1),
                        ),
                      ],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          /* onDismissed: ((direction) async {
            await produtosRepo
                .excluiProduto(listaProdutos![index].id.toString());
          }), */
        );
      },
    );
  }
}
