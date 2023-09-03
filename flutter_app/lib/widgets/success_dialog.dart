import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String message;

  const SuccessDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Success'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

void showSuccessDialog(
    BuildContext context, String message, Function() onClose) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SuccessDialog(message: message);
    },
  ).then((value) {
    onClose();
  });
}
