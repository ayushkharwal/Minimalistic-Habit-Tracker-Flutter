import 'package:flutter/material.dart';
import 'package:habit_tracker/components/add_button.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/monthly_summary.dart';
import 'package:habit_tracker/components/my_alert_box.dart';
import 'package:habit_tracker/data/hive_database.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instance of database
  HabitDatabase db = HabitDatabase();

  final _myBox = Hive.box('Habit_Database');

  @override
  void initState() {
    // If there is no current habit list and it's 1st time opening the app, then create default data
    if (_myBox.get('CURRENT_HABIT_LIST') == null) {
      db.createDefaultData();
    }

    // If data already exists in data
    else {
      db.loadData();
    }

    // Updating the database
    db.updateDatabase();

    super.initState();
  }

  // checkboxTapped() function
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  // Add new Habit
  final _newHabitNameController = TextEditingController();
  void AddNewHabit() {
    // Show alert dialog for user to enter the new habit
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: saveNewHabit,
          onCancel: canelDialogBox,
          hintText: 'Enter habit name...',
        );
      },
    );
  }

  // Save Habit
  void saveNewHabit() {
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    _newHabitNameController.clear();
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  // Cancel Creating New Habit
  void canelDialogBox() {
    _newHabitNameController.clear();
    Navigator.of(context).pop();
  }

  // Open Habit Settings
  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: () => saveExistingHabit(index),
          onCancel: canelDialogBox,
          hintText: db.todaysHabitList[index][0],
        );
      },
    );
  }

  // Delete Habit
  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  // Save Existing Habit
  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    Navigator.pop(context);
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Today\'s List',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.orange[700],
      floatingActionButton: AddHabitButton(onPressed: AddNewHabit),
      body: ListView(
        children: [
          // Monthly summary heat map
          MonthlySummary(
              datasets: db.heatMapDataSet, startDate: _myBox.get('START_DATE')),

          // List of Habits
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todaysHabitList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                habitName: db.todaysHabitList[index][0],
                habitCompleted: db.todaysHabitList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),
                settingsTapped: (context) => openHabitSettings(index),
                deleteTapped: (context) => deleteHabit(index),
              );
            },
          ),
        ],
      ),
    );
  }
}
