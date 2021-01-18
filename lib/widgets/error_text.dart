import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String error;

  const ErrorText({@required this.error});

  @override
  Widget build(BuildContext context) {
    return Text(
      error,
      style: TextStyle(
        color: Colors.red,
        fontSize: 14.0,
      ),
    );
  }
}
