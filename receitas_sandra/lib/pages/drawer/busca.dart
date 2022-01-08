import 'package:flutter/material.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuscaPage extends StatefulWidget {
  const BuscaPage({Key? key}) : super(key: key);

  @override
  State<BuscaPage> createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
  String nomeRec = '';
  String busca = '';

  bool isLoading = true;

  @override
  void initState() {
    nomeRec = Global.nomeRec;
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
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? buildPortrait()
            : buildLandscape(),
      ),
    );
  }

  Widget buildPortrait() => Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Stack(
          children: [
            WebView(
              initialUrl: busca,
              gestureNavigationEnabled: true,
              onPageFinished: (_) {
                setState(() {
                  isLoading = false;
                });
              },
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

  Widget buildLandscape() => Padding(
        padding: const EdgeInsets.only(top: 40),
        child: WebView(
          initialUrl: busca,
          gestureNavigationEnabled: true,
        ),
      );
}
