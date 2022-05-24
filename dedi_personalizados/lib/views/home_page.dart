import 'package:carousel_slider/carousel_slider.dart';
import 'package:dedi_personalizados/views/gerenciar_produtos.dart';
import 'package:dedi_personalizados/widgets/listview_home.dart';
import 'package:dedi_personalizados/widgets/procura_produtos.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime time = DateTime.now();
  late double _height;
  late double _width;
  late double _pixelRatio;

  final urlImagens = [
    'https://scontent.fcgh10-1.fna.fbcdn.net/v/t1.6435-9/118206931_3593611250673146_8715447496143887195_n.jpg?stp=dst-jpg_p206x206&_nc_cat=111&ccb=1-5&_nc_sid=110474&_nc_eui2=AeE9saeH2QvSxHNurvRJHOEjPXHWoh9w3w09cdaiH3DfDTv7jY9m7mVFT_5SFmiKnbNpc_aNcdODRkgeIxsmVkar&_nc_ohc=_1Cvj7LP8aYAX-O_MW0&_nc_ht=scontent.fcgh10-1.fna&oh=00_AT_n4mQ6HxJmAYJHlkuQXL-CcG_FVAXJ-EDRZTtdzup1Yw&oe=6245ACE4',
    'https://scontent.fcgh10-1.fna.fbcdn.net/v/t1.6435-9/104836131_145670650428904_8609078132692701393_n.jpg?stp=c34.0.206.206a_dst-jpg_p206x206&_nc_cat=101&ccb=1-5&_nc_sid=110474&_nc_eui2=AeH_544dARUuDGCcgdE9ZmtOGn7Clte9FnwafsKW170WfA__DMWbJMCsaEPvldIbpDHsAomuufbiGEZIg4PJwcrX&_nc_ohc=YibXFv5i9vsAX-xCn6H&_nc_ht=scontent.fcgh10-1.fna&oh=00_AT8lplS2NB5n-PRASimNIXgjkaYmZ1rwucL4wSS8Iv3OUQ&oe=6246170C',
    'https://scontent.fcgh10-1.fna.fbcdn.net/v/t1.6435-9/161718176_495368064965018_8580941851743434042_n.jpg?stp=c0.23.206.206a_dst-jpg_p206x206&_nc_cat=104&ccb=1-5&_nc_sid=07e735&_nc_eui2=AeHXbkC1lo6E7EI9qlQBuViGqV6ZCL_wIxypXpkIv_AjHLKWXaYxg2uo51WPzch8K86gR8lgUgckeYPtykjTZPhh&_nc_ohc=wzkjzUqq6P4AX_Ti2j5&_nc_ht=scontent.fcgh10-1.fna&oh=00_AT-wo6RSYffLk1G1qEsFMG0FLuBVkh13BGji5zwsIrO-2Q&oe=6245EE81',
    'https://scontent.fcgh10-1.fna.fbcdn.net/v/t1.6435-9/105001397_144954767167159_1471683271604986178_n.jpg?stp=c34.0.206.206a_dst-jpg_p206x206&_nc_cat=104&ccb=1-5&_nc_sid=8024bb&_nc_eui2=AeGL_F7iLHY6aJbaUgKTObRZrUpySk5gRQytSnJKTmBFDGrtRHD0y5EOHxRhYRFbRzGTYCIh9OMxzQw4p3sowRzU&_nc_ohc=aKJ-VciU3aMAX_sQYz3&_nc_ht=scontent.fcgh10-1.fna&oh=00_AT8ol_JLOf0CTm9djfYnbxMcUqdkj9pmQv0qCndOVToZQQ&oe=624603CD',
    'https://scontent.fcgh10-1.fna.fbcdn.net/v/t1.6435-9/160900684_495366764965148_8539871273879838600_n.jpg?stp=c0.53.206.206a_dst-jpg_p206x206&_nc_cat=109&ccb=1-5&_nc_sid=07e735&_nc_eui2=AeGDU_jaXYHQ1KTbUGl8Xv2IO_sQs1ToJ4Q7-xCzVOgnhBH7f3flDDZQD2tVV4XFYTh34j4TOMBGd_7tIOi3HOyc&_nc_ohc=RsG8LKLpeLYAX80J4UQ&_nc_ht=scontent.fcgh10-1.fna&oh=00_AT-yDwcN4-exxQIg1kUzPCHX1_8zDSfzdnvuOL2bjnbUaw&oe=62435E5D'
  ];

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
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
            ),
            child: const Flexible(
              child: ListView_Home(),
            ),
          ),
          Flexible(
            child: gridView(),
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
    return GridView(
      padding: const EdgeInsets.only(left: 20, right: 20),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: false,
      primary: false,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      children: [
        Card(
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
                left: 0.0,
                right: 0.0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: Image.network(
                    urlImagens[0],
                    height: 120,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Positioned(
                bottom: 5,
                left: 35,
                right: 35,
                child: Text(
                  'Imagem 1',
                  style: TextStyle(
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
        Card(
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
                left: 0.0,
                right: 0.0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: Image.network(
                    urlImagens[1],
                    height: 120,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Positioned(
                bottom: 5,
                left: 35,
                right: 35,
                child: Text(
                  'Imagem 2',
                  style: TextStyle(
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
        Card(
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
                left: 0.0,
                right: 0.0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: Image.network(
                    urlImagens[2],
                    height: 120,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Positioned(
                bottom: 5,
                left: 35,
                right: 35,
                child: Text(
                  'Imagem 3',
                  style: TextStyle(
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
        Card(
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
                left: 0.0,
                right: 0.0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: Image.network(
                    urlImagens[3],
                    height: 120,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Positioned(
                bottom: 5,
                left: 35,
                right: 35,
                child: Text(
                  'Imagem 4',
                  style: TextStyle(
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
        Card(
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
                left: 0.0,
                right: 0.0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: Image.network(
                    urlImagens[4],
                    height: 120,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Positioned(
                bottom: 5,
                left: 35,
                right: 35,
                child: Text(
                  'Imagem 5',
                  style: TextStyle(
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
      ],
    );
  }
}
