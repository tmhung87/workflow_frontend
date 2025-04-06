import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isValidator = false,
    this.enable,
    this.obscureText = false,
    this.inputFormatters,
  });
  final String label;
  final TextEditingController controller;
  final bool isValidator;
  final bool obscureText;

  final bool? enable;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLines: 1,

        inputFormatters: inputFormatters,
        obscureText: obscureText,
        enabled: enable,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            child: Icon(Icons.clear),
            onTap: () {
              controller.clear();
            },
          ),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          border: OutlineInputBorder(),
          labelText: label,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        validator:
            isValidator
                ? (value) {
                  if (value == null || value.isEmpty) {
                    return "This field cannot be empty";
                  }
                  return null;
                }
                : null,
      ),
    );
  }
}
