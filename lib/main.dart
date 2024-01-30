import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/create_prompt_screen.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenPrompt();
  }
}
