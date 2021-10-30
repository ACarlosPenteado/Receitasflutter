import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuscaPage extends StatefulWidget {
  const BuscaPage({Key? key}) : super(key: key);

  @override
  State<BuscaPage> createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) => orientation == Orientation.portrait
            ? buildPortrait()
            : buildLandscape(),
      ),
    );
  }

  Widget buildPortrait() => const Padding(
        padding: EdgeInsets.only(top: 40),
        child: WebView(
          initialUrl:
              'https://www.google.com.br/search?q=receitas&btnK=Pesquisa+Google&rlz=1C2FCXM_pt-PTBR974BR974&sxsrf=AOaemvICZ4GO1Lfnr4JWpZyzwLfRgTX0hg%3A1635097864401&source=hp&ei=CJ11YcWzFOza1sQPnoK9mAc&iflsig=ALs-wAMAAAAAYXWrGO-KZmhseblZMs6NFtl_ttG0wGJi&ved=0ahUKEwjF14GbzuPzAhVsrZUCHR5BD3MQ4dUDCAc&uact=5&oq=medidor+internet&gs_lcp=Cgdnd3Mtd2l6EAMyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEOgQIIxAnOg4ILhCABBCxAxDHARDRAzoICAAQgAQQsQM6DgguEIAEELEDEMcBEKMCOggILhCxAxCDAToLCC4QgAQQxwEQ0QM6CAguEIAEELEDOgUIABCxAzoHCAAQgAQQCkoFCDwSATFQoFpYwrIBYKm0AWgBcAB4AIAB3QGIAaMQkgEGNC4xMi4xmAEAoAEB&sclient=gws-wiz',
          gestureNavigationEnabled: true,
        ),
      );

  Widget buildLandscape() => const Padding(
        padding: EdgeInsets.only(top: 40),
        child: WebView(
          initialUrl:
              'https://www.google.com.br/search?q=receitas&btnK=Pesquisa+Google&rlz=1C2FCXM_pt-PTBR974BR974&sxsrf=AOaemvICZ4GO1Lfnr4JWpZyzwLfRgTX0hg%3A1635097864401&source=hp&ei=CJ11YcWzFOza1sQPnoK9mAc&iflsig=ALs-wAMAAAAAYXWrGO-KZmhseblZMs6NFtl_ttG0wGJi&ved=0ahUKEwjF14GbzuPzAhVsrZUCHR5BD3MQ4dUDCAc&uact=5&oq=medidor+internet&gs_lcp=Cgdnd3Mtd2l6EAMyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEOgQIIxAnOg4ILhCABBCxAxDHARDRAzoICAAQgAQQsQM6DgguEIAEELEDEMcBEKMCOggILhCxAxCDAToLCC4QgAQQxwEQ0QM6CAguEIAEELEDOgUIABCxAzoHCAAQgAQQCkoFCDwSATFQoFpYwrIBYKm0AWgBcAB4AIAB3QGIAaMQkgEGNC4xMi4xmAEAoAEB&sclient=gws-wiz',
          gestureNavigationEnabled: true,
        ),
      );
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
