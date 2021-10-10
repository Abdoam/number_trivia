import 'package:domain/usecases/GetConcreteNumberTrivia.dart';
import 'package:domain/usecases/GetRandomNumberTrivia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presentation/bloc/number_trivia_bloc.dart';
import 'package:presentation/util/input_converter.dart';
import 'package:presentation/widgets/loading_widget.dart';
import 'package:presentation/widgets/message_display.dart';
import 'package:presentation/widgets/trivia_controls.dart';
import 'package:presentation/widgets/trivia_display.dart';

class NumberTriviaPage extends StatelessWidget {
  final GetConcreteNumberTrivia _getConcreteNumberTrivia;
  final GetRandomNumberTrivia _getRandomNumberTrivia;
  final InputConverter _inputConverter;

  const NumberTriviaPage(
      {Key? key,
      required getConcreteNumberTrivia,
      required getRandomNumberTrivia,
      required inputConverter})
      : _getConcreteNumberTrivia = getConcreteNumberTrivia,
        _getRandomNumberTrivia = getRandomNumberTrivia,
        _inputConverter = inputConverter,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(reverse: true,
          child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => NumberTriviaBloc(
          getConcreteNumberTrivia: _getConcreteNumberTrivia,
          getRandomNumberTrivia: _getRandomNumberTrivia,
          inputConverter: _inputConverter),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              // Top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(
                      message: 'Start searching',
                    );
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return TriviaDisplay(
                      numberTrivia: state.trivia,
                    );
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              //Bottom half
              const TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}