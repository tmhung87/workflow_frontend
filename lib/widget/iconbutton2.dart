import 'package:flutter/material.dart';

class IconButton2 extends StatefulWidget {
  const IconButton2({
    super.key,
    required this.onPressed,
    required this.child,
    this.tooltip,
  });
  final VoidCallback onPressed;
  final Widget child;
  final String? tooltip;

  @override
  State<IconButton2> createState() => _IconButton2State();
}

class _IconButton2State extends State<IconButton2> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          onTap: widget.onPressed,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
