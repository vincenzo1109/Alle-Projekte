import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:planzen_app/plant_service.dart';
import 'main.dart';
import 'hive.dart';

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
  State<PlantsOverview> createState() => _PlantsOverviewState();
}

class _PlantsOverviewState extends State<PlantsOverview> {
  String? imagePath;

  late AllPlants currentPlant;


  getImage() {
    if (imagePath == null) {
      return Icon(Icons.image, size: 120);
    }

    if (imagePath!.startsWith('assets/')) {
      return Image.asset(imagePath!, height: 150, fit: BoxFit.cover);
    } else {
      return Image.file(File(imagePath!), height: 150, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {

    //FIXME raus aus build-methode
    int givenPlantId = ModalRoute
        .of(context)!
        .settings
        .arguments as int;
    // TODO List auf Set umstellen und dann den Lookup in den Service verlagern
    debugPrint('Searching for plant#$givenPlantId');
    currentPlant = PlantService.instance().getAllPlants().firstWhere(
          (plant) => plant.id == givenPlantId,
    );

    imagePath = currentPlant.imagePath;

    return Scaffold(
      appBar: AppBar(title: Text(currentPlant.name)),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Center(
                  child: SizedBox(height: 120, child: getImage()),
                ),
                TextButton(
                  onPressed: pickImage,
                  child: Text('Eigenes Bild hochladen'),
                ),
              ],
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

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        currentPlant.imagePath = pickedFile.path;
        PlantService.instance().saveAllPlants();
      });
    }
  }

  void deletePlant() async {
    bool? delete = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
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
