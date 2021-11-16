import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/pages/receitas/incluir_receita_page.dart';

class ListIngre extends StatefulWidget {
  final List list;
  double fontSize;

  ListIngre({Key? key, required this.list, required this.fontSize})
      : super(key: key);

  @override
  State<ListIngre> createState() => _ListIngreState();
}

class _ListIngreState extends State<ListIngre> {
  
  final cadIng = IncluirReceitaPage();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.list.length,
      itemBuilder: (_, index) {
        return SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(5),
              child: InkWell(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        widget.list.elementAt(index).quantidade.toString(),
                        style: TextStyle(
                          fontSize: widget.fontSize,
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
                        ' - ' + widget.list.elementAt(index).medida.toString(),
                        style: TextStyle(
                          fontSize: widget.fontSize,
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
                        ' - ' +
                            widget.list.elementAt(index).descricao.toString(),
                        style: TextStyle(
                            fontSize: widget.fontSize,
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
                ),
                onTap: () {
                  cadastraIngre(
                      widget.list.elementAt(index).descricao.toString());
                },
              ),
            ),
          ),
        );
      },
    );
  }

  cadastraIngre(String descricao) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            color: Colors.grey[100],
            width: 320,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(descricao),
            ),
          ),
        );
      },
    );
  }

}
