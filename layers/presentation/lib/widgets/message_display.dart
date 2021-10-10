import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String _message;
  final double _height;

  const MessageDisplay({
    Key? key,
    required String message,
    double? height,
  }) : _message = message, _height = height ?? 0, super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (_height == 0)? MediaQuery.of(context).size.height / 3 : _height,
      child: Center(
        child: SingleChildScrollView(
          child: Text(_message,
            style: const TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}