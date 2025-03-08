import 'package:engez/home.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Engez());
}

class Engez extends StatelessWidget {
  Engez({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Engez',
      theme: ThemeData(
        fontFamily: 'Misans',
      ),
      home: Home(),
    );
  }
}
