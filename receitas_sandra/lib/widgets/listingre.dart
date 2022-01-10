import 'package:flutter/material.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/autocomplete.dart';
import 'package:receitas_sandra/widgets/text_field.dart';

class ListIngre extends StatefulWidget {
  final List? list;
  final int? qq;
  double fontSize;

  ListIngre({Key? key, this.list, this.qq, required this.fontSize})
      : super(key: key);

  @override
  State<ListIngre> createState() => _ListIngreState();
}

class _ListIngreState extends State<ListIngre> {
  TextEditingController quanController = TextEditingController();
  TextEditingController mediController = TextEditingController();
  TextEditingController descController = TextEditingController();

  final GlobalKey<FormState> _formkeyI = GlobalKey();

  List listIngre = [];

  String selecionado = '';

  FocusNode focusQtd = FocusNode();
  FocusNode focusDropDow = FocusNode();
  FocusNode focusDescI = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.list!.length,
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
                        widget.list!.elementAt(index).quantidade.toString(),
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
                        ' - ' + widget.list!.elementAt(index).medida.toString(),
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
                            widget.list!.elementAt(index).descricao.toString(),
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
                  if (widget.qq != 1) {
                    setState(() {
                      quanController.text =
                          widget.list!.elementAt(index).quantidade.toString();
                      selecionado =
                          widget.list!.elementAt(index).medida.toString();
                      descController.text =
                          widget.list!.elementAt(index).descricao.toString();
                    });
                    cadastraIngre(index);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  cadastraIngre(int index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 320,
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF259cda), Color(0xFF6bbce6)]),
              boxShadow: const [
                BoxShadow(
                  color: Colors.cyan,
                  blurRadius: 12,
                  offset: Offset(3, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: formIngre(index),
            ),
          ),
        );
      },
    );
  }

  alteraIngre(int index, String quantidade, String medida, String descricao) {
    widget.list!.elementAt(index).quantidade = quantidade;
    widget.list!.elementAt(index).medida = medida;
    widget.list!.elementAt(index).descricao = descricao;

    limparIngre();
  }

  limparIngre() {
    quanController.text = '';
    selecionado = '';
    descController.text = '';
  }

  Widget formIngre(int index) {
    return Form(
      key: _formkeyI,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Alterar Ingrediente',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black,
                  blurRadius: 5,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 85,
                height: 40,
                child: quanTextFormField(),
              ),
              const SizedBox(
                width: 35,
              ),
              Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: Colors.black26,
                elevation: 12,
                color: Colors.black26,
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  width: 160,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: Colors.blue.shade900, width: 2.0)),
                  child: AutoCompleteText(text: selecionado),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 285,
                height: 80,
                child: descITextFormField(),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                child: const Text(
                  "Salva",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  setState(() {
                    if (_formkeyI.currentState!.validate()) {
                      alteraIngre(index, quanController.text, Global.ing_med,
                          descController.text);
                      limparIngre();
                      Navigator.pop(context);
                    }
                  });
                },
              ),
              ElevatedButton(
                child: const Text(
                  "Cancela",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  limparIngre();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget quanTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      textEditingController: quanController,
      tm: 3,
      ftm: 15,
      maxLine: 1,
      hint: 'QTD',
      focus: true,
      focusNode: focusQtd,
      onChange: (value) {
        if (value.length == 3) {
          FocusScope.of(context).requestFocus(focusDropDow);
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com a quantidade';
        }
        return null;
      },
    );
  }

  Widget descITextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: descController,
      tm: 40,
      maxLine: 2,
      ftm: 15,
      focus: false,
      focusNode: focusDescI,
      hint: 'Descrição',
      validator: (value) {
        if (value.isEmpty) {
          return 'Entre com a descrição';
        }
        return null;
      },
    );
  }
}
