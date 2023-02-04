import 'package:flutter/material.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/pages/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Initialize hive
  await Hive.initFlutter();

  // Open Box (Box is like database)
  await Hive.openBox('Habit_Database');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.blueGrey),
      ),
      home: SplashScreen(),
    );
  }
}
