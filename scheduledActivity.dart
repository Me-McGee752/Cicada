import 'package:flutter/material.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'activityHiveFunctions.dart';

bool light = false;

class ScheduledActivityScreen extends StatefulWidget {
  const ScheduledActivityScreen({super.key});

  @override
  State<ScheduledActivityScreen> createState() => _ScheduledActivityScreenState();
}

class _ScheduledActivityScreenState extends State<ScheduledActivityScreen> {
  // Local Variable Where we save
  // the hive data of current context
  List myHiveData = [];
  double _currentDiscreteSliderValue = 5;
  // TextFields' controllers for adding  or updating data
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();

  // To Update the data from Hive in local variable
  void getHiveData() {
    myHiveData = ScheduledActivityHiveFunctions.getAllActivities();
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
            scheduledActivity(null);
          }
        ),
        body: Column(
          children: 
            List.generate(myHiveData.length, (index) {
              final scheduledActivityData = myHiveData[index];
              print("Activity: ${scheduledActivityData["activity"]}, Day of Week: ${scheduledActivityData["dayOfWeek"]}, Repeatable: ${scheduledActivityData["repeatable"]}");
              return Card(
                child: ListTile(
                  title: 
                    //Show Name of user stored in data base
                      Column( children: [
                      Text("Scheduled Activity : ${scheduledActivityData["activity"]}"),
                      Text("Day of Week : ${scheduledActivityData["dayOfWeek"]}"),  
                      //Text("Start Time : ${scheduledActivityData["startTime"]}"),
                      //Text("End Time : ${scheduledActivityData["endTime"]}"),
                      Text("Repeatable : ${scheduledActivityData["repeatable"]}"),
                      ]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                                // To edit the data stored
                        IconButton(
                          onPressed: () {
                            scheduledActivity(scheduledActivityData["key"]);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                );
            }
          ),
        ),
      ),
    );
  }



void scheduledActivity(int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      // To find the existing item in our  local database
      final existingItem =
          myHiveData.firstWhere((element) => element['key'] == itemKey);
      _activityController.text = existingItem['activity'];
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
                    itemKey == null ? 'New Activity' : 'Update',
                    style: const TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                        ),
                  )),
                  const SizedBox(
                    height: 10
                  ),
                  Row(
                    children: [
                      Text(
                        'Click if the activity repeats weekly: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                        )
                      ),
                      ActivitySwitch()
                    ]
                  ),

                  Column(
                  children:[
                    const SizedBox(
                      height: 30
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
                        hintText: 'Ex: Chemistry Class',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 194, 153, 8),
                          fontSize: 15
                          )
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      DropdownMenuWeek(),
                      const SizedBox (height: 50),
                      
                      const SizedBox(
                        height: 50,
                      )
                    ]
                  ),

                  ElevatedButton(
                    onPressed: () async {
                    // Save new item
                    if (itemKey == null) {
                    print("priority: ${_currentDiscreteSliderValue.round().toString()}");
                    ScheduledActivityHiveFunctions.createActivity({
                      "activity": _activityController.text,
                      "dayOfWeek": DropdownMenuWeek(),
                      //"startTime": 
                      //"endTime":
                      "repeatable": light.toString(),
                      });
                    }

                    // update an existing item
                    if (itemKey != null) {
                      ScheduledActivityHiveFunctions.updateActivity(itemKey, {
                        "activity": _activityController.text,
                        "dayOfWeek": DropdownMenuWeek(),
                        //"startTime":
                        //"endTime":
                        "repeatable": light.toString(),
                        });
                      }

                  // Clear the text fields
                  _activityController.text = '';
                  _priorityController.text = '';
                  Navigator.of(context).pop(); // Close the bottom sheet
                  // To refresh the Data stored in Hive after updation
                    getHiveData();
                  },
                  child: Text(
                              itemKey == null ? 'Create New' : 'Update',
                              selectionColor: Color.fromARGB(255, 194, 153, 8)

                  ),
                ),
                const SizedBox(
                  height: 15,
                )
                ],
              ),
            ));
  }



  }



class ActivitySwitch extends StatefulWidget {
  const ActivitySwitch({super.key});

  @override
  State<ActivitySwitch> createState() => _ActivitySwitchState();
}

class _ActivitySwitchState extends State<ActivitySwitch> {

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light,
      activeThumbColor: Colors.amber,
      onChanged: (bool value) {
        setState((){
          light = value;
        });
      }
    );
  }

}

class DropdownMenuWeek extends StatefulWidget {
  const DropdownMenuWeek({super.key});

  @override
  State<DropdownMenuWeek> createState() => _DropdownMenuWeekState();
}

class _DropdownMenuWeekState extends State<DropdownMenuWeek> {
  String dropdownvalue = 'Sunday';

  // List of items in our dropdown menu
  var items = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
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
            items.map((String items) {
              return DropdownMenuItem(value: items, child: Text(items));
            }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
        onChanged: (String? newValue) {
          setState(() {
            dropdownvalue = newValue!;
          });
        },
      );
  }
}
