import 'package:domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia{
  const NumberTriviaModel({required text, required number})
      : super(number: number, text: text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> jsonMap) {
    return NumberTriviaModel(text: jsonMap['text'], number: (jsonMap['number'] as num).toInt().toString());
  }

  Map<String, dynamic> toJson() {
    return {
      "number" : number,
      "text" : text,
    };
  }

}