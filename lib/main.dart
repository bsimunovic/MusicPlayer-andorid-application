import 'package:flutter/material.dart';
import 'Screens/HomeScreen/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shiva',
      home: HomeScreen(),
    );
  }
}
