import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'activityHiveFunctions.dart';
import 'activityHiveBoxConst.dart';
import 'cicadaDataHiveBoxConst.dart';
//import 'cicadaDataHiveFunctions.dart';
//import 'activityEditor.dart';//change to activityPage.dart
import 'cicadaData.dart';
import 'todoList.dart';
//import 'chart.dart';
import 'activitiesPage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();
  await Hive.openBox(energyPointHiveBox);
  await Hive.openBox(activityEditorHiveBox);
  await Hive.openBox(scheduledActivityHiveBox);
  await Hive.openBox(sleepTimesHiveBox);
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
  @override
  TimePicker StartTimeController = TimePicker("Wake-Up Time");
  TimePicker EndTimeController = TimePicker("Bed Time");
  Widget buildPage(
  BuildContext context,
  Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
  return Center(

        child: UnconstrainedBox(
          child: Container(
            padding: const .all(20.0),
            decoration: BoxDecoration(
              borderRadius: .circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                StartTimeController,
                EndTimeController,
                ElevatedButton(
                  child: Text("Submit"),
                  onPressed: () async {
                    if (SleepTimeHiveFunctions.getAllActivities().isEmpty){
                      SleepTimeHiveFunctions.createActivity({
                        "wakeUpTime": StartTimeController.time,
                        "sleepTime": EndTimeController.time
                    }
                    
                    );
                    
                    } else {
                        SleepTimeHiveFunctions.updateActivity(
                        SleepTimeHiveFunctions.getAllActivities().first["key"],
                        {
                        "wakeUpTime": StartTimeController.time,
                        "sleepTime": EndTimeController.time,
                        }
                      );
                    }
                  Navigator.of(context).pop(); // Close the bottom sheet
                      // To refresh the Data stored in Hive after updation
                  getHiveData();
                  }
                ),
              ]
          )
        )
    )
  );
  }
}


class TimePicker extends StatefulWidget {
  String displayText;
  double? time;
  TimePicker(this.displayText, [this.time]);
  @override
  State<TimePicker> createState() => _TimePickerState(displayText, time);
}

class _TimePickerState extends State<TimePicker> {
  String? _selectedTime;
  double? time;
  String displayText;
  _TimePickerState(this.displayText, [this.time]);
  TimePickerEntryMode entryMode = TimePickerEntryMode.inputOnly;
 Future<void> _show() async {
  final TimeOfDay? result = await showTimePicker(context: context, initialTime: TimeOfDay.now());

  if(result != null){
    setState((){
      _selectedTime = result.format(context);
      time = result.hour + (result.minute/100);
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
       Column(
        children: [
        Text(
        _selectedTime != null ? this.displayText : this.displayText
        ),
        
        Text(
          time != null ? _selectedTime! : ""
        )
      ]
      
      ),
      
    );
 }
}
