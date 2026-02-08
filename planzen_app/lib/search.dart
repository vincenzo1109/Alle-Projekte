import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:planzen_app/plant_service.dart';
import 'main.dart';
import 'hive.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

class Search extends StatefulWidget {
  const Search({super.key, required this.title});

  final String title;

  @override
  State<Search> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Search> {
  List<AllPlants> matchingPlants = [];

  showMatchingPlants(input) {
    matchingPlants = PlantService.instance().getAllPlants()
        .where((plant) => plant.name.contains(input))
        .toList();
    for (AllPlants plants in matchingPlants) {
      debugPrint(plants.name);
    }
    //TODO Das nächste: irgendwie die Liste bauen lassen (Homescreen)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SearchBar(
          hintText: 'Suchen',
          leading: Icon(Icons.search),
          onChanged: (value) {
            showMatchingPlants(value.toLowerCase());
          },
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
      ),
      body: Center(child: Text('Hauptinhalt')),
    );
  }
}
