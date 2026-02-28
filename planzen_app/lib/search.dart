import 'package:flutter/material.dart';
import 'package:planzen_app/plant_service.dart';
import 'package:planzen_app/widgets/plant_item.dart';
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
//TODO search in Task-Name/Plant-Name

  whichMatchingPlants(input) {
    matchingPlants = PlantService.instance()
        .getAllPlants()
        .where((plant) => plant.name.toLowerCase().contains(input))
        .toList();
    setState(() {});
  }

  showMatchingPlants() {
    List<Widget> showNextMatchingPlants = [];

    /* FIXME for (AllPlants plant in matchingPlants) {
      showNextMatchingPlants.add(
        PlantItem(task: plant, onChange: () => setState(() {})),
      );
    }

     */
    return showNextMatchingPlants;
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
            whichMatchingPlants(value.toLowerCase());
          },
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
      ),
      body: ListView(children: showMatchingPlants()),
    );
  }
}
