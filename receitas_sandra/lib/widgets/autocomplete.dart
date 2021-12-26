import 'package:flutter/material.dart';
import 'package:receitas_sandra/uteis/globais.dart';

class AutoCompleteText extends StatefulWidget {
  final String text;
  const AutoCompleteText({Key? key, required this.text}) : super(key: key);

  static const List<String> _kOptions = <String>[
    'colher de café',
    'colher de chá',
    'colher de sopa',
    'gramas',
    'kilo(s)',
    'litro(s)',
    'mls',
  ];

  @override
  State<AutoCompleteText> createState() => _AutoCompleteTextState();
}

class _AutoCompleteTextState extends State<AutoCompleteText> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: widget.text),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return AutoCompleteText._kOptions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        Global.ing_med = selection;
        debugPrint('Você selecionou $selection');
      },
    );
  }
}
