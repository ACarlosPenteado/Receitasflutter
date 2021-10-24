import 'package:flutter/material.dart';

class SelectImage extends StatefulWidget {
  final Function(String imageUrl) onFileChanged;

  SelectImage({
    required this.onFileChanged,
  });

  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
