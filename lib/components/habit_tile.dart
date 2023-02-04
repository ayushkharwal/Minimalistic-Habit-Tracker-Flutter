import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  String habitName;
  bool habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext?)? settingsTapped;
  final Function(BuildContext?)? deleteTapped;

  HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            // settings option
            SlidableAction(
              onPressed: settingsTapped,
              backgroundColor: Colors.black,
              icon: Icons.settings_rounded,
              borderRadius: BorderRadius.circular(12),
            ),

            // Delete option
            SlidableAction(
              onPressed: deleteTapped,
              backgroundColor: Colors.red,
              icon: Icons.delete_rounded,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(42),
          ),
          child: Row(
            children: [
              // chechbox
              Checkbox(
                value: habitCompleted,
                onChanged: onChanged,
                activeColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              // Habit Name
              Text(
                habitName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
