import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cicada/activityHiveFunctions.dart';
import 'package:cicada/activityHiveBoxConst.dart';
import 'package:cicada/cicadaDataHiveBoxConst.dart';
import 'package:cicada/cicadaDataHiveFunctions.dart';
import 'package:cicada/activityEditor.dart';
import 'package:cicada/cicadaData.dart';
import 'package:cicada/todoList.dart';
import 'package:cicada/chart.dart';





Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();
  await Hive.openBox(energyPointHiveBox);
  await Hive.openBox(userHiveBox);
  // Open the Hive box to store items

  runApp(const Navigator());
}


class Navigator extends StatefulWidget {
  const Navigator({super.key});

  @override
  State<Navigator> createState() => _NavigatorState();
}

class _NavigatorState extends State<Navigator> {
  List myHiveData = [];
  void getHiveData() {
    myHiveData = ActivityHiveFunctions.getAllActivities();
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    // Update the initial data
    // when page is loading
    getHiveData();
  }
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          destinations: [
          NavigationDestination(
            icon: Icon(Icons.sports_handball),
            label: 'Activities',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Todo List',
          ),
          NavigationDestination(
            icon: Icon(Icons.battery_unknown),
            label: 'Cicada Data',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline),
            label: 'Chart',
          ),
        ],
        selectedIndex: currentIndex,
        ),
        body: IndexedStack(
          index: currentIndex,
          children: const [
            ActivityScreen(),
            TodoListScreen(),
            CicadaDataScreen(),
            ChartScreen(),
          ],
        )
      )   
    );
  }
}