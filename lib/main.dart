import 'package:animation_tutorial/example/coffee_hero_horizontal_demo.dart';
import 'package:flutter/material.dart';
import 'package:heroine/heroine.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [
        HeroineController(),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CoffeeHeroHorizontalDemo(),
    );
  }
}