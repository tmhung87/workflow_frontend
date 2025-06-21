import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/providers/loading_provider.dart';

class MyButton extends StatefulWidget {
  const MyButton({
    super.key,
    this.child,
    required this.onPressed,
    this.ask = false,
    this.icon,
  });
  final Widget? child;
  final Future Function() onPressed;
  final bool ask;
  final Icon? icon;
  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  void _onTap() async {
    context.read<LoadingProvider>().startLoading();
    try {
      await widget.onPressed();
    } catch (e) {
      print(e);
    } finally {
      context.read<LoadingProvider>().endLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child:
          widget.icon == null
              ? ElevatedButton(
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
                onPressed: () async {
                  if (widget.ask == true) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text("Are you sure ?"),
                            actions: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.green,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _onTap();
                                },
                                child: Text('YES'),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.red,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('NO'),
                              ),
                            ],
                          ),
                    );
                  } else {
                    _onTap();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.child,
                ),
              )
              : InkWell(
                hoverColor: const Color.fromARGB(255, 255, 0, 0),
                focusColor: const Color.fromARGB(255, 255, 0, 0),
                highlightColor: const Color.fromARGB(255, 255, 0, 0),
                onTap: () async {
                  if (widget.ask == true) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text("Are you sure ?"),
                            actions: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.green,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _onTap();
                                },
                                child: Text('YES'),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.red,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('NO'),
                              ),
                            ],
                          ),
                    );
                  } else {
                    _onTap();
                  }
                },
                child: widget.icon,
              ),
    );
  }
}
