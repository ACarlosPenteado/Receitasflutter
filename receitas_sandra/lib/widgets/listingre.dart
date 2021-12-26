import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/autocomplete.dart';
import 'package:receitas_sandra/widgets/search.dart';
import 'package:receitas_sandra/widgets/text_field.dart';

class ListIngre extends StatefulWidget {
  final List? list;
  final String qq;
  double fontSize;

  ListIngre({Key? key, this.list, required this.fontSize, required this.qq})
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
      itemCount: Global.ingredientes.length,
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
                        Global.ingredientes
                            .elementAt(index)
                            .quantidade
                            .toString(),
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
                            Global.ingredientes
                                .elementAt(index)
                                .medida
                                .toString(),
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
                            Global.ingredientes
                                .elementAt(index)
                                .descricao
                                .toString(),
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
                  if (widget.qq == 'i') {
                    setState(() {
                      print(Global.ingredientes);
                      print(Global.ingredientes.elementAt(index));
                      quanController.text = Global.ingredientes
                          .elementAt(index)
                          .quantidade
                          .toString();
                      selecionado = Global.ingredientes
                          .elementAt(index)
                          .medida
                          .toString();
                      descController.text = Global.ingredientes
                          .elementAt(index)
                          .descricao
                          .toString();
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
            color: Colors.grey[100],
            width: 320,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: formIngre(index),
            ),
          ),
        );
      },
    );
  }

  alteraIngre(int index, String quantidade, String medida, String descricao) {
    Global.ingredientes.elementAt(index).quantidade = quantidade;
    Global.ingredientes.elementAt(index).medida = medida;
    Global.ingredientes.elementAt(index).descricao = descricao;

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
          const Text('Alterar Ingrediente'),
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
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  elevation: 10,
                  child: SizedBox(
                    width: 160,
                    height: 40,
                    child: AutoCompleteText(text: selecionado),
                  ),
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
                child: const Text("Salva"),
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
                child: const Text("Cancela"),
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
