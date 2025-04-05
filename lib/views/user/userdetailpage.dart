import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow/widget/mainlayout.dart';
import 'package:workflow/widget/mycontainer.dart';
import 'package:workflow/providers/user_provider.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});
  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: MyContainer(
        title: 'User detail',
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return Column(
              children: [
                Text(userProvider.selectedUser?.name ?? ''),
                Text(userProvider.selectedUser?.email ?? ''),
                Text(userProvider.selectedUser?.division ?? ''),
                Text(userProvider.selectedUser?.department ?? ''),
                Text(userProvider.selectedUser?.position ?? ''),
                Text(userProvider.selectedUser?.status ?? ''),
              ],
            );
          },
        ),
      ),
    );
  }
}
