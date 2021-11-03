import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/ingrediente.dart';

class ListIngre extends StatelessWidget {
  final List<Ingrediente> list;
  double fontSize;

  ListIngre({Key? key, required this.list, required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          list.elementAt(index).quantidade,
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
                      Expanded(
                        flex: 5,
                        child: Text(
                          ' - ' + list.elementAt(index).medida,
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
                      Expanded(
                        flex: 5,
                        child: Text(
                          ' - ' + list.elementAt(index).descricao,
                          style: TextStyle(
                              fontSize: fontSize,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade800,
                              shadows: const [
                                Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(1, 1))
                              ]),
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
