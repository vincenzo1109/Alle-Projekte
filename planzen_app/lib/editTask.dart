import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planzen_app/hive.dart';
import 'package:planzen_app/plant_task_service.dart';

class EditTask extends StatefulWidget {
  final int? plantId;
  final PlantTask? maybeEditTask;

  const EditTask({super.key, this.plantId, this.maybeEditTask});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Gießen';
  final TextEditingController _intervalController = TextEditingController(
    text: '7',
  );
  TextEditingController _titleController = TextEditingController();
String textButton = 'Aufgabe erstellen';

  // Kategorien mit Icons
  final Map<String, IconData> _categories = {
    'Gießen': Icons.water_drop,
    'Düngen': Icons.auto_awesome,
    'Umtopfen': Icons.layers,
    'Schneiden': Icons.content_cut,
    'sonstiges': Icons.add_sharp,
  };

  @override
  void initState() {
    super.initState();
    PlantTask? taskToEdit = widget.maybeEditTask;

    if (taskToEdit != null) {
      _selectedDate = taskToEdit.lastCompletion.add(
        Duration(days: taskToEdit.interval),
      );
      _selectedCategory = taskToEdit.whatToDo;
      _intervalController.text = taskToEdit.interval.toString();
      _titleController.text = taskToEdit.whatToDo;
      textButton = 'Aufgabe bearbeiten';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Neue Aufgabe")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          const Text(
            "Aufgabe wählen",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: _categories.keys.map((cat) {
              return ChoiceChip(
                label: Text(cat),
                selected: _selectedCategory == cat,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedCategory = cat);
                },
              );
            }).toList(),
          ),

          // 1. Titel Eingabe
          if (_selectedCategory == 'sonstiges') ...[
            const SizedBox(height: 25),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Was ist zu tun?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(_categories[_selectedCategory]),
              ),
            ),
            const SizedBox(height: 25),
          ],
          const SizedBox(height: 10),

          Card(
            elevation: 2,
            child: ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Erinnerung am"),
              subtitle: Text(
                "${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}",
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
          ),

          const SizedBox(height: 40),

          const Text(
            "Wiederholung",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: _intervalController,
            keyboardType: TextInputType.number, // Öffnet die Zifferntastatur
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Alle wie viele Tage? (opt.)',
              suffixText: 'Tage',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              prefixIcon: const Icon(Icons.repeat),
            ),
          ),

          const SizedBox(height: 25),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              String finalTaskName = _selectedCategory == 'sonstiges'
                  ? _titleController.text
                  : _selectedCategory;
              int intervalInteger = int.parse(_intervalController.text);
              final newTask = PlantTask(
                widget.plantId!,
                finalTaskName,
                intervalInteger,
                _selectedDate,
              );
              PlantTaskService.instance().insertTask(newTask);
              Navigator.pop(context, newTask);
            },
            icon: const Icon(Icons.add_task),
            label: Text(
              textButton,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
