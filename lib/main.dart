import 'package:findra/screens/main_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const Findra());
}

class Findra extends StatelessWidget {
  const Findra({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Findra',
      debugShowCheckedModeBanner: false,

      home: const MainScreen(),
    );
  }
}
