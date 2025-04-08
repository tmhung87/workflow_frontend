import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:workflow/widget/mybutton.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _staffIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String _message = '';

  void _login(BuildContext context, String staffId, String password) async {
    if (_formKey.currentState!.validate()) {
      await context.read<AuthProvider>().login(context, staffId, password);
    }
  }

  void _checklogin() async {
    var storage = FlutterSecureStorage();
    var staffId = await storage.read(key: 'staffId');
    var password = await storage.read(key: 'password');
    _staffIdController.text = staffId ?? '';
    _passwordController.text = password ?? '';
    if (staffId != null && password != null) {
      await context.read<AuthProvider>().login(context, staffId, password);
    }
  }

  @override
  void initState() {
    super.initState();
    _checklogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng Nhập")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: 350, // Điều chỉnh kích thước cho đẹp
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mã nhân viên
                  TextFormField(
                    controller: _staffIdController,
                    decoration: InputDecoration(
                      labelText: "Mã nhân viên",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.person,
                      ), // Biểu tượng cho mã nhân viên
                    ),
                    validator:
                        (value) => value!.isEmpty ? "Nhập mã nhân viên" : null,
                  ),
                  SizedBox(height: 20),

                  // Mật khẩu
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Mật khẩu",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock), // Biểu tượng cho mật khẩu
                    ),
                    obscureText: true,
                    validator:
                        (value) =>
                            value!.length < 6
                                ? "Mật khẩu ít nhất 6 ký tự"
                                : null,
                  ),
                  SizedBox(height: 20),

                  // Nút Đăng nhập
                  MyButton(
                    onPressed:
                        () async => _login(
                          context,
                          _staffIdController.text,
                          _passwordController.text,
                        ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Login'),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Thông báo lỗi
                  if (_message.isNotEmpty)
                    Text(
                      _message,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
