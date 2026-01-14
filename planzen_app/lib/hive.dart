import 'package:hive/hive.dart';


part 'hive.g.dart';

//var for Hive-Keys (easier (Autocompletion); no spelling Mistakes)
const String dataKey = 'dataSaves';
const String idKey='maxPlantId';
const String objectPlantKey = 'plantObjectSaves';


int buildNewPlantId() {
  var box = Hive.box(objectPlantKey);
  int oldMaxId = box.get(idKey, defaultValue: 0);
  int newMaxId = oldMaxId + 1;
  box.put(idKey, newMaxId);
  return newMaxId;
}

bool isAlreadyOpened() {
  var boxHiveOpen = Hive.box(dataKey);
  bool alreadyOpened = boxHiveOpen.get('alreadyOpened', defaultValue: false);
  return alreadyOpened;
}


void hivePutMyPlantsList(List<AllPlants> saveList) {
  var boxHive = Hive.box(objectPlantKey);
  boxHive.put('plantObjectList', saveList);
}

@HiveType(typeId: 0)
class AllPlants {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  DateTime prevLastCompletion;

  @HiveField(3)
  DateTime lastCompletion;

  @HiveField(4)
  int interval;

  @HiveField(5)
  String whatToDo;

  @HiveField(6)
  int id;

  AllPlants(
      this.name,
      this.age,
      this.prevLastCompletion,
      this.lastCompletion,
      this.whatToDo,
      this.interval,
      this.id,
      );
}