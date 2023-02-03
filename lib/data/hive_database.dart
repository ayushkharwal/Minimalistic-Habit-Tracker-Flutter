import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Reference our box
final _myBox = Hive.box('Habit_Database');

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  // Create initial default data
  void createDefaultData() {
    todaysHabitList = [
      ['Running', false],
      ['Coding', false],
    ];

    _myBox.put('START_DATE', todaysDateFormatted());
  }

  // load data if it already exists
  void loadData() {
    // If it's a new day, get habit list from database
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get('CURRENT_HABIT_LIST');
      // Set all habit completed to false since it's a new day
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    }

    // if it's not a new day, load todays list
    else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  // update database
  void updateDatabase() {
    // Update todays entry
    _myBox.put(todaysDateFormatted(), todaysHabitList);

    // Update universal habit list in case it's changed (new habit added, edit habit, delete habit)
    _myBox.put('CURRENT_HABIT_LIST', todaysHabitList);

    // Calculate habit complete percentages for each day
    calculateHabitPercentages();

    // load heat map
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;

    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    // Key: 'PERCENTAGE_SUMMARY_yyyymmdd'
    // Value: string of 1dp number between 0.0 - 1.0
    _myBox.put('PERCENTAGE_SUMMARY_${todaysDateFormatted()}', percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get('START_DATE'));

    // Count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today and add each percentage to the dataset
    // 'PERCENTAGE_SUMMARY_yyyymmdd' will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(
          Duration(days: i),
        ),
      );

      double strength = double.parse(
        _myBox.get('PERCENTAGE_SUMMARY_${yyyymmdd}') ?? '0.0',
      );

      // Spliting the dateTime so it does worry about hours/mins/secs etc.
      // Year
      int year = startDate.add(Duration(days: i)).year;
      // Month
      int month = startDate.add(Duration(days: i)).month;
      // Day
      int day = startDate.add(Duration(days: i)).day;

      final percentageForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strength).toInt(),
      };

      heatMapDataSet.addEntries(percentageForEachDay.entries);
    }
  }
}
