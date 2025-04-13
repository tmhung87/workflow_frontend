import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/providers/loading_provider.dart';
import 'package:workflow/widget/showdialog.dart';

class MyButton extends StatefulWidget {
  const MyButton({super.key, required this.child, required this.onPressed});
  final Widget child;
  final Future Function() onPressed;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8)),
        ),
        onPressed: () async {
          context.read<LoadingProvider>().startLoading();
          try {
            await widget.onPressed();
          } catch (e) {
            print(e);
          } finally {
            context.read<LoadingProvider>().endLoading();
          }
        },
        child: Padding(padding: const EdgeInsets.all(8.0), child: widget.child),
      ),
    );
  }
}
