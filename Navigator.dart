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
    myHiveData = ActivityEditorHiveFunctions.getAllActivities();
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
          children: const [
            TodoListScreen(),
            ActivitiesPage(),
            CicadaDataScreen(),
            //ChartScreen(),
          ],
        )
      )   
    );
  }
}
