import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/ingrediente.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/search.dart';
import 'package:receitas_sandra/widgets/text_field.dart';

class ListIngre extends StatefulWidget {
  final List<Ingrediente>? list;
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

  List<Ingrediente> listIngre = [];

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
                  if (widget.qq == 'i') {
                    setState(() {
                      quanController.text =
                          widget.list!.elementAt(index).quantidade.toString();
                      selecionado =
                          widget.list!.elementAt(index).medida.toString();
                      descController.text =
                          widget.list!.elementAt(index).descricao.toString();
                    });
                    cadastraIngre();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  cadastraIngre() {
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
              child: formIngre(),
            ),
          ),
        );
      },
    );
  }

  salvarIngre(String quantidade, String medida, String descricao) {
    listIngre.add(
      Ingrediente(quantidade: quantidade, medida: medida, descricao: descricao),
    );
    Global.ingredientes.add(
      Ingrediente(quantidade: quantidade, medida: medida, descricao: descricao),
    );
    limparIngre();
  }

  limparIngre() {
    quanController.text = '';
    selecionado = '';
    descController.text = '';
  }

  Widget formIngre() {
    return Form(
      key: _formkeyI,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Cadastrar Ingredientes'),
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
              Material(
                borderRadius: BorderRadius.circular(20.0),
                elevation: 10,
                child: SizedBox(
                  width: 180,
                  height: 40,
                  child: medidasDropDown(),
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
                      salvarIngre(quanController.text, selecionado,
                          descController.text);
                      limparIngre();
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

  Widget medidasDropDown() {
    return DropdownSearchable(
      focusNode: focusDropDow,
      validator: (value) {
        if (value.isEmpty) {
          selecionado = '-';
        } else {
          selecionado = value;
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
