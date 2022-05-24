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
    'imagens/FB_IMG_1.jpg',
    'imagens/FB_IMG_2.jpg',
    'imagens/FB_IMG_3.jpg',
    'imagens/FB_IMG_4.jpg',
    'imagens/FB_IMG_5.jpg',
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
              image: AssetImage(urlImagem),
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
