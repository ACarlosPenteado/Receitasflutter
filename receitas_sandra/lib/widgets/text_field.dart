import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final String? sufix;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final int? tm;
  final int? maxLine;
  final double ftm;
  final FormFieldValidator? validator;
  final FocusNode? focusNode;
  final FormFieldSetter? onChange;
  final bool focus;

  CustomTextField({
    Key? key,
    required this.hint,
    this.sufix,
    required this.textEditingController,
    required this.keyboardType,
    this.tm,
    this.maxLine,
    required this.ftm,
    this.validator,
    this.focusNode,
    this.onChange,
    required this.focus,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Colors.black26,
      elevation: 12,
      color: Colors.black26,
      child: TextFormField(
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 5,
              offset: Offset(1, 1),
            ),
          ],
        ),
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Colors.orange[200]!,
        validator: widget.validator,
        focusNode: widget.focusNode,
        onChanged: widget.onChange,
        autofocus: widget.focus,
        maxLines: widget.maxLine,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.tm),
        ],
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Colors.blue.shade200,
            fontSize: widget.ftm,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                color: Colors.black,
                blurRadius: 5,
                offset: Offset(1, 1),
              ),
            ],
          ),
          labelText: widget.hint,
          suffixText: widget.sufix,
          suffixStyle: const TextStyle(
            fontSize: 15,
            color: Colors.pinkAccent,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black,
                blurRadius: 5,
                offset: Offset(1, 1),
              ),
            ],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.blue.shade900,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Colors.indigoAccent,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
