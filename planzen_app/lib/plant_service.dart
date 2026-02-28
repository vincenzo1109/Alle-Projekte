import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:planzen_app/hive.dart';

class PlantService {
  static final PlantService _service = PlantService().._readAllPlants();

  static PlantService instance() => _service;

  late List<AllPlants> allPlants;

  List<AllPlants> getAllPlants() => allPlants;

  void insertPlant(AllPlants plant) {
    allPlants.add(plant);
    saveAllPlants();
  }

  AllPlants getPlant(int id) {
    return allPlants.firstWhere((plant) => plant.id == id);
  }

  void saveAllPlants() {
    hivePutMyPlantsList(allPlants);
  }

  void _readAllPlants() {
    var plantObjectBox = Hive.box(objectPlantKey);
    var objectList = plantObjectBox.get(
      'plantObjectList',
    ); //TODO crossing hive! here. Separate
    if (objectList != null) {
      allPlants = (objectList as List).cast<AllPlants>();
    } else {
      allPlants = [];
      _addStandardPlants();
      _readAllPlants();
    }
    debugPrint('Read all plants (${allPlants.length})');
  }



  void _addStandardPlants() {
    const String imagePath = 'assets/image/icon.png';

    if (!isAlreadyOpened()) {
      //addPlantMyPlants(Name, age, id, imagePath);
      addPlantMyPlants('Rose', 2, -1, imagePath);
      addPlantMyPlants('Himbeere', 4, -2, imagePath);
      addPlantMyPlants('Erdbeeren', 3, -3, imagePath);
      addPlantMyPlants('Alle Blumen', 4, -4, imagePath);
      addPlantMyPlants('Löwenzahn', 1, -5, imagePath);
      addPlantMyPlants('Hanf-Pflanze', 1, -6, imagePath);
      saveAllPlants();
    }
  }



  void addPlantMyPlants(
    //TODO Beautify
    String name,
    int age,
    int id,
    String path,
  ) {
    AllPlants plant = AllPlants(name, age, id, path);
    allPlants.add(plant);
  }
}
