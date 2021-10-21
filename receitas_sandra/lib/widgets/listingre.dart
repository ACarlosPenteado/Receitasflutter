import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/ingrediente.dart';

class ListIngre extends StatelessWidget {
  final List<Ingrediente> list;

  const ListIngre({Key? key, required this.list}) : super(key: key);

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
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          list.elementAt(index).quantidade,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          ' - ' + list.elementAt(index).medida,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Text(
                          ' - ' + list.elementAt(index).descricao,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
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
