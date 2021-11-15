import 'package:architecture/featuers/numberTrivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:architecture/featuers/numberTrivia/presentation/widgets/trivia_controlls.dart';
import 'package:architecture/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/loading_widget.dart';
import './number_trivia_page.dart';

class NumberTriviaPage extends StatefulWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  _NumberTriviaPageState createState() => _NumberTriviaPageState();
}

class _NumberTriviaPageState extends State<NumberTriviaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Trivia"),
      ),
      body: buildBody(),
    );
  }
}

class buildBody extends StatelessWidget {
  const buildBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: blocBuilder(),
              ),
              SizedBox(height: 20),
              triviaControlls()
            ],
          ),
        ));
  }
}
