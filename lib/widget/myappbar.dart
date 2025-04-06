import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/providers/auth_provider.dart';
import 'package:workflow/styles/strings.dart';
import 'package:workflow/views/auth/loginpage.dart';
import 'package:workflow/views/settings/settingspage.dart';
import 'package:workflow/views/user/userdetailpage.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.label});
  final String label;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('${widget.label}'),
      actions: [
        Consumer<AuthProvider>(
          builder:
              (context, value, child) => PopupMenuButton(
                position: PopupMenuPosition.under,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 8),
                      Text('${value.auth!.staffId}'),
                    ],
                  ),
                ),
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        child: Text('Profile'),
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        UserDetailPage(user: value.auth!),
                              ),
                            ),
                      ),
                      PopupMenuItem(
                        child: Text('Settings'),
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(),
                              ),
                            ),
                      ),
                      PopupMenuItem(
                        child: Text('Logout'),
                        onTap:
                            () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                              (route) => false,
                            ),
                      ),
                    ],
              ),
        ),
      ],
    );
  }
}
