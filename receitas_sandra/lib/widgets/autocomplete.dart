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
      icon: const Icon(Icons.arrow_downward),
      iconEnabledColor: Colors.cyanAccent,
      items: _dropItems,
      dropdownColor: Colors.black26,
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      style: const TextStyle(
        color: Colors.cyanAccent,
        fontSize: 17,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: Colors.black,
            blurRadius: 5,
            offset: Offset(1, 1),
          ),
        ],
      ),
      onChanged: ((value) {
        setState(() {
          Global.ing_med = value!;
        });
      }),
    );
  }
}
