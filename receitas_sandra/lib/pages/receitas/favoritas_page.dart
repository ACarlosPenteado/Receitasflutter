import 'package:flutter/material.dart';
import 'package:receitas_sandra/widgets/list_favoritas.dart';

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

    return Scaffold(
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
        title: const Text(
          'Favoritas',
          style: TextStyle(
              fontSize: 25,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 5.0,
                  offset: Offset(1, 1),
                ),
              ]),
        ),
      ),
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
            if (widget.favoritas.isEmpty)
              const Text(
                'N??o h?? receitas favoritas!',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 25,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 5.0,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ListFavoritas(list: widget.favoritas, receitas: widget.receitas),
          ],
        ),
      ),
    );
  }
}
