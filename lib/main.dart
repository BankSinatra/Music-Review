import 'package:flutter/material.dart';
import 'Screens/HomePage.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Review',
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      );
      
  }
}