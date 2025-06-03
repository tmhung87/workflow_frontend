import 'package:flutter/material.dart';
import 'package:workflow/widget/mybutton.dart';
import 'package:workflow/widget/myiconbutton.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, this.actions, this.sideBar, this.child});

  final List<Widget>? actions;
  final Widget? sideBar;
  final Widget? child;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  double _sideBarWidth = 250;
  bool _isSideBarOpen = false;
  List<Widget> actions = [];
  bool isMobile = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 550;

        if (isMobile && widget.sideBar != null) {
          actions = [
            MyButton(
              child: Icon(
                _isSideBarOpen
                    ? Icons.view_sidebar_outlined
                    : Icons.view_sidebar_outlined,
              ),
              onPressed:
                  () async => setState(() => _isSideBarOpen = !_isSideBarOpen),
            ),
            ...widget.actions ?? [],
          ];
        } else {
          actions = widget.actions ?? [];
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (actions.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                // decoration: BoxDecoration(color: Colors.grey.shade300),
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: actions,
                    ),
                  ),
                ),
              ),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.sideBar != null
                      ? _isSideBarOpen || !isMobile
                          ? SizedBox(
                            width: !isMobile ? _sideBarWidth : width,
                            child: widget.sideBar,
                          )
                          : SizedBox()
                      : SizedBox(),
                  widget.sideBar != null
                      ? !isMobile
                          ? GestureDetector(
                            onTap:
                                () => setState(
                                  () => _isSideBarOpen = !_isSideBarOpen,
                                ),
                            onDoubleTap:
                                () => setState(() => _sideBarWidth = 250),
                            onHorizontalDragUpdate: _dragChangeSideBarWidth,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.resizeLeftRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300.withValues(
                                      alpha: 0.6,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.grey.shade300.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  width: 8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withValues(
                                            alpha: 0.6,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        width: 4,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withValues(
                                            alpha: 0.6,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        width: 45,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withValues(
                                            alpha: 0.6,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          : SizedBox()
                      : SizedBox(),
                  Expanded(
                    // Đảm bảo widget.child hiển thị khi sidebar mở
                    child: widget.child ?? Container(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _dragChangeSideBarWidth(DragUpdateDetails details) {
    setState(() {
      _sideBarWidth = (_sideBarWidth + details.delta.dx).clamp(
        250.0,
        550.0 - 150,
      );
    });
  }
}
