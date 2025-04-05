import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../home/homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _staffIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _message = '';

  void _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.login(
        _staffIdController.text,
        _passwordController.text,
      );
      print(response);
      if (response['token'] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        setState(() {
          _message = response['message'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _staffIdController.text = 'vae01231';
    _passwordController.text = '123123';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đăng Nhập")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _staffIdController,
                decoration: InputDecoration(labelText: "Mã nhân viên"),
                validator:
                    (value) => value!.isEmpty ? "Nhập mã nhân viên" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Mật khẩu"),
                obscureText: true,
                validator:
                    (value) =>
                        value!.length < 6 ? "Mật khẩu ít nhất 6 ký tự" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _login(context),
                child: Text("Đăng nhập"),
              ),
              if (_message.isNotEmpty)
                Text(_message, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
