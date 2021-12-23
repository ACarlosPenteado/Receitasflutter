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
      borderRadius: BorderRadius.circular(20.0),
      elevation: 10,
      child: TextFormField(
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
          labelStyle: TextStyle(fontSize: widget.ftm),
          labelText: widget.hint,
          suffixText: widget.sufix,
          suffixStyle: const TextStyle(fontSize: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
