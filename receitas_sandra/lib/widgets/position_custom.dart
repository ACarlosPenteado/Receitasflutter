import 'package:flutter/material.dart';

class PositionCustom extends StatefulWidget {
  final double? right;
  final double? left;
  final double? top;
  final double? bottom;
  final double? height;
  final double? width;
  final Widget child;

  PositionCustom({
    Key? key,
    this.right,
    this.left,
    this.top,
    this.bottom,
    this.height,
    this.width,
    required this.child,
  });

  @override
  State<PositionCustom> createState() => _PositionCustomState();
}

class _PositionCustomState extends State<PositionCustom> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: widget.child,
      left: widget.left,
      top: widget.top,
      right: widget.right,
      bottom: widget.bottom,
      width: widget.width,
      height: widget.height,
    );
  }
}
