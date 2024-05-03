import 'package:flutter/material.dart';
import 'package:ultimate_flutter_db_sqflite/hafez/pages/effects_screen.dart';
import 'package:ultimate_flutter_db_sqflite/pages/home_page.dart';

import 'models/products_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EffectScreen(),
    );
  }

}
