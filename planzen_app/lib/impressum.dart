import 'package:flutter/material.dart';
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

class Impressum extends StatefulWidget {
  const Impressum({super.key, required this.title});
  final String title;

  @override
  State<Impressum> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Impressum> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Impressum')),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Biologischer Teil:\nLuis Hüppe\n',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Divider(color: Color.fromRGBO(89, 89, 89, 0.5), thickness: 2),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'Programmier-Teil:\nVincent Bienert',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
