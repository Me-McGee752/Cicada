import 'package:flutter/material.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'activityHiveFunctions.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController _durationController = TextEditingController();

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
        appBar: AppBar(
          title: const Text("Activities"),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Add Activity"),
          icon: const Icon(Icons.add),
          onPressed: () {
            showForm(null);
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
              return Card(
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
                            showForm(activityData["key"]);
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
    )
      )
  );

  }

void showForm(int? itemKey) async {
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
                        fontSize: 22, fontWeight: FontWeight.w600),
                  )),
                  TextField(
                    controller: _activityController,
                    decoration: const InputDecoration(hintText: 'Activity'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                 TextField(
                    controller: _durationController,
                    decoration: const InputDecoration(hintText: 'Duration (minutes)'),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  
                  ),
                  Center(
                      child: Text(
                    'Priority',
                    style: const TextStyle(fontSize: 16),
                  )),
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
                        label: _currentDiscreteSliderValue.round().toString()
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new item
                      if (itemKey == null) {
                        // print("priority: ${_currentDiscreteSliderValue.round().toString()}");
                        ActivityHiveFunctions.createActivity({
                          "activity": _activityController.text,
                          "duration": int.parse(_durationController.text),
                          "priority": _currentDiscreteSliderValue.round()
                        });
                      }

                      // update an existing item
                      if (itemKey != null) {
                        ActivityHiveFunctions.updateActivity(itemKey, {
                          "activity": _activityController.text,
                          "duration": int.parse(_durationController.text),
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
                    child: Text(itemKey == null ? 'Create' : 'Update'),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ));
  }
}
