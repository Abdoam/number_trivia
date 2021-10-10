import 'dart:async';

import 'package:domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:domain/usecases/GetRandomNumberTrivia.dart';
import 'package:flutter/material.dart';
import 'package:presentation/bloc/number_trivia_bloc.dart';
import 'package:presentation/screens/number_trivia_page.dart';
import 'package:presentation/util/input_converter.dart';
import 'injection_configuration/injection_container.dart';


void main() async {
  await runZonedGuarded(
        () async {
      WidgetsFlutterBinding.ensureInitialized();
      await configureInjection();
      runApp(const MyApp());
    },
        (error, st) => print(error),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: NumberTriviaPage(
          getConcreteNumberTrivia: getIt<GetConcreteNumberTrivia>(),
          getRandomNumberTrivia: getIt<GetRandomNumberTrivia>(),
          inputConverter: getIt<InputConverter>()
      ),
    );
  }
}