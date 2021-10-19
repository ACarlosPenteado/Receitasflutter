import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownSearchable extends StatefulWidget {
  static const routeName = '/DropdownSearchable';

  const DropdownSearchable({Key? key}) : super(key: key);
  @override
  _DropdownSearchableState createState() => _DropdownSearchableState();
}

class _DropdownSearchableState extends State<DropdownSearchable> {
  final List<String> item = [
    "Colher(es) de Café",
    "Colher(es) de Chá",
    "Colher(es) de Sopa",
    "Copo(s) Americano",
    "Copo(s) de Requeijão",
    "Gramas",
    "Kilo(s)",
    "Litro(s)",
    "Mls",
    "Xícara(s) de Chá"
  ];

  String selecionado = '';

  FocusNode focusDropDown = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      mode: Mode.MENU,
      maxHeight: 300,
      popupElevation: 8,
      focusNode: focusDropDown,
      popupTitle: const Center(
        child: Text(
          'Medidas',
          style: TextStyle(
              color: Colors.pink, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      popupShape: const RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF2A8068)),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      showSelectedItems: true,
      items: item,
      popupItemDisabled: (String s) => s.startsWith('I'),
      onChanged: (value) {
        setState(() {
          selecionado = value!;
        });
      },
      selectedItem: selecionado,
      popupBarrierDismissible: true,
      dropdownSearchDecoration: const InputDecoration(
        labelText: "Medidas",
        fillColor: Colors.black,
        floatingLabelStyle: TextStyle(color: Colors.blue),
        focusColor: Colors.blue,
        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
