import 'package:architecture/featuers/numberTrivia/presentation/pages/number_trivia_page.dart';
import 'package:architecture/injection_container.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        colorScheme: ColorScheme.fromSwatch(accentColor: Colors.green.shade600),
      ),
      title: 'Material App',
      home: const NumberTriviaPage(),
    );
  }
}
