import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
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

void showErrorDialog(BuildContext context, String message, Function() onClose) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ErrorDialog(message: message);
    },
  ).then((value) {
    onClose();
  });
}
