import 'package:flutter/material.dart';

void showMyDialog({
  required BuildContext context,
  required String title,
  required String content,
  bool isSuccess = true,
}) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              SizedBox(width: 10),
              Text(title),
            ],
          ),
          content: content.isEmpty ? null : Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Đóng"),
            ),
          ],
        ),
  );
}
