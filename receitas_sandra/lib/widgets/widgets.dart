import 'package:flutter/material.dart';

class ListDemo extends StatelessWidget {
  late double _height;
  late double _width;

  final AsyncSnapshot qsRec;

  ListDemo({Key? key, required this.qsRec}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: qsRec.data.length,
      itemBuilder: (_, index) {
        return SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Stack(
                children: <Widget>[
                  Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 36),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF213B6C), Color(0xFF0059A5)]),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.cyan,
                            blurRadius: 12,
                            offset: Offset(3, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const FlutterLogo(size: 48),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  qsRec.data[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(color: Colors.white),
                                ),
                                Text('Some description',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.navigate_next,
                            size: 36,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 8,
                    top: 8,
                    child: Icon(
                      Icons.star,
                      size: 32,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
