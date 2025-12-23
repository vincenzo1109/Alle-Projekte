import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'search.dart';
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

class PlantsOverview extends StatefulWidget {
  const PlantsOverview({super.key, required this.title});

  final String title;

  @override
  State<PlantsOverview> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PlantsOverview> {
  @override
  Widget build(BuildContext context) {
    final String plantShowing =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text(plantShowing)),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Ink.image(
                image: AssetImage('assets/icon.png'),

              ),
            ),
          ),
          Divider(color: Color.fromRGBO(89, 89, 89, 0.5), thickness: 2),
          Expanded(
            flex: 5,
            child: Center(
              child: Text(
                'Hier folgt ein Info-Text zu der Pflanze (Alter, Pflegehinweise,…) \n'
                'außerdem Sollen auch typische Erscheinungen/Events der Pflanze gezeigt '
                'werden (Was tun wenn die Pflanze sehr viele braune Blätter bekommt obwohl'
                ' sie immer gut gegossen wird oder wann die Erdbeere anfängt Früchte zu tragen',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Divider(color: Color.fromRGBO(89, 89, 89, 0.5), thickness: 2),
          Expanded(
            flex: 1,
            child: Center(
              child: TextButton.icon(
                label: Text('Pflanze löschen'),
                icon: Icon(Symbols.delete),
                onPressed: () {
                  deletePlant();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void deletePlant() async {
    bool? delete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Löschen der Pflanze'),
        content: Text(
          'Bist du dir sicher, dass du die Pflanze löschen möchtest?',
        ),
        actions: [
          TextButton(
            child: Text('Nein'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Ja'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    if (delete == true) {
      //Delete Stuff and close screen
    }
    setState(() {});
  }
}
