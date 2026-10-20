import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'activityHiveFunctions.dart';
import 'activityHiveBoxConst.dart';
import 'cicadaDataHiveBoxConst.dart';
import 'cicadaDataHiveFunctions.dart';
import 'activityEditor.dart';//change to activityPage.dart
import 'cicadaData.dart';
import 'todoList.dart';
import 'dart:developer';
//import 'chart.dart';
import 'activitiesPage.dart';
import 'package:firebase_core/firebase_core.dart';

double startTime = 0;
double endTime = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();
  await Hive.openBox(energyPointHiveBox);
  await Hive.openBox(activityEditorHiveBox);
  await Hive.openBox(scheduledActivityHiveBox);
  await Hive.openBox(sleepTimesHiveBox);
  await Hive.openBox(TodoListHiveBox);
  // Open the Hive box to store items

  runApp(const NavigatorPage(currentIndex: 0));
}


class NavigatorPage extends StatefulWidget {
  final int currentIndex;
  const NavigatorPage({super.key, required this.currentIndex});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState(this.currentIndex);
}

class _NavigatorPageState extends State<NavigatorPage> {
  int currentIndex;
  _NavigatorPageState(this.currentIndex);
  List myHiveData = [];
  void getHiveData() {
    myHiveData = SleepTimeHiveFunctions.getAllActivities();
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    // Update the initial data
    // when page is loading
    getHiveData();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 217, 0))
      ),
      home: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          destinations: [
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Todo List',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_handball),
            label: 'Activities',
          ),
          NavigationDestination(
            icon: Icon(Icons.battery_unknown),
            label: 'Cicada Data',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.timeline),
          //   label: 'Chart',
            
          // ),
        ],
        selectedIndex: currentIndex,
        ),
        body: IndexedStack(
          index: currentIndex,
          children: [
            TodoListPage(),
            ActivitiesPage(),
            CicadaDataScreen(),
            //ChartScreen(),
          ],
        )
      )   
    );
  }
}


class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.settings),
        color: Colors.white,
      
      onPressed: () {
        Navigator.of(context).push(Settings<void>());
      }
    );
  }
}
class Settings<T> extends PopupRoute<T> {
  List myHiveData = [];
  void getHiveData() {
    myHiveData = SleepTimeHiveFunctions.getAllActivities();
    setState(() {});
  }
  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);
  @override
  bool get barrierDismissible => true;
  @override
  String? get barrierLabel => 'Dismissible Dialog';
  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
  
  //Type ColorEntry = DropdownMenuEntry<ColorLabel>;
  //DropdownMenu breakLengthController = DropdownMenu(dropdownMenuEntries: [DropdownMenuEntry(), "5", "10", "15", "20", "25"]);
  Widget buildPage(
  BuildContext context,
  Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
  return Center(
        child: Column(
        children: [
        TimePickerStart(),
        TimePickerEnd(),
        UnconstrainedBox(
          child: Container(
            padding: const .all(20.0),
            decoration: BoxDecoration(
              borderRadius: .circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                
                
                ElevatedButton(
                  child: Text("Save"),
                  onPressed: () async {
                    print(startTime);
                    print(endTime);
                    if (SleepTimeHiveFunctions.getAllActivities().isEmpty){
                      SleepTimeHiveFunctions.createActivity({
                        "wakeUpTime": startTime,
                        "sleepTime": endTime,
                    }
                    
                    );
                    
                    } else {
                      SleepTimeHiveFunctions.updateActivity(
                        SleepTimeHiveFunctions.getAllActivities().first["key"],
                        {
                        "wakeUpTime": startTime,
                        "sleepTime": endTime,
                        }
                      );
                    }
                  print("hive stored!");
                  Navigator.of(context).pop(); // Close the bottom sheet
                      // To refresh the Data stored in Hive after updation
                  getHiveData();
                  }
                ),
              
              ]
          )
        )
    )
        
        ],
        ),
  );
  }
}


class TimePickerStart extends StatefulWidget {
  @override
  State<TimePickerStart> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePickerStart> {
  String? _selectedTimeStart;
  TimePickerEntryMode initalEntryMode = TimePickerEntryMode.inputOnly;
 
 Future<void> _show() async {
  final TimeOfDay? result = await showTimePicker(context: context, initialTime: TimeOfDay.now());

  if(result != null){
    setState((){
      _selectedTimeStart = result.format(context);
      startTime = result.hour + (result.minute/100);
    });
  }
 }

 @override
 Widget build(BuildContext context) {
  return 
  // Scaffold(
  //   body: Center(
  //     child: Text(
  //       _selectedTime != null ? _selectedTime! : 'Pick Time',
  //     ),
  //   ),
  //   floatingActionButton: 
    TextButton(
      onPressed: _show, //child: const Text('Picker'),
      child: 
      Text(
        _selectedTimeStart != null ? _selectedTimeStart! : 'Start Time'
      ),
    );
 }
}


class TimePickerEnd extends StatefulWidget {
  @override
  State<TimePickerEnd> createState() => _TimePickerStateEnd();
  
}

class _TimePickerStateEnd extends State<TimePickerEnd> {
  String? _selectedTimeEnd;
  TimePickerEntryMode initalEntryMode = TimePickerEntryMode.inputOnly;
  
 
 Future<void> _show() async {
  final TimeOfDay? result = await showTimePicker(context: context, initialTime: TimeOfDay.now());

  if(result != null){
    setState((){
      _selectedTimeEnd = result.format(context);
      endTime = result.hour + (result.minute/100);
    });
  }
 }

 @override
 Widget build(BuildContext context) {
  return 
  // Scaffold(
  //   body: Center(
  //     child: Text(
  //       _selectedTime != null ? _selectedTime! : 'Pick Time',
  //     ),
  //   ),
  //   floatingActionButton: 
    TextButton(
      onPressed: _show, //child: const Text('Picker'),
      child: 
      Text(
        _selectedTimeEnd != null ? _selectedTimeEnd! : 'End Time'
      ),
    );
 }
}

// // rip my child
// class TimePicker extends StatefulWidget {
//   String displayText;
//   double? time;
//   Object name;
//   ValueNotifier<String> selectedTime;
//   TimePicker(this.displayText, this.selectedTime, this.name);
//   @override
//   State<TimePicker> createState() => _TimePickerState(displayText, selectedTime);
// }

// class _TimePickerState extends State<TimePicker> {
//     //ValueNotifier<String> selectedTime;
//   double? time;
//   String displayText;
//   Object name;
//   _TimePickerState(this.displayText, this.name
//   //, this.selectedTime
//   );
//   TimePickerEntryMode entryMode = TimePickerEntryMode.inputOnly;

//  Future<void> _show() async {
//   final TimeOfDay? result = await showTimePicker(context: context, initialTime: TimeOfDay.now());
//   if(result != null){
//     setState((){
//       TimePicker.selectedTime.value = result.format(context);
//       selectedTime = result.format(context);
//       time = result.hour + (result.minute/100);
//     });
//   }
  
//  }

//  @override
//  Widget build(BuildContext context) {
//   return ValueListenableBuilder(
//     valueListenable: selectedTime, 

//     builder: (BuildContext context, value, Widget? child) {
//       return TextButton(
//       onPressed: _show, //child: const Text('Picker'),
//       child:
//        Column(
//         children: [
//         Text(
//         selectedTime != null ? this.displayText : this.displayText
//         ),
        
//         Text(
//           time != null ? selectedTime.value : ""
//         )
//       ]
    
//       ),
//     );
//     }

//     );
//   // Scaffold(
//   //   body: Center(
//   //     child: Text(
//   //       _selectedTime != null ? _selectedTime! : 'Pick Time',
//   //     )
//   //   ),
//   //   floatingActionButton: 
  
    
//  }
// }

