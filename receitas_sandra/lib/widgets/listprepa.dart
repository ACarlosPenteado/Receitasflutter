import 'package:flutter/material.dart';
import 'package:receitas_sandra/model/preparo.dart';
import 'package:receitas_sandra/uteis/globais.dart';
import 'package:receitas_sandra/widgets/text_field.dart';

class ListPrepa extends StatefulWidget {
  final List<Preparo>? list;
  double fontSize;

  ListPrepa({Key? key, this.list, required this.fontSize}) : super(key: key);

  @override
  State<ListPrepa> createState() => _ListPrepaState();
}

class _ListPrepaState extends State<ListPrepa> {
  TextEditingController prepaController = TextEditingController();

  final GlobalKey<FormState> _formkeyP = GlobalKey();

  List<Preparo> listPrepa = [];

  FocusNode focusDescP = FocusNode();

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
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            ' - ' +
                                widget.list!
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
                      widget.list!.elementAt(index).descricao.toString();
                  cadastraPrepa();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  cadastraPrepa() {
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
              child: formPrepa(),
            ),
          ),
        );
      },
    );
  }

  salvarPrepa(String descricao) {
    listPrepa.add(
      Preparo(descricao: descricao),
    );
    Global.preparo.add(
      Preparo(descricao: descricao),
    );
    limparPrepa();
  }

  limparPrepa() {
    prepaController.text = '';
  }

  Widget formPrepa() {
    return Form(
      key: _formkeyP,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Cadastrar Modo de Preparo'),
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
                      salvarPrepa(prepaController.text);
                      limparPrepa();
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
