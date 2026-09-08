import 'package:flutter/material.dart';
import 'cicadaDataHiveBoxConst.dart';
import 'activityHiveFunctions.dart';
import 'activityHiveBoxConst.dart';
import 'chart.dart';
import 'package:fl_chart/fl_chart.dart';
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List myHiveData = [];
  List<FlSpot> average = averageGraph();
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
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Add Data"),
          icon: const Icon(Icons.add),
          onPressed: () {
            
          }
        ),
        appBar: AppBar(
          title: const Text("Todo"),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  TodoList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return const TodoListScreen();
  }
} 
  bool isBlocked(double time){
    //the time variable is in hour plus minutes in like base ten because claire is interesting
    List blocks = ScheduledActivityHiveFunctions.getAllActivities();
    //for (int block in blocks.key)


    return false;
  }
  double timeToEnergy(double time){
    //returns the interpolated energy for a specific time
    List points = averageGraph();
    points = [
      FlSpot(0,0),
      FlSpot(1,0.5),
      FlSpot(2,1),
      FlSpot(5,8),
      FlSpot(7,6),
      FlSpot(10,10),
      
    ];
    int lowx = 0;
    double lowy = 0;
    int highx = 0;
    double highy = 0;
    double lowSpace = 100;
    double highSpace = 100;
    for (FlSpot x in points){
      if (x.x <= time && (time - x.x) < lowSpace){
        lowx = x.x.toInt();
        lowy = x.y;
        lowSpace = time - x.x;
      }
      if (x.x >= time && (x.x - time) < highSpace){
        highx = x.x.toInt();
        highy = x.y;
        highSpace = x.x - time;
      }
    }
    if (lowx == highx){
      return lowy.toDouble();
    }
    print("low: $lowx high: $highx");
    //double gapx = (highx - lowx).toDouble();
    //double weight = (time-lowx)/(highx - lowx).toDouble();
    return ((time-lowx)/(highx - lowx).toDouble() * highy + ((1 - ((time-lowx)/(highx - lowx).toDouble())) * lowy));
    // //points[time.floor()].x;
    //points[(time + 1).floor()].x;
  }
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});
  
  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}
  
class _TodoListScreenState extends State<TodoListScreen> {
  // void timeToEnergy(int time){
  //   List points = averageGraph();
  //   int low = 0;
  //   int high = 0;
  //   for (FlSpot x in points){
  //     print(x);
  //   }
  //   //points[time.floor()].x;
  //   //points[(time + 1).floor()].x;
  // }
  @override
  Widget build(BuildContext context) {
    return const Center(
    child: 
      Column(
        
      )
    );
  }
}
void todoBottomSheet(){

}
