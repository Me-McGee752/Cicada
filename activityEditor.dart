import 'package:flutter/material.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'activityHiveFunctions.dart';
import 'package:flutter/services.dart';
import 'NavigatorPage.dart';
//import 'scheduledActivity.dart';

int dropdownvalue = 60;

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // Local Variable Where we save
  // the hive data of current context
  double size = 0;
  List myHiveData = [];
  double _currentDiscreteSliderValue = 5;
  // TextFields' controllers for adding  or updating data
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
//  final TextEditingController _priorityController = TextEditingController();

  // To Update the data from Hive in local variable
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
        appBar: AppBar(
          title: const Text("Activities"),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          actions: <Widget> [
           InfoButton(Colors.white, "Press the 'Create Activity' button to add an activity for your todo-list."),
          ],
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   label: const Text("Add Activity"),
        //   icon: const Icon(Icons.add),
        //   onPressed: () {
        //     showForm(null);
        //   }
        // ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Add Data"),
          icon: const Icon(Icons.add),
          onPressed: () {
            activity(null);
          }
        ),
        body: Container(
          child: SingleChildScrollView(
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: 
            List.generate(myHiveData.length, (index) {
              final activityData = myHiveData[index];
              //print("Activity: ${activityData["activity"]}, Priority: ${activityData["priority"]} newPriority: ${activityData["newPriority"]}");
              return Dismissible(
                direction: DismissDirection.endToStart,
                onUpdate: (details) {
                  setState(() {
                    size = details.progress;
                  });
                },
                background: Card(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Icon(Icons.delete, color: Colors.white, size: 40),
                    ),
                  ),
                ),
              
                onDismissed: (direction) {
                  ActivityEditorHiveFunctions.activityBox.delete(activityData["key"]);
                  getHiveData();
                },
                key: Key(activityData["key"].toString()),
                child: Card(
                child: ListTile(
                  title: 
                    //Show Name of user stored in data base
                      Column( children: [
                      Text("Activity : ${activityData["activity"]}"),
                      Text("Duration : ${activityData["duration"]}"),
                      Text("Priority : ${activityData["priority"]}"),
                      ]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                                // To edit the data stored
                        IconButton(
                          onPressed: () {
                            activity(activityData["key"]);

                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                )
                );
            
            }
          ),
        ),
      ),
    )
      )
  );

  }

void activity(int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      // To find the existing item in our  local database
      final existingItem =
          myHiveData.firstWhere((element) => element['key'] == itemKey);
      _activityController.text = existingItem['activity'];
      _durationController.text = existingItem['duration'].toString();
      _currentDiscreteSliderValue = existingItem['priority'].toDouble();
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: 15,
                  left: 15,
                  right: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                    itemKey == null ? 'Create New Activity' : 'Update Activity',
                    style: const TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                       ),
                  )),
                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: InfoButton(Colors.black, "When ranking your activity's priority, a priority of 0 is least important, and a priority of 10 is the most important activity. The duration is how long you will need to complete this activity in minutes")
                  ),
                  const SizedBox(
                    height: 10
                  ),
                  Column(

                     children: [
                      const SizedBox(
                        height: 20
                        ),
                        Text(
                          'Activity Name:',
                          style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                          )
                        ),
                        TextField(
                          controller: _activityController,
                          decoration: const InputDecoration(
                          hintText: 'Ex: Chemistry HW',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 194, 153, 8),
                            fontSize: 15
                            )
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          'Rank activity priority out of 10: ',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black
                          )
                        ),
                  StatefulBuilder(
                    builder: (context, state) {
                      return Slider(
                        value: _currentDiscreteSliderValue,
                        onChanged: (double value) {
                          state(() {
                            _currentDiscreteSliderValue = value;
                          });
                        },
                        min: 0,
                        max: 10,
                        divisions: 10,
                        label: _currentDiscreteSliderValue.round().toString(),
                        activeColor: Colors.amber,
                        inactiveColor: Colors.amber,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                    'Duration(minutes):',
                    style: const TextStyle(fontSize: 20),
                  )
                  
                  ),
                  DropdownMenuTime(),
                  // TextField(
                  //   controller: _durationController,
                  //   decoration: const InputDecoration(hintText: 'Ex: 30'),
                  //   keyboardType: TextInputType.number,
                  //   inputFormatters: <TextInputFormatter>[
                  //     FilteringTextInputFormatter.digitsOnly
                  //   ],
                  
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  
                    ],
                           ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new item
                      if (itemKey == null) {
                        // print("priority: ${_currentDiscreteSliderValue.round().toString()}");
                        ActivityEditorHiveFunctions.createActivity({
                          "activity": _activityController.text,
                          "duration": dropdownvalue,
                          "priority": _currentDiscreteSliderValue.round()
                        });
                      }

                      // update an existing item
                      if (itemKey != null) {
                        ActivityEditorHiveFunctions.updateActivity(itemKey, {
                          "activity": _activityController.text,
                          "duration": dropdownvalue,
                          "priority": _currentDiscreteSliderValue.round()
                        });
                      }

                      // Clear the text fields
                      _activityController.text = '';
                      _durationController.text = '';

                      Navigator.of(context).pop(); // Close the bottom sheet
                      // To refresh the Data stored in Hive after updation
                      getHiveData();
                    },
                    child: Text(itemKey == null ? 'Submit' : 'Update'),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ));
  }
}

class DropdownMenuTime extends StatefulWidget {
  const DropdownMenuTime({super.key});

  @override
  State<DropdownMenuTime> createState() => _DropdownMenuTimeState();
}

class _DropdownMenuTimeState extends State<DropdownMenuTime> {
  //String dropdownvalue = 'Sunday';

  // List of items in our dropdown menu
  var items = [
      30,
      45,
      60,
      90,
      120,
  ];
  
  @override
  Widget build(BuildContext context) {
    return 
      DropdownButton(
          // Initial Value
        value: dropdownvalue,

          // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),

          // Array list of items
        items:
            items.map((int items) {
              return DropdownMenuItem(value: items, child: Text(items.toString()));
            }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
        onChanged: (int? newValue) {
          setState(() {
            dropdownvalue = newValue!;
          });
        },
      );
  }
}
