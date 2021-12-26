import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/preparo.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/text_field.dart';

class ListPrepa extends StatefulWidget {
  final List? list;
  double fontSize;

  ListPrepa({Key? key, this.list, required this.fontSize}) : super(key: key);

  @override
  State<ListPrepa> createState() => _ListPrepaState();
}

class _ListPrepaState extends State<ListPrepa> {
  TextEditingController prepaController = TextEditingController();

  final GlobalKey<FormState> _formkeyP = GlobalKey();

  List listPrepa = [];

  FocusNode focusDescP = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: Global.preparo.length,
      itemBuilder: (_, index) {
        return SafeArea(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(5),
              child: InkWell(
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            ' - ' +
                                Global.preparo
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
                onTap: () {
                  prepaController.text =
                      Global.preparo.elementAt(index).descricao.toString();
                  cadastraPrepa(index);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  cadastraPrepa(int index) {
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
              child: formPrepa(index),
            ),
          ),
        );
      },
    );
  }

  alteraPrepa(int index, String descricao) {
    Global.preparo.elementAt(index).descricao = descricao;

    limparPrepa();
  }

  limparPrepa() {
    prepaController.text = '';
  }

  Widget formPrepa(int index) {
    return Form(
      key: _formkeyP,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Alterar Modo de Preparo'),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                width: 285,
                height: 80,
                child: descPTextFormField(),
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
                    if (_formkeyP.currentState!.validate()) {
                      alteraPrepa(index, prepaController.text);
                      limparPrepa();
                      Navigator.pop(context);
                    }
                  });
                },
              ),
              ElevatedButton(
                child: const Text("Cancela"),
                onPressed: () {
                  limparPrepa();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget descPTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      textEditingController: prepaController,
      tm: 40,
      maxLine: 2,
      ftm: 15,
      focus: false,
      focusNode: focusDescP,
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
