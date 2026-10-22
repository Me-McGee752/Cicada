import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'activityHiveFunctions.dart';
import 'activityHiveBoxConst.dart';
import 'cicadaDataHiveBoxConst.dart';
//import 'cicadaDataHiveFunctions.dart';
import 'activityEditor.dart';//change to activityPage.dart
import 'cicadaData.dart';
import 'todoList.dart';
//import 'chart.dart';
//import 'activitiesPage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();
  await Hive.openBox(energyPointHiveBox);
  await Hive.openBox(activityEditorHiveBox);
  await Hive.openBox(TodoListHiveBox);
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
        colorSchemeSeed: Colors.amber,
        
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
            ActivityScreen(),
            CicadaDataScreen(),
            //ChartScreen(),
          ],
        )
      )   
    );
  }
}


class InfoButton extends StatelessWidget {
  final Color iconColor;
  final String infoText;
  InfoButton(this.iconColor, this.infoText);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info),
      color: iconColor,
      onPressed: () {
        Navigator.of(context).push(InfoPopupRoute<void>(iconColor, infoText));
      }
    );
  }
}

class InfoPopupRoute<T> extends PopupRoute<T> {
  Color iconColor;
  String infoText;
  InfoPopupRoute(this.iconColor, this.infoText);

  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);
  @override
  bool get barrierDismissible => true;
  @override
  String? get barrierLabel => "Dismissible Dialog";
  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
      Animation<double> secondaryAnimation,
  ) {
    return Center(
      child:
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: 448,
          ),
          child: 
          Container(
            padding: EdgeInsetsGeometry.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusGeometry.circular(10),
              color: Colors.white,
              ),
            child: 
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      infoText,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color.fromARGB(0, 255, 255, 255),
                      ),
                      softWrap: true,                     
                ),
              ])
            )
          )
        )
      )
    );
  }
}


// class SettingsButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//         icon: const Icon(Icons.settings),
//         color: Colors.white,    
//       onPressed: () {
//         Navigator.of(context).push(Settings<void>());
//       }
//     );
//   }
// }
// class Settings<T> extends PopupRoute<T> {
//   List myHiveData = [];
//   void getHiveData() {
//     myHiveData = SleepTimeHiveFunctions.getAllActivities();
//     setState(() {});
//   }
//   @override
//   Color? get barrierColor => Colors.black.withAlpha(0x50);
//   @override
//   bool get barrierDismissible => true;
//   @override
//   String? get barrierLabel => 'Dismissible Dialog';
//   @override
//   Duration get transitionDuration => const Duration(milliseconds: 300);
//   @override
//   TimePicker StartTimeController = TimePicker("Wake-Up Time");
//   TimePicker EndTimeController = TimePicker("Bed Time");
//   Widget buildPage(
//   BuildContext context,
//   Animation<double> animation,
//     Animation<double> secondaryAnimation,
//   ) {
//   return Center(
//         child: UnconstrainedBox(
//           child: Container(
//             padding: EdgeInsetsGeometry.all(20.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadiusGeometry.circular(10),
//               color: Colors.white,
//             ),
//             child: Column(
//               children: <Widget>[
//                 StartTimeController,
//                 EndTimeController,
//                 ElevatedButton(
//                   child: Text("Submit"),
//                   onPressed: () async {
//                     if (SleepTimeHiveFunctions.getAllActivities().isEmpty){
//                       SleepTimeHiveFunctions.createActivity({
//                         "wakeUpTime": StartTimeController.time,
//                         "sleepTime": EndTimeController.time
//                     }              
//                     );                 
//                     } else {
//                         SleepTimeHiveFunctions.updateActivity(
//                         SleepTimeHiveFunctions.getAllActivities().first["key"],
//                         {
//                         "wakeUpTime": StartTimeController.time,
//                         "sleepTime": EndTimeController.time,
//                         }
//                       );
//                     }
//                   Navigator.of(context).pop(); // Close the bottom sheet
//                       // To refresh the Data stored in Hive after updation
//                   getHiveData();
//                   }
//                 ),
//               ]
//           )
//         )
//     )
//   );
//   }
// }
