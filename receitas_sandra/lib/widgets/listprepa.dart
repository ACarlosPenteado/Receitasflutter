import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/preparo.dart';

class ListPrepa extends StatelessWidget {
  final List<Preparo>? list;
  double fontSize;

  ListPrepa({Key? key, this.list, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list!.length,
      itemBuilder: (_, index) {
        return SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(5),
              child: Stack(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          ' - ' + list!.elementAt(index).descricao.toString(),
                          style: TextStyle(
                            fontSize: fontSize,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade800,
                            shadows: const [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 5,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
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
