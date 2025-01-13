import 'package:flutter/material.dart';
import 'package:proup/home.dart';

void main() {
  runApp(const ProUp());
}

class ProUp extends StatelessWidget {
  const ProUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'proup',
      theme: ThemeData(
        fontFamily: 'Misans',
      ),
      home: Home(),
    );
  }
}
