import 'package:flutter/material.dart';
import 'package:receitas_sandra/uteis/globais.dart';

class AutoCompleteText extends StatefulWidget {
  final String text;
  const AutoCompleteText({Key? key, required this.text}) : super(key: key);

  @override
  State<AutoCompleteText> createState() => _AutoCompleteTextState();
}

class _AutoCompleteTextState extends State<AutoCompleteText> {
  static const _kOptions = <String>[
    'colher de café',
    'colher de chá',
    'colher de sopa',
    'gramas',
    'kilo(s)',
    'litro(s)',
    'mls',
  ];

  late String selecionado;

  final List<DropdownMenuItem<String>> _dropItems = _kOptions
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ),
      )
      .toList();

  @override
  void initState() {
    Global.ing_med = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: Global.ing_med,
      hint: const Text('Medidas'),
      items: _dropItems,
      dropdownColor: Colors.black26,
      borderRadius: const BorderRadius.all(Radius.circular(20),),
      style: const TextStyle(
        color: Colors.pinkAccent,
        fontWeight: FontWeight.bold,
      ),
      onChanged: ((value) {
        setState(() {
          Global.ing_med = value!;
        });
      }),
    );
  }
}
