import 'package:flutter/material.dart';
//import 'cicadaDataHiveBoxConst.dart';
import 'activityHiveFunctions.dart';
//import 'activityHiveBoxConst.dart';
import 'chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'NavigatorPage.dart';

double startTime = 0;
double endTime = 0;
List todoList = [];
List studyActivities = [];
List scheduledActivities = [];
//List sortList = [];
List activList = studyActivities;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  //List myHiveData = [];
  List<FlSpot> average = averageGraph();
  void getHiveData() {
    studyActivities = ActivityEditorHiveFunctions.getAllActivities();
    scheduledActivities = ScheduledActivityHiveFunctions.getAllActivities();
    todoList = TodoListHiveFunctions.getAllActivities();
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
        appBar: AppBar(
          title: const Text("Todo"),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          
        ),
        body: 
        Column(
        children:     
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TimePickerStart(),
              SizedBox(width: 20),
              Text(
                "to",
                style: TextStyle(
                  fontSize: 17,
                  color: const Color.fromARGB(255, 148, 126, 0)
                ),

              ),
              SizedBox(width:20),
              TimePickerEnd(),
              SizedBox(width: 20),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  //activList = (sort(activList, timeToEnergy(3)));
                  getHiveData();
                  todoListGenerator();
                },
              )
            ] 
          ),
                    
        ]
        )
      )
    );
  }
}



List sort(List sList, double compatValue){
  for(int a = 0; a < sList.length; a++)
  {
    for(int s = a + 1; s < sList.length; s++)
    {
      Object temp = 0;
      double aValue = compatValue/sList[a]["priority"];
      double sValue = compatValue/sList[s]["priority"];
      if(sValue > aValue){
        temp = sList[a];
        sList[a] = sList[s];
        sList[s] = temp;
      }
    }
  }
  return sList;
}

List todoListGenerator(){
  print("todoListgen is a go              I                     I                  I                     I            I           I                 I                 I             I huge gap (:");
  List activList = studyActivities;
  
  double productivity = 0;
  todoList = [];
  //List compatability = [];
  //print("startTime: $startTime");
  double timeTracker = startTime;
  // print("TodoListHiveFunction.TodoListBox pre delete:");
  // print(TodoListHiveFunctions.getAllActivities());
  //this works i tested it it deletes all the things in todolistbox
  for(var a in TodoListHiveFunctions.getAllActivities()){
    TodoListHiveFunctions.TodoListBox.delete(a["key"]);
  }
  // print("TodoListHiveFunction.TodoListBox post delete:");
  // print(TodoListHiveFunctions.getAllActivities());
  
  while(timeTracker <= endTime && activList.isNotEmpty){
    print("operation while loop is a go");
    for(var s in scheduledActivities){
      //gets rid of times there are activietes scheduled
      if(s['startTime'] <= timeTracker && s['endTime'] > timeTracker){
        timeTracker += (s['endTime'] - s['startTime']);
        if(!s['repeatable']){
          scheduledActivities.remove(s);
        }
      }
    }

      productivity = timeToEnergy(timeTracker);
      print("activList presort: $activList");
      activList = sort(activList, productivity);
      print("activList postsort: $activList");
      var activity = activList[0];
      // for(var a in activList){
      //   if(productivity == a["priority"]){
          //print("activity duration:");
          //print(activity["duration"]);
          TodoListHiveFunctions.createActivity({
            "activity": activity["priority"],
            "startTime": startTime,
            "endTime": (startTime + (activity["duration"]/60))
          });
          timeTracker += activity["duration"]/60;
          print("activList pre remove: $activList");
          activList.remove(activity);
          print("activList post remove: $activList");
          //activList = [];
          // break;
      //   }
      // }
    print("timeTracker: $timeTracker EndTime: $endTime");
  }
  todoList = TodoListHiveFunctions.getAllActivities();
  print(todoList);

  return todoList;
  // List.generate(todoList.length, (index) {
  //   final todoListData = todoList[index];
  //     print("Activity: ${todoListData["activity"]}, Start Time: ${todoListData["startTime"]}");
  //       return Card(
  //         child: ListTile(
  //           title: 
  //           //Show Name of user stored in data base
  //             Column( children: [
  //               Text("Activity : ${todoListData["activity"]}"),
  //               Text("Start Time: ${todoListData["startTime"]}"),  
  //               Text("End Time : ${todoListData["endTime"]}"),
  //               ]),
  //           trailing: Row(
  //             mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 // To check off activity
  //               IconButton(
  //                 onPressed: () {
  //                   TodoListHiveFunctions.TodoListBox.delete(todoListData["key"]);
  //                   },
  //                 icon: const Icon(Icons.check_box),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     }
  //   );
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
    FlSpot(13, 8),
    FlSpot(14,7),
    FlSpot(15, 6),

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
  //print("low: $lowx high: $highx");
  //double gapx = (highx - lowx).toDouble();
  //double weight = (time-lowx)/(highx - lowx).toDouble();
  return ((time-lowx)/(highx - lowx).toDouble() * highy + ((1 - ((time-lowx)/(highx - lowx).toDouble())) * lowy));
  // //points[time.floor()].x;
  //points[(time + 1).floor()].x;
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
    TextButton(
      onPressed: _show, 
      child: 
      Text(
        _selectedTimeStart != null ? _selectedTimeStart! : 'Study Start Time',
        style: TextStyle(
          fontSize: 17,
          color: const Color.fromARGB(255, 148, 126, 0)
        ),
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
  TimePickerEntryMode entryMode = TimePickerEntryMode.inputOnly;
  
 
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
    TextButton(
      onPressed: _show, 
      child: 
      Text(
        _selectedTimeEnd != null ? _selectedTimeEnd! : 'Study End Time',
        style: TextStyle(
          fontSize: 17,
          color: const Color.fromARGB(255, 148, 126, 0)
        )
      ),
    );
 }
}
