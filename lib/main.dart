import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/create_prompt_screen.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(21, 23, 46, 1),
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(21, 23, 46, 1),
      ),
      home: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPrompt();
  }
}
