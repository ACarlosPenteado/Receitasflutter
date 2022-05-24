import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ListView_Home extends StatefulWidget {
  const ListView_Home({Key? key}) : super(key: key);

  @override
  State<ListView_Home> createState() => _ListView_HomeState();
}

class _ListView_HomeState extends State<ListView_Home> {
  int activeIndex = 0;
  final urlImagens = [
    'https://scontent.fcgh10-1.fna.fbcdn.net/v/t1.6435-9/118206931_3593611250673146_8715447496143887195_n.jpg?stp=dst-jpg_p206x206&_nc_cat=111&ccb=1-5&_nc_sid=110474&_nc_eui2=AeE9saeH2QvSxHNurvRJHOEjPXHWoh9w3w09cdaiH3DfDTv7jY9m7mVFT_5SFmiKnbNpc_aNcdODRkgeIxsmVkar&_nc_ohc=_1Cvj7LP8aYAX-O_MW0&_nc_ht=scontent.fcgh10-1.fna&oh=00_AT_n4mQ6HxJmAYJHlkuQXL-CcG_FVAXJ-EDRZTtdzup1Yw&oe=6245ACE4',
    'https://scontent.fcgh10-1.fna.fbcdn.net/v/t1.6435-9/104836131_145670650428904_8609078132692701393_n.jpg?stp=c34.0.206.206a_dst-jpg_p206x206&_nc_cat=101&ccb=1-5&_nc_sid=110474&_nc_eui2=AeH_544dARUuDGCcgdE9ZmtOGn7Clte9FnwafsKW170WfA__DMWbJMCsaEPvldIbpDHsAomuufbiGEZIg4PJwcrX&_nc_ohc=YibXFv5i9vsAX-xCn6H&_nc_ht=scontent.fcgh10-1.fna&oh=00_AT8lplS2NB5n-PRASimNIXgjkaYmZ1rwucL4wSS8Iv3OUQ&oe=6246170C',
    'https://scontent.fcgh10-1.fna.fbcdn.net/v/t1.6435-9/161718176_495368064965018_8580941851743434042_n.jpg?stp=c0.23.206.206a_dst-jpg_p206x206&_nc_cat=104&ccb=1-5&_nc_sid=07e735&_nc_eui2=AeHXbkC1lo6E7EI9qlQBuViGqV6ZCL_wIxypXpkIv_AjHLKWXaYxg2uo51WPzch8K86gR8lgUgckeYPtykjTZPhh&_nc_ohc=wzkjzUqq6P4AX_Ti2j5&_nc_ht=scontent.fcgh10-1.fna&oh=00_AT-wo6RSYffLk1G1qEsFMG0FLuBVkh13BGji5zwsIrO-2Q&oe=6245EE81',
    'https://scontent.fcgh10-1.fna.fbcdn.net/v/t1.6435-9/105001397_144954767167159_1471683271604986178_n.jpg?stp=c34.0.206.206a_dst-jpg_p206x206&_nc_cat=104&ccb=1-5&_nc_sid=8024bb&_nc_eui2=AeGL_F7iLHY6aJbaUgKTObRZrUpySk5gRQytSnJKTmBFDGrtRHD0y5EOHxRhYRFbRzGTYCIh9OMxzQw4p3sowRzU&_nc_ohc=aKJ-VciU3aMAX_sQYz3&_nc_ht=scontent.fcgh10-1.fna&oh=00_AT8ol_JLOf0CTm9djfYnbxMcUqdkj9pmQv0qCndOVToZQQ&oe=624603CD',
    'https://scontent.fcgh10-1.fna.fbcdn.net/v/t1.6435-9/160900684_495366764965148_8539871273879838600_n.jpg?stp=c0.53.206.206a_dst-jpg_p206x206&_nc_cat=109&ccb=1-5&_nc_sid=07e735&_nc_eui2=AeGDU_jaXYHQ1KTbUGl8Xv2IO_sQs1ToJ4Q7-xCzVOgnhBH7f3flDDZQD2tVV4XFYTh34j4TOMBGd_7tIOi3HOyc&_nc_ohc=RsG8LKLpeLYAX80J4UQ&_nc_ht=scontent.fcgh10-1.fna&oh=00_AT-yDwcN4-exxQIg1kUzPCHX1_8zDSfzdnvuOL2bjnbUaw&oe=62435E5D'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 20, right: 20),
      shrinkWrap: true,
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 150,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            autoPlay: true,
            //reverse: true,
            // autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayInterval: const Duration(seconds: 2),
            enableInfiniteScroll: true,
            //autoPlayAnimationDuration: const Duration(milliseconds: 800),
            pageSnapping: false,
            //viewportFraction: 1.0,
            onPageChanged: (index, reason) =>
                setState(() => activeIndex = index),
          ),
          itemCount: urlImagens.length,
          itemBuilder: (context, index, realIndex) {
            final urlImagem = urlImagens[index];

            return buildImage(urlImagem, index);
          },
        ),
        const SizedBox(height: 12),
        Center(
          child: buildIndicator(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget buildImage(String urlImagem, int index) => InkWell(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            image: DecorationImage(
              image: NetworkImage(urlImagem),
              fit: BoxFit.cover,
            ),
          ),
        ),
        onTap: () {
          print(index);
        },
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: urlImagens.length,
        effect: const SlideEffect(
          dotWidth: 10,
          dotHeight: 10,
          activeDotColor: Colors.blue,
          dotColor: Colors.black12,
        ),
      );
}
