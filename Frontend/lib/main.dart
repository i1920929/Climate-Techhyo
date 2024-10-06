import 'package:flutter/material.dart';
import 'screens/historia_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cambio Climático',
      theme: ThemeData(primarySwatch: Colors.green),
      home: StoryScreen(),
    );
  }
}
