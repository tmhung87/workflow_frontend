import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:workflow/providers/auth_provider.dart';
import 'package:workflow/providers/user_provider.dart';
import 'package:workflow/styles/colors.dart';
import 'package:workflow/styles/strings.dart';
import 'package:workflow/views/home/homepage.dart';
import 'package:workflow/views/auth/loginpage.dart';
import 'package:workflow/views/task/taskmanagerpage.dart';
import 'package:workflow/views/user/useraddpage.dart';
import 'package:workflow/views/user/userdetailpage.dart';
import 'package:workflow/views/user/usermanagerpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo Flutter được khởi tạo trước
  await dotenv.load(fileName: ".env"); // Load biến môi trường
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Work Flow Manager',
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: false,
      ),

      home: LoginPage(),
    );
  }
}
