import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:receitas_sandra/pages/receitas/listar_receita_page.dart';
import 'package:receitas_sandra/repository/receitas_repository.dart';
import 'package:receitas_sandra/repository/users_repository.dart';
import 'package:receitas_sandra/widgets/custom_shape_clipper.dart';
import 'package:receitas_sandra/widgets/list_demo.dart';

class FavoritasPage extends StatefulWidget {
  final List receitas;
  final List favoritas;
  const FavoritasPage(
      {Key? key, required this.receitas, required this.favoritas})
      : super(key: key);

  @override
  State<FavoritasPage> createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            clipShape(),
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
            if (widget.favoritas.isNotEmpty)
              const Text(
                'Receitas Favoritas',
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF01579B),
                ),
              ),
            //ListDemo(list: widget.favoritas, receitas: widget.receitas),
            if (widget.favoritas.isEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Não há receitas favoritas!',
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(top: 60),
          //_large ? _height / 40 : (_medium ? _height / 33 : _height / 31),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListDemo(list: widget.favoritas, receitas: widget.receitas),
            ],
          ),
        ),
      ],
    );
  }
}
