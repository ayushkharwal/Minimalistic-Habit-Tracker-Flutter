import 'package:flutter/material.dart';

class AddHabitButton extends StatelessWidget {
  final Function()? onPressed;

  AddHabitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      foregroundColor: Colors.grey.shade300,
      elevation: 14,
      child: Icon(
        Icons.add_rounded,
        color: Colors.white,
      ),
      backgroundColor: Colors.black,
    );
  }
}
