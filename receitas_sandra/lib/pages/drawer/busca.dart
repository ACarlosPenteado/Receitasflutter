import 'package:flutter/material.dart';
import 'package:receitas_sandra/home_page.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuscaPage extends StatefulWidget {
  const BuscaPage({Key? key}) : super(key: key);

  @override
  State<BuscaPage> createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
  late WebViewController _controller;
  String nomeRec = '';
  String busca = '';
  double _width = 0.0;
  double _height = 1;

  bool isLoading = true;

  @override
  void initState() {
    nomeRec = Global.nomeRec;
    print(nomeRec);
    busca =
        'https://www.google.com.br/search?q=$nomeRec&btnK=Pesquisa+Google&rlz=1C2FCXM_pt-PTBR974BR974&sxsrf=AOaemvICZ4GO1Lfnr4JWpZyzwLfRgTX0hg%3A1635097864401&source=hp&ei=CJ11YcWzFOza1sQPnoK9mAc&iflsig=ALs-wAMAAAAAYXWrGO-KZmhseblZMs6NFtl_ttG0wGJi&ved=0ahUKEwjF14GbzuPzAhVsrZUCHR5BD3MQ4dUDCAc&uact=5&oq=medidor+internet&gs_lcp=Cgdnd3Mtd2l6EAMyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEOgQIIxAnOg4ILhCABBCxAxDHARDRAzoICAAQgAQQsQM6DgguEIAEELEDEMcBEKMCOggILhCxAxCDAToLCC4QgAQQxwEQ0QM6CAguEIAEELEDOgUIABCxAzoHCAAQgAQQCkoFCDwSATFQoFpYwrIBYKm0AWgBcAB4AIAB3QGIAaMQkgEGNC4xMi4xmAEAoAEB&sclient=gws-wiz';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 12,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Buscar Receitas',
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
          ],
        ),
        leading: IconButton(
          iconSize: 30,
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? buildPortrait()
            : buildLandscape(),
      ),
    );
  }

  Widget buildPortrait() => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              width: _width,
              height: _height,
              child: WebView(
                initialUrl: busca,
                gestureNavigationEnabled: true,
                onPageFinished: (_) {
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ),
            isLoading
                ? Container(
                    alignment: FractionalOffset.center,
                    child: const CircularProgressIndicator(
                      color: Colors.blue,
                      value: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                  ),
          ],
        ),
      );

  Widget buildLandscape() => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              width: _width,
              height: _height,
              child: WebView(
                initialUrl: busca,
                gestureNavigationEnabled: true,
              ),
            ),
          ],
        ),
      );
}
