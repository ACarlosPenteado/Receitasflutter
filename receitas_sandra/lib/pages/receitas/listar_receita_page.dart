import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/model/preparo.dart';
import 'package:receitas_sandra/model/receitas.dart';
import 'package:receitas_sandra/pages/receitas/favoritas_page.dart';
import 'package:receitas_sandra/pages/receitas/incluir_receita_page.dart';
import 'package:receitas_sandra/pages/receitas/mostrar_receitas_page.dart';
import 'package:receitas_sandra/pages/receitas/search_page.dart';
import 'package:receitas_sandra/repository/users_repository.dart';
import 'package:receitas_sandra/repository/receitas_repository.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';
import 'package:receitas_sandra/widgets/dialog_custom.dart';
import 'package:receitas_sandra/widgets/position_custom.dart';

class ListarReceitaPage extends StatefulWidget {
  static const routeName = '/ListarReceitaPage';
  final String tipo;

  const ListarReceitaPage({Key? key, required this.tipo}) : super(key: key);

  @override
  _ListarReceitaPageState createState() => _ListarReceitaPageState();
}

class _ListarReceitaPageState extends State<ListarReceitaPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double size = 150;

  final FirebaseFirestore fireDb = FirebaseFirestore.instance;
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final TextEditingController _nomeController = TextEditingController();

  List _listareceitas = [];
  List _receitas = [];
  List _favoritas = [];
  List _selecionadas = [];
  List _minhasreceitas = [];
  List<Ingrediente> _listIngre = [];
  List<Preparo> _listPrepa = [];
  bool fav = false;
  int currentItem = 0;
  String qual = 'Todas';
  int quale = 0;
  bool pesquisa = false;
  String? _grouSelectValue;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _grouSelectValue = 'Nome';
    fabKey.currentState?.close();
    listaReceitas();
    loadFavoritas();
    super.initState();
  }

  _groupChange(String? value) {
    setState(() {
      _grouSelectValue = value;
    });
  }

  preencheListIngre(List<dynamic> list) async {
    _listIngre = [];
    Global.ingredientes = [];
    for (var i = 0; i < list.length; i++) {
      _listIngre.add(
        Ingrediente(
            quantidade: list.elementAt(i)['quantidade'],
            medida: list.elementAt(i)['medida'],
            descricao: list.elementAt(i)['descricao']),
      );
    }
    Global.ingredientes = _listIngre;
    Global.tamListI += list.length;
  }

  preencheListPrepa(List<dynamic> list) async {
    _listPrepa = [];
    Global.preparo = [];
    for (var i = 0; i < list.length; i++) {
      _listPrepa.add(
        Preparo(descricao: list.elementAt(i)['descricao']),
      );
    }
    Global.preparo = _listPrepa;
    Global.tamListP += list.length;
  }

  listaReceitas() {
    ReceitasRepository recRepo =
        ReceitasRepository(auth: _auth.currentUser!.uid);
    recRepo.listReceita(widget.tipo).then((List list) {
      setState(() {
        _listareceitas = list;
        _receitas = _listareceitas;
      });
    }).whenComplete(() => _listareceitas);
  }

  todasReceitas() {
    _receitas = _listareceitas;
  }

  minhasReceitas() {
    _minhasreceitas = [];
    for (var i = 0; i < _listareceitas.length; i++) {
      if (_listareceitas[i]['iduser'] == _auth.currentUser!.uid) {
        preencheListIngre(_listareceitas[i]['ingredientes']);
        preencheListPrepa(_listareceitas[i]['preparo']);
        _minhasreceitas.add(Receitas(
            id: _listareceitas[i]['id'],
            data: _listareceitas[i]['data'],
            descricao: _listareceitas[i]['descricao'],
            iduser: _listareceitas[i]['iduser'],
            imagem: _listareceitas[i]['imagem'],
            ingredientes: Global.ingredientes,
            preparo: Global.preparo,
            rendimento: _listareceitas[i]['rendimento'],
            tempoPreparo: _listareceitas[i]['tempoPreparo'],
            tipo: _listareceitas[i]['tipo']));
      }
    }
  }

  loadFavoritas() {
    final userRepo = UsersRepository(auth: _auth.currentUser!.uid);
    userRepo
        .listFavoritas(_auth.currentUser!.uid)
        .then((value) => _favoritas = value);
  }

  selecionar(int index) {
    final userRepo = UsersRepository(auth: _auth.currentUser!.uid);
    if (!fav) {
      if (quale == 0) {
        if (!_selecionadas.contains(_receitas[index]['id'])) {
          _selecionadas.add(_receitas[index]['id']);
        }
        if (!_favoritas.contains(_receitas[index]['id'])) {
          userRepo.favoritar(_auth, _receitas[index]['id']);
          _favoritas.add(_receitas[index]['id']);
        }
      } else {
        if (!_selecionadas.contains(_minhasreceitas[index].id)) {
          _selecionadas.add(_minhasreceitas[index].id);
        }
        if (!_favoritas.contains(_minhasreceitas[index].id)) {
          userRepo.favoritar(_auth, _minhasreceitas[index].id);
          _favoritas.add(_minhasreceitas[index].id);
        }
      }
    } else {
      if (quale == 0) {
        if (_selecionadas.contains(_receitas[index]['id'])) {
          _selecionadas.remove(_receitas[index]['id']);
        }
        if (_favoritas.contains(_receitas[index]['id'])) {
          userRepo.desfavoritar(_auth, _receitas[index]['id']);
          _favoritas.remove(_receitas[index]['id']);
        }
      } else {
        if (_selecionadas.contains(_minhasreceitas[index].id)) {
          _selecionadas.remove(_minhasreceitas[index].id);
        }
        if (_favoritas.contains(_minhasreceitas[index].id)) {
          userRepo.desfavoritar(_auth, _minhasreceitas[index].id);
          _favoritas.remove(_minhasreceitas[index].id);
        }
      }
    }
  }

  searchRec(String gr, String pq) {
    _minhasreceitas = [];
    for (var i = 0; i < _listareceitas.length; i++) {
      if (_listareceitas[i]['iduser'] == _auth.currentUser!.uid) {
        switch (gr) {
          case 'Nome':
            if (_listareceitas[i]['descricao'] == pq) {
              preencheListIngre(_listareceitas[i]['ingredientes']);
              preencheListPrepa(_listareceitas[i]['preparo']);
              _minhasreceitas.add(Receitas(
                  id: _listareceitas[i]['id'],
                  data: _listareceitas[i]['data'],
                  descricao: _listareceitas[i]['descricao'],
                  iduser: _listareceitas[i]['iduser'],
                  imagem: _listareceitas[i]['imagem'],
                  ingredientes: Global.ingredientes,
                  preparo: Global.preparo,
                  rendimento: _listareceitas[i]['rendimento'],
                  tempoPreparo: _listareceitas[i]['tempoPreparo'],
                  tipo: _listareceitas[i]['tipo']));
            }
            break;
          case 'Ingrediente':
            // ignore: iterable_contains_unrelated_type
            if (Global.ingredientes[i].descricao!.contains(pq)) {
              preencheListIngre(_listareceitas[i]['ingredientes']);
              preencheListPrepa(_listareceitas[i]['preparo']);
              _minhasreceitas.add(Receitas(
                  id: _listareceitas[i]['id'],
                  data: _listareceitas[i]['data'],
                  descricao: _listareceitas[i]['descricao'],
                  iduser: _listareceitas[i]['iduser'],
                  imagem: _listareceitas[i]['imagem'],
                  ingredientes: Global.ingredientes,
                  preparo: Global.preparo,
                  rendimento: _listareceitas[i]['rendimento'],
                  tempoPreparo: _listareceitas[i]['tempoPreparo'],
                  tipo: _listareceitas[i]['tipo']));
            }
            break;
          case 'Preparo':
            // ignore: iterable_contains_unrelated_type
            if (Global.preparo[i].descricao!.contains(pq)) {
              preencheListIngre(_listareceitas[i]['ingredientes']);
              preencheListPrepa(_listareceitas[i]['preparo']);
              _minhasreceitas.add(Receitas(
                  id: _listareceitas[i]['id'],
                  data: _listareceitas[i]['data'],
                  descricao: _listareceitas[i]['descricao'],
                  iduser: _listareceitas[i]['iduser'],
                  imagem: _listareceitas[i]['imagem'],
                  ingredientes: Global.ingredientes,
                  preparo: Global.preparo,
                  rendimento: _listareceitas[i]['rendimento'],
                  tempoPreparo: _listareceitas[i]['tempoPreparo'],
                  tipo: _listareceitas[i]['tipo']));
            }
        }
      }
    }
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
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    final primaryColor = Theme.of(context).primaryColor;

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
        padding: const EdgeInsets.only(top: 48),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              clipShape(),
            ],
          ),
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FabCircularMenu(
          key: fabKey,
          alignment: Alignment.bottomRight,
          ringColor: Colors.blue.withAlpha(25),
          ringDiameter: 350.0,
          ringWidth: 100.0,
          fabSize: 64.0,
          fabElevation: 8.0,
          fabIconBorder: const CircleBorder(),
          fabOpenColor: Colors.blue[100],
          fabCloseColor: Colors.blue[300],
          fabColor: Colors.orange,
          fabOpenIcon: const Icon(Icons.menu, color: Colors.pink),
          fabCloseIcon: Icon(Icons.close, color: primaryColor),
          fabMargin: const EdgeInsets.all(16.0),
          animationDuration: const Duration(milliseconds: 800),
          animationCurve: Curves.easeInOutCirc,
          children: <Widget>[
            RawMaterialButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FavoritasPage(tipo: widget.tipo),
                  ),
                );
                fabKey.currentState!.close();
              },
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(14.0),
              child: const Icon(
                Icons.favorite,
                color: Colors.pinkAccent,
                size: 30,
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                setState(() {
                  pesquisa = true;
                });
                fabKey.currentState!.close();
              },
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(14.0),
              child: const Icon(
                Icons.search,
                color: Colors.pinkAccent,
                size: 30,
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
                fabKey.currentState!.close();
              },
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(14.0),
              child: const Icon(
                Icons.home,
                color: Colors.pinkAccent,
                size: 30,
              ),
            ),
            RawMaterialButton(
              onPressed: () {
                Global.qual = 'I';
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          IncluirReceitaPage(tipo: widget.tipo)),
                );

                fabKey.currentState!.close();
              },
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(14.0),
              child: const Icon(
                Icons.add,
                color: Colors.pinkAccent,
                size: 30,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        backgroundColor: Colors.cyanAccent,
        selectedIndex: currentItem,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentItem = index;
          if (index == 0) {
            quale = 0;
            qual = 'Todas';
            todasReceitas();
          } else if (index == 1) {
            quale = 1;
            qual = 'Minhas';
            minhasReceitas();
          }
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(
              Icons.all_inbox,
              color: Colors.indigo.shade800,
              size: 18,
            ),
            title: const Text(
              'Todas',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.1,
              ),
            ),
            activeColor: Colors.cyan.shade800,
            textAlign: TextAlign.left,
          ),
          BottomNavyBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.indigo.shade800,
              size: 18,
            ),
            title: const Text(
              'Minhas',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.1,
              ),
            ),
            activeColor: Colors.cyan.shade800,
            textAlign: TextAlign.left,
          ),
        ],
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
        const Opacity(opacity: 0.88, child: CustomAppBar()),
        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(top: 60),
          //_large ? _height / 40 : (_medium ? _height / 33 : _height / 31),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (currentItem == 2) tipoRec2() else tipoRec(),
              if (pesquisa)
                Container(
                  width: 350,
                  height: 190,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade900,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: pesquisaReceita(),
                )
              else
                const Divider(
                  height: 5,
                  color: Colors.white,
                ),
              listRec(),
            ],
          ),
        ),
      ],
    );
  }

  Widget tipoRec() {
    return Text(
      qual + ' Receitas ' + widget.tipo,
      style: const TextStyle(
        fontSize: 30,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        color: Color(0xFF01579B),
      ),
    );
  }

  Widget tipoRec2() {
    return Column(
      children: [
        Text(
          ' Receitas ' + widget.tipo,
          style: const TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Color(0xFF01579B),
          ),
        ),
        Text(
          qual,
          style: const TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Color(0xFF01579B),
          ),
        ),
      ],
    );
  }

  Widget listRec() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: quale == 0 ? _receitas.length : _minhasreceitas.length,
      itemBuilder: (_, index) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Container(
                height: size,
                width: _width,
                margin: const EdgeInsets.only(
                    left: 16, top: 0, right: 16, bottom: 5),
                child: InkWell(
                    child: Stack(
                      children: [
                        quale == 0
                            ? Card(
                                elevation: 12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                color: Colors.white,
                                child: AnimatedContainer(
                                  duration: const Duration(seconds: 5),
                                  height: size,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0, vertical: 26),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFF213B6C),
                                          Color(0xFF0059A5)
                                        ]),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.cyan,
                                        blurRadius: 12,
                                        offset: Offset(3, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      _receitas[index]['imagem'] != 'Sem Imagem'
                                          ? Image.network(
                                              _receitas[index]['imagem'],
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.asset(
                                              'images/receitas/receitas.prn',
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.fill,
                                            ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              _receitas[index]['descricao'],
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.cyanAccent,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Tempo de Preparo: ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  _receitas[index]
                                                      ['tempoPreparo'],
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.pinkAccent,
                                                  ),
                                                ),
                                                const Text(
                                                  ' minutos',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Rendimento: ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  _receitas[index]
                                                      ['rendimento'],
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.pinkAccent,
                                                  ),
                                                ),
                                                const Text(
                                                  ' porções',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Card(
                                elevation: 12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                color: Colors.white,
                                child: AnimatedContainer(
                                  duration: const Duration(seconds: 5),
                                  height: size,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0, vertical: 26),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFF213B6C),
                                          Color(0xFF0059A5)
                                        ]),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.cyan,
                                        blurRadius: 12,
                                        offset: Offset(3, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      _minhasreceitas[index].imagem !=
                                              'Sem Imagem'
                                          ? Image.network(
                                              _minhasreceitas[index].imagem,
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.asset(
                                              'images/receitas/receitas.prn',
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.fill,
                                            ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              _minhasreceitas[index].descricao,
                                              style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.cyanAccent,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Tempo de Preparo: ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  _minhasreceitas[index]
                                                      .tempoPreparo,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.pinkAccent,
                                                  ),
                                                ),
                                                const Text(
                                                  ' minutos',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Rendimento: ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  _minhasreceitas[index]
                                                      .rendimento,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.pinkAccent,
                                                  ),
                                                ),
                                                const Text(
                                                  ' porções',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
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
                        if (quale == 0 &&
                            (_favoritas.contains(_receitas[index]['id']) ||
                                _selecionadas.contains(_receitas[index]['id'])))
                          favorita(),
                        if (quale == 1 &&
                            (_favoritas.contains(_minhasreceitas[index].id) ||
                                _selecionadas
                                    .contains(_minhasreceitas[index].id)))
                          favorita(),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        if (quale == 0) {
                          preencheListIngre(_receitas[index]['ingredientes']);
                          preencheListPrepa(_receitas[index]['preparo']);
                          Global.descricao = _receitas[index]['descricao'];
                          Global.id = _receitas[index]['id'];
                          Global.imagem = _receitas[index]['imagem'];
                          Global.rendimento = _receitas[index]['rendimento'];
                          Global.tempoPreparo =
                              _receitas[index]['tempoPreparo'];
                          Global.tipo = _receitas[index]['tipo'];
                        } else {
                          preencheListIngre(_receitas[index]['ingredientes']);
                          preencheListPrepa(_receitas[index]['preparo']);
                          Global.descricao = _receitas[index]['descricao'];
                          Global.id = _receitas[index]['id'];
                          Global.imagem = _receitas[index]['imagem'];
                          Global.rendimento = _receitas[index]['rendimento'];
                          Global.tempoPreparo =
                              _receitas[index]['tempoPreparo'];
                          Global.tipo = _receitas[index]['tipo'];
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const MostrarReceitaPage()));
                      });
                    },
                    onLongPress: () {
                      setState(() {
                        fav = !fav;
                        selecionar(index);
                      });
                    }),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget favorita() {
    return PositionCustom(
      left: 8,
      top: 8,
      child: const Icon(
        Icons.favorite,
        size: 32,
        color: Colors.cyan,
      ),
    );
  }

  Widget minhasRec() {
    return PositionCustom(
      right: 8,
      top: 8,
      child: const Icon(
        Icons.person,
        size: 32,
        color: Colors.cyan,
      ),
    );
  }

  Widget pesquisaReceita() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Radio(
                    value: 'Nome',
                    fillColor:
                        MaterialStateColor.resolveWith((states) => Colors.pink),
                    groupValue: _grouSelectValue,
                    onChanged: _groupChange),
                const Text(
                  'Nome',
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: 'Ingrediente',
                    fillColor:
                        MaterialStateColor.resolveWith((states) => Colors.pink),
                    groupValue: _grouSelectValue,
                    onChanged: _groupChange),
                const Text(
                  'Ingrediente',
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    value: 'Preparo',
                    fillColor:
                        MaterialStateColor.resolveWith((states) => Colors.pink),
                    groupValue: _grouSelectValue,
                    onChanged: _groupChange),
                const Text(
                  'Preparo',
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: Colors.cyanAccent.shade100,
                  ),
                  controller: _nomeController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.purpleAccent,
                  decoration: InputDecoration(
                    labelText: 'Digite o que procurar',
                    labelStyle: TextStyle(
                        color: Colors.deepPurple.shade100,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.purple.shade200, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _nomeController.text = '';
                    pesquisa = false;
                  });
                },
                child: const Icon(Icons.close, color: Colors.pinkAccent),
              ),
              const SizedBox(
                width: 80,
              ),
              ElevatedButton(
                onPressed: () {
                  searchRec(_grouSelectValue!, _nomeController.text);
                  _nomeController.text = '';
                },
                child: const Icon(Icons.search, color: Colors.pinkAccent),
              ),
            ],
          ),
        ),
      ],
    );
  }
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
          ],
        ),
      ),
    );
  }
}
