import 'package:flutter/material.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'activityHiveFunctions.dart';
import 'scheduledActivity.dart';

// bool light = false;

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // Local Variable Where we save
  // the hive data of current context
  List myHiveData = [];
  double _currentDiscreteSliderValue = 5;
  // TextFields' controllers for adding  or updating data
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();

  // To Update the data from Hive in local variable
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 217, 0))
      ),
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text("Activities"),
        //   backgroundColor: Colors.amber,
        //   foregroundColor: Colors.white,
        //   actions: [
        //     // To refreah the Data stored in Hive
        //     IconButton(
        //       onPressed: () {
        //         getHiveData();
        //     },
        //         icon: const Icon(Icons.refresh),
        //       ),
        //     ],
        // ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Add Data"),
          icon: const Icon(Icons.add),
          onPressed: () {
            activity(null);
          }
        ),
        body: Column(
          children: 
            List.generate(myHiveData.length, (index) {
              final activityData = myHiveData[index];
              print("Activity: ${activityData["activity"]}, Priority: ${activityData["priority"]} newPriority: ${activityData["newPriority"]}");
              return Card(
                child: ListTile(
                  title: 
                    //Show Name of user stored in data base
                      Column( children: [
                      Text("Activity : ${activityData["activity"]}"),
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
                );
            }
          ),
        ),
      ),
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
              child: 
                Column(
                  //mainAxisSize: MainAxisSize.min,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                      itemKey == null ? 'New Activity' : 'Update',
                      style: const TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                        ),
                      )
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
                          'Rate activity prority out of 10: ',
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
                              activeColor: Colors.amberAccent,
                              thumbColor: Colors.amberAccent
                            );
                          },
                        ),
                        const SizedBox(
                          height: 200,
                        ),
              ],
            ),

                  ElevatedButton(
                    onPressed: () async {
                    // Save new item
                    if (itemKey == null) {
                    print("priority: ${_currentDiscreteSliderValue.round().toString()}");
                    ActivityHiveFunctions.createActivity({
                      "activity": _activityController.text,
                      "priority": _currentDiscreteSliderValue.round()
                      });
                    }

                    // update an existing item
                    if (itemKey != null) {
                      ActivityHiveFunctions.updateActivity(itemKey, {
                        "activity": _activityController.text,
                        "priority": _currentDiscreteSliderValue.round()
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

