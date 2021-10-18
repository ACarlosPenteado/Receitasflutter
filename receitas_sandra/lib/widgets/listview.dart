import 'package:flutter/material.dart';

class ListIngre extends StatelessWidget {
  late double _height;
  late double _width;

  final List list;

  ListIngre({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (_, index) {
        return SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(5),
              child: Stack(
                children: <Widget>[
                  Row(
                    children: const [
                      Text('data'),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
