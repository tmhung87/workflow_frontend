import 'package:flutter/material.dart';

class MyContainer extends StatefulWidget {
  const MyContainer({
    super.key,
    required this.child,
    required this.title,
    this.width,
    this.height,
  });
  final Widget child;
  final String title;
  final double? width;
  final double? height;

  @override
  State<MyContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer> {
  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Icon(
                      !isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: widget.child,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
