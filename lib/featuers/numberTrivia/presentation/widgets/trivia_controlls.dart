import 'package:architecture/featuers/numberTrivia/presentation/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:architecture/featuers/numberTrivia/domain/entity/number_trivia.dart';
import 'package:architecture/featuers/numberTrivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:architecture/featuers/numberTrivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:architecture/featuers/numberTrivia/presentation/widgets/message_display.dart';
import 'package:architecture/featuers/numberTrivia/presentation/widgets/trivia_display.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class triviaControlls extends StatefulWidget {
  @override
  State<triviaControlls> createState() => _triviaControllsState();
}

class _triviaControllsState extends State<triviaControlls> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (val) {},
          onSubmitted: (_) {},
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text('Search'),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text('Get random trivia'),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcrateNumber(controller.value.text));
    controller.clear();
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}

class blocBuilder extends StatelessWidget {
  const blocBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
      builder: (context, state) {
        if (state is Empty)
          return messageDisplay(message: "Start searching !");
        else if (state is Loading) {
          return LodingWidget();
        } else if (state is Loaded) {
          return TriviaDisplay(numberTrivia: state.numberTrivia);
        } else if (state is Error) {
          return messageDisplay(message: state.message);
        } else {
          return Text("data");
        }
      },
    );
  }
}
