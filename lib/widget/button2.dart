import 'package:flutter/material.dart';

class Button2 extends StatefulWidget {
  const Button2({super.key, required this.onPressed, required this.child});
  final Future<void> Function() onPressed;
  final Widget child;

  @override
  State<Button2> createState() => _Button2State();
}

class _Button2State extends State<Button2> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() => isLoading = true);
        try {
          await widget.onPressed();
        } catch (e) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text(e.toString()),
                ),
          );
        } finally {
          setState(() => isLoading = false);
        }
      },
      child:
          isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.child,
              ),
    );
  }
}
