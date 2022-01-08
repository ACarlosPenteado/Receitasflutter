import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/model/preparo.dart';
import 'package:receitas_sandra/model/receitas.dart';
import 'package:receitas_sandra/pages/receitas/favoritas_page.dart';
import 'package:receitas_sandra/pages/receitas/incluir_receita_page.dart';
import 'package:receitas_sandra/pages/receitas/mostrar_receitas_page.dart';
import 'package:receitas_sandra/repository/users_repository.dart';
import 'package:receitas_sandra/repository/receitas_repository.dart';
import 'package:receitas_sandra/uteis/funtions.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';
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
  late final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 99,
    keepScrollOffset: true,
  );
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  double _screenWidth = 0.0;
  double size = 150;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore fireDb = FirebaseFirestore.instance;
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  final TextEditingController _nomeController = TextEditingController();

  List _listareceitas = [];
  List _receitas = [];
  List _favoritas = [];
  final List _selecionadas = [];
  List _minhasreceitas = [];
  List _searchreceitas = [];
  List<Receitas> mostraReceitas = [];
  List<Ingrediente> _listIngre = [];
  List<Preparo> _listPrepa = [];
  bool fav = false;
  int currentItem = 0;
  String qual = 'Todas';
  int quale = 0;
  bool pesquisa = false;
  String? _grouSelectValue;
  bool toTopBtn = false;
  String nomeUser = '';

  @override
  void initState() {
    _scrollController.addListener(() {
      scrollEvent;
    });
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

  void nomeuser(String iduser) {
    getNome(iduser).then((value) {
      nomeUser = value.toString();
    });
  }

  void confirma(String id, String iduser) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.black45,
          content: Container(
            width: _screenWidth,
            height: 50,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Center(
                child: Text(
                  'Confirma Exclusão',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Ok',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent,
                ),
              ),
              onPressed: () {
                if (iduser == _auth.currentUser!.uid) {
                  exclui(id);
                  Fluttertoast.showToast(msg: 'Receita Excluída');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                } else {
                  Fluttertoast.showToast(msg: 'Receita de outro usuário');
                }
              },
            ),
            TextButton(
              child: const Text(
                'Cancela',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void exclui(String? id) {
    ReceitasRepository recRepo =
        ReceitasRepository(auth: _auth.currentUser!.uid);
    recRepo.excluiReceita(id!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width - 48.0 - 64.0;
  }

  void scrollEvent() {
    var _status = false;
    if (_scrollController.offset > 100) {
      _status = true;
    } else {
      _status = false;
    }
    setState(() {
      toTopBtn = _status;
    });
  }

  _groupChange(String? value) {
    setState(() {
      _grouSelectValue = value;
    });
  }

  preencheListIngre(int ql, List list) async {
    _listIngre = [];
    Global.tamListI = 1;
    if (ql == 0) {
      for (var i = 0; i < list.length; i++) {
        _listIngre.add(
          Ingrediente(
              quantidade: list.elementAt(i)['quantidade'],
              medida: list.elementAt(i)['medida'],
              descricao: list.elementAt(i)['descricao']),
        );
      }
    } else {
      for (var i = 0; i < list.length; i++) {
        _listIngre.add(
          Ingrediente(
              quantidade: list.elementAt(i).quantidade,
              medida: list.elementAt(i).medida,
              descricao: list.elementAt(i).descricao),
        );
      }
    }
    Global.tamListI += _listIngre.length;
  }

  preencheListPrepa(int ql, List list) async {
    _listPrepa = [];
    Global.tamListP = 1;
    if (ql == 0) {
      for (var i = 0; i < list.length; i++) {
        _listPrepa.add(
          Preparo(descricao: list.elementAt(i)['descricao']),
        );
      }
    } else {
      for (var i = 0; i < list.length; i++) {
        _listPrepa.add(
          Preparo(descricao: list.elementAt(i).descricao),
        );
      }
    }
    Global.tamListP += _listPrepa.length;
  }

  listaReceitas() {
    _receitas = [];
    _listareceitas = [];
    quale = 0;
    ReceitasRepository recRepo =
        ReceitasRepository(auth: _auth.currentUser!.uid);
    recRepo.listReceita(widget.tipo).listen((e) {
      for (var i = 0; i < e.docs.length; i++) {
        preencheListIngre(0, e.docs[i].get('ingredientes'));
        preencheListPrepa(0, e.docs[i].get('preparo'));
        if (e.docs[i].get('tipo') == widget.tipo &&
            e.docs[i].get('ativo') == true) {
          _listareceitas.add(
            Receitas(
              ativo: e.docs.elementAt(i).get('ativo'),
              id: e.docs.elementAt(i).get('id'),
              data: e.docs[i].get('data'),
              descricao: e.docs[i].get('descricao'),
              iduser: e.docs[i].get('iduser'),
              imagem: e.docs[i].get('imagem'),
              ingredientes: _listIngre,
              preparo: _listPrepa,
              rendimento: e.docs[i].get('rendimento'),
              tempoPreparo: e.docs[i].get('tempoPreparo'),
              tipo: e.docs[i].get('tipo'),
            ),
          );
        }
      }
      setState(() {
        _receitas = _listareceitas;
      });
    });
  }

  todasReceitas() {
    _receitas = _listareceitas;
  }

  minhasReceitas() {
    _minhasreceitas = [];
    quale = 1;
    for (var i = 0; i < _receitas.length; i++) {
      if (_receitas[i].iduser == _auth.currentUser!.uid) {
        preencheListIngre(1, _receitas[i].ingredientes);
        preencheListPrepa(1, _receitas[i].preparo);
        _minhasreceitas.add(
          Receitas(
            ativo: _receitas[i].ativo,
            id: _receitas[i].id,
            data: _receitas[i].data,
            descricao: _receitas[i].descricao,
            iduser: _receitas[i].iduser,
            imagem: _receitas[i].imagem,
            ingredientes: _listIngre,
            preparo: _listPrepa,
            rendimento: _receitas[i].rendimento,
            tempoPreparo: _receitas[i].tempoPreparo,
            tipo: _receitas[i].tipo,
          ),
        );
      }
    }

    _receitas = _minhasreceitas;
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
        if (!_selecionadas.contains(_receitas[index].id)) {
          _selecionadas.add(_receitas[index].id);
        }
        if (!_favoritas.contains(_receitas[index].id)) {
          userRepo.favoritar(_auth, _receitas[index].id);
          _favoritas.add(_receitas[index].id);
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
        if (_selecionadas.contains(_receitas[index].id)) {
          _selecionadas.remove(_receitas[index].id);
        }
        if (_favoritas.contains(_receitas[index].id)) {
          userRepo.desfavoritar(_auth, _receitas[index].id);
          _favoritas.remove(_receitas[index].id);
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

  searchRec(int qs, String gr, String pq) {
    _searchreceitas = [];
    _receitas = [];
    List _lista = [];
    if (qs == 0) {
      _lista = _listareceitas;
    } else {
      _lista = _minhasreceitas;
    }
    for (var i = 0; i < _lista.length; i++) {
      switch (gr) {
        case 'Nome':
          if (pq.isNotEmpty) {
            _searchreceitas = _lista
                .where((rec) => rec.descricao
                    .toString()
                    .toLowerCase()
                    .contains(pq.toLowerCase()))
                .toList();
          }
          break;
        case 'Ingrediente':
          for (var j = 0; j < _listIngre.length; j++) {
            if (_listIngre.isNotEmpty) {
              _searchreceitas = _lista
                  .where((rec) => rec.ingredientes
                      .toString()
                      .toLowerCase()
                      .contains(pq.toLowerCase()))
                  .toList();
            }
          }

          break;
        case 'Preparo':
          for (var j = 0; j < _listPrepa.length; j++) {
            if (_listPrepa.isNotEmpty) {
              _searchreceitas = _lista
                  .where((rec) => rec.preparo
                      .toString()
                      .toLowerCase()
                      .contains(pq.toLowerCase()))
                  .toList();
            }
          }
      }
      if (_searchreceitas.isNotEmpty) {
        currentItem = 3;
      }
      setState(() {
        _receitas = _searchreceitas;
      });
      print(_receitas);
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Scrollbar(
                child: clipShape(),
              ),
            ),
          ],
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
            if (currentItem == 3) tipoRec1() else tipoRec(),
          ],
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
                    builder: (context) => FavoritasPage(
                        receitas: _receitas, favoritas: _favoritas),
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
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => IncluirReceitaPage(tipo: widget.tipo),
                  ),
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
        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (pesquisa)
                Expanded(
                  flex: 5,
                  child: Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.white,
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 5),
                      width: 350,
                      height: 150,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade900,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: pesquisaReceita(),
                    ),
                  ),
                )
              else
                const SizedBox(
                  width: 300,
                  child: Divider(
                    height: 5,
                    color: Colors.white,
                  ),
                ),
              Expanded(
                flex: 7,
                child: listRec(),
              ),
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
        fontSize: 25,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        color: Color(0xFF01579B),
      ),
    );
  }

  Widget tipoRec1() {
    return Text(
      _receitas.length.toString() + ' Receita(s) encontrada(s)',
      style: const TextStyle(
        fontSize: 25,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        color: Color(0xFF01579B),
      ),
    );
  }

  Widget listRec() {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      itemCount: _receitas.length,
      itemBuilder: (_, index) {
        return Dismissible(
          key: ValueKey(_receitas[index]),
          background: Container(
            alignment: Alignment.centerLeft,
            color: Colors.cyanAccent,
            child: Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  Text(
                    'Exclui Receita',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
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
            alignment: Alignment.centerRight,
            color: Colors.cyanAccent,
            child: Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  Text(
                    'Exclui Receita',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
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
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart || direction == DismissDirection.startToEnd) {
              if (_receitas[index].iduser == _auth.currentUser!.uid) {
                confirma(_receitas[index].id!, _receitas[index].iduser);
              } else {
                Fluttertoast.showToast(
                    msg: 'Somente ' + nomeUser + ' pode excluir esta receita!');
                _receitas.removeAt(index);
              }
            }
          },
          child: SafeArea(
            child: Center(
              child: Container(
                height: size,
                width: _width,
                margin: const EdgeInsets.only(
                    left: 16, top: 0, right: 16, bottom: 5),
                child: InkWell(
                  child: Hero(
                    tag: 'card' + _receitas[index].descricao,
                    child: Stack(
                      children: [
                        Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 5),
                            height: size,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF213B6C),
                                    Color(0xFF0059A5),
                                  ]),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.cyan,
                                  blurRadius: 12,
                                  offset: Offset(3, 5),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                _receitas[index].imagem != 'Sem Imagem'
                                    ? Positioned(
                                        top: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          child: Image.network(
                                            _receitas[index].imagem,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      )
                                    : Positioned(
                                        top: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          child: Image.asset(
                                            'images/receitas/receitas.png',
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                Positioned(
                                  top: 58,
                                  left: 32,
                                  width: _screenWidth,
                                  child: Container(
                                    height: 80,
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.black38,
                                      border: Border.all(
                                        color: Colors.cyanAccent.shade400,
                                        width: 3.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: Text(
                                            _receitas[index].descricao,
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.cyanAccent,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 30,
                                          left: 0,
                                          width: _screenWidth,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Tempo de Preparo: ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                _receitas[index].tempoPreparo,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.cyanAccent,
                                                ),
                                              ),
                                              const Text(
                                                ' minutos',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 50,
                                          left: 0,
                                          width: _screenWidth,
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Rendimento: ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                _receitas[index].rendimento,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.cyanAccent,
                                                ),
                                              ),
                                              const Text(
                                                ' porções',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_favoritas.contains(_receitas[index].id) ||
                            _selecionadas.contains(_receitas[index].id))
                          favorita(),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      preencheListIngre(1, _receitas[index].ingredientes);
                      preencheListPrepa(1, _receitas[index].preparo);
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          fullscreenDialog: true,
                          transitionDuration:
                              const Duration(milliseconds: 1000),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return MostrarReceitaPage(
                              receitas: Receitas(
                                ativo: _receitas[index].ativo,
                                id: _receitas[index].id,
                                data: _receitas[index].data,
                                descricao: _receitas[index].descricao,
                                iduser: _receitas[index].iduser,
                                imagem: _receitas[index].imagem,
                                ingredientes: _listIngre,
                                preparo: _listPrepa,
                                rendimento: _receitas[index].rendimento,
                                tempoPreparo: _receitas[index].tempoPreparo,
                                tipo: _receitas[index].tipo,
                              ),
                            );
                          },
                          transitionsBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    });
                  },
                  onLongPress: () {
                    setState(() {
                      fav = !fav;
                      selecionar(index);
                    });
                  },
                ),
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
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: Row(
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
                    onChanged: _groupChange,
                  ),
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
                    onChanged: _groupChange,
                  ),
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
                    onChanged: _groupChange,
                  ),
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
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
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
                        borderSide: BorderSide(
                            color: Colors.purple.shade200, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
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
                    setState(() {
                      searchRec(quale, _grouSelectValue!, _nomeController.text);
                      _nomeController.text = '';
                      pesquisa = false;
                    });
                  },
                  child: const Icon(Icons.search, color: Colors.pinkAccent),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget customAppBar() {
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
            const SizedBox(
              width: 30,
            )
          ],
        ),
      ),
    );
  }
  /*  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<>('_mostrareceitas', _mostrareceitas));
  } */
}
