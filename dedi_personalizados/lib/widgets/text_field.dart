import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String? sufix;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final int? tm;
  final int? maxLine;
  final double ftm;
  final FormFieldValidator? validator;
  final FocusNode? focusNode;
  final FormFieldSetter? onSubmited;
  final bool focus;

  const CustomTextField({
    Key? key,
    required this.labelText,
    this.sufix,
    required this.textEditingController,
    required this.keyboardType,
    this.textInputAction,
    this.tm,
    this.maxLine,
    required this.ftm,
    this.validator,
    this.focusNode,
    this.onSubmited,
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
          color: Colors.purpleAccent,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 5,
              offset: Offset(1, 1),
            ),
          ],
        ),
        toolbarOptions: const ToolbarOptions(
            paste: true, cut: true, selectAll: true, copy: true),
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: widget.textInputAction,
        cursorColor: Colors.orange[200]!,
        validator: widget.validator,
        focusNode: widget.focusNode,
        onFieldSubmitted: widget.onSubmited,
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
          labelText: widget.labelText,
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
