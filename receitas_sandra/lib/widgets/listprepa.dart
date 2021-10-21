import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/preparo.dart';

class ListPrepa extends StatelessWidget {
  final List<Preparo> list;

  const ListPrepa({Key? key, required this.list}) : super(key: key);

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
                        flex: 5,
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
