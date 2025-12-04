// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'main.dart';

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
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),

    );
  }
}

class Achievements extends StatefulWidget {
  const Achievements({super.key, required this.title});



  final String title;

  @override
  State<Achievements> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Achievements> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hi')),
      body: Center(child: Text('Hauptinhalt')),

    );
  }
}
