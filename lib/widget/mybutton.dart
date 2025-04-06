import 'package:flutter/material.dart';
import 'package:workflow/widget/showdialog.dart';

class MyButton extends StatefulWidget {
  const MyButton({super.key, required this.child, required this.onPressed});
  final Widget child;

  final Future Function() onPressed;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8)),
        ),
        onPressed: () async {
          setState(() => isLoading = true);
          try {
            var res = await widget.onPressed();
            // if (!res['state']) {
            //   throw res['message'] ?? 'Unknown error';
            // }
            // showMyDialog(context: context, title: 'Success', content: '');
          } catch (e) {
            showMyDialog(
              isSuccess: false,
              context: context,
              title: 'Error',
              content: '$e',
            );
          } finally {
            setState(() => isLoading = false);
          }
        },
        child: SizedBox(
          height: 36,
          child: Center(
            child:
                isLoading
                    ? FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                    : widget.child,
          ),
        ),
      ),
    );
  }
}
