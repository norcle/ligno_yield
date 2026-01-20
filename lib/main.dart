import 'package:flutter/material.dart';
import 'package:ligno_yiled/screens/input_screen.dart';

void main() {
  runApp(const LignoUrozhaiApp());
}

class LignoUrozhaiApp extends StatelessWidget {
  const LignoUrozhaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LignoUrozhai',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const InputScreen(),
    );
  }
}
