import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/providers/loading_provider.dart';

class MyLoadingWidget extends StatefulWidget {
  const MyLoadingWidget({super.key, required this.child});
  final Widget child;
  @override
  State<MyLoadingWidget> createState() => _MyLoadingWidgetState();
}

class _MyLoadingWidgetState extends State<MyLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoadingProvider>(
      builder: (context, value, child) {
        return Stack(
          children: [
            widget.child,
            if (value.loading)
              Container(
                color: const Color.fromARGB(47, 255, 255, 255),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
