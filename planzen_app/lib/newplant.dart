import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planzen_app/editTask.dart';
import 'package:planzen_app/plant_service.dart';
import 'package:planzen_app/plant_task_service.dart';

import 'hive.dart';

class NewPlant extends StatefulWidget {
  const NewPlant({super.key, required this.title});

  final String title;

  @override
  State<NewPlant> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NewPlant> {
  String? name;
  int age = 0;
  DateTime lastTime = DateTime.now();
  bool ageOk = true;

  bool nameOk = true;
  TextEditingController datePicked = TextEditingController();

  int id = buildNewPlantId();

  @override
  Widget build(BuildContext context) {
    List<PlantTask> tempTask = PlantTaskService.instance()
        .getAllTasks()
        .where((task) => task.plantId == id)
        .toList();


    Widget buildTaskCard(PlantTask task) {
      return Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          leading: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.task_alt, color: Colors.white),
          ),
          title: Text(
            task.whatToDo ?? 'Kein Titel',
            // Passe dies an deine PlantTask Eigenschaften an
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('Erinnerung aller: ${task.interval} Tage'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),

          onTap: () async {
            final updatedTask = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditTask(plantId: id, maybeEditTask: task),
              ),
            );

            if (updatedTask != null && mounted) {
              setState(() {
                int index = tempTask.indexOf(task);
                if (index != -1) {
                  tempTask[index] = updatedTask;
                }
              });
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Pflanze hinzufügen')),
      body: ListView(
        children: [
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: TextField(
              onChanged: (value) {
                var maybeString = value.isEmpty ? null : value;
                setState(() {
                  debugPrint(' Name ist $maybeString');
                  if (maybeString != null) {
                    name = maybeString;
                    nameOk = true;
                  } else {
                    nameOk = false;
                  }
                });
              },
              decoration: InputDecoration(
                labelText: 'Name der Pflanze',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.label_important_sharp),
                filled: !nameOk,
                fillColor: Colors.red,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),

          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            title: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                var maybeInt = value.isEmpty ? 0 : int.tryParse(value);
                setState(() {
                  if (maybeInt != null && maybeInt >= 0) {
                    age = maybeInt;
                    ageOk = true;
                  } else {
                    ageOk = false;
                  }
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.calendar_month),
                labelText: 'Alter der Pflanze',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixText: 'Jahre',
                filled: !ageOk,
                fillColor: Colors.red,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 5),
            child: TextButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTask(plantId: id),
                  ),
                );
                if (result != null && mounted) {
                  setState(() {
                    // Hier fügst du die Daten deiner Liste hinzu oder aktualisierst sie
                    tempTask.add(result);
                  });
                }
              },
              icon: Icon(Icons.add_task),
              label: Text('Aufgabe hinzufügen'),
              style: TextButton.styleFrom(
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                foregroundColor: Theme
                    .of(context)
                    .colorScheme
                    .onPrimary,
              ),
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tempTask.length,
            itemBuilder: (context, index) {
              return buildTaskCard(tempTask[index]);
            },
          ),

          Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: TextButton.icon(
              label: Text('Alles speichern'),
              icon: Icon(Icons.check),
              style: TextButton.styleFrom(
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .primary,
                foregroundColor: Theme
                    .of(context)
                    .colorScheme
                    .onPrimary,
              ),
              onPressed: () {
                if (ageOk && nameOk) {
                  setState(() {
                    PlantService.instance().addPlantMyPlants(
                      name!,
                      age,
                      id,
                      'assets/image/icon.png',
                    );
                    PlantService.instance().saveAllPlants();
                    debugPrint(
                      'neue Pflanze: $name, $age Jahre, mit ID $id hinzugefügt',
                    );
                    Navigator.pop(context);
                  });
                } else {
                  setState(() {
                    ageOk = false;
                    nameOk = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      showCloseIcon: true,
                      duration: Duration(seconds: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Es gibt noch Fehler (rote Felder)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );



  }
  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        datePicked.text = DateFormat('dd.MM.yyyy').format(picked);
        lastTime = picked;
      });
    }
  }
}
