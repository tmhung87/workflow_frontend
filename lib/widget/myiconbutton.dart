import 'package:flutter/material.dart';

class MyIconButton extends StatefulWidget {
  const MyIconButton({
    super.key,
    required this.child,
    this.tooltip,
    required this.onPressed,
  });
  final VoidCallback onPressed;
  final Widget child;
  final String? tooltip;

  @override
  State<MyIconButton> createState() => _MyIconButtonState();
}

class _MyIconButtonState extends State<MyIconButton> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip ?? '',
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
    );
  }
}
