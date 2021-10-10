import 'package:domain/entities/number_trivia.dart';
import 'package:flutter/material.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia _numberTrivia;
  final double _height;

  const TriviaDisplay({
    Key? key,
    required NumberTrivia numberTrivia,
    double? height,
  }) : _numberTrivia = numberTrivia, _height = height ?? 0, super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (_height == 0)? MediaQuery.of(context).size.height / 3 : _height,
      child: Column(
        children: [
          Text(_numberTrivia.number,
            style: const TextStyle(fontSize: 50,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(_numberTrivia.text,
                  style: const TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}