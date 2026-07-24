import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cicada/Hive_functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Local Variable Where we save
  // the hive data of current context
  List myHiveData = [];
  double _currentDiscreteSliderValue = 5;
  // TextFields' controllers for adding  or updating data
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _priorityController = TextEditingController();

  // To Update the data from Hive in local variable
  void getHiveData() {
    myHiveData = HiveFunctions.getAllUsers();
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Cicada"),
          backgroundColor: Colors.amber,
          foregroundColor: const Color.fromARGB(255, 255, 224, 132),
          actions: [
            // To refreah the Data stored in Hive
            IconButton(
              onPressed: () {
                getHiveData();
            },
                icon: const Icon(Icons.refresh),
              ),
            ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text("Add Data"),
          icon: const Icon(Icons.add),
          onPressed: () {
            showForm(null);
          }
        ),
        body: Column(
          children: 
            List.generate(myHiveData.length, (index) {
              final userData = myHiveData[index];
              print("Activity: ${userData["activity"]}, Priority: ${userData["priority"]} newPriority: ${userData["newPriority"]}");
              return Card(
                child: ListTile(
                  title: //Show Name of user stored in data base
                      Text("Activity : ${userData["activity"]}"),
                    subtitle: //Show Email of user stored in data base
                      Column(
                        children: [
                          Text("Priority : ${userData["priority"]}"),
                          const SizedBox(width: 10),
                          Text("New Priority : ${userData["newPriority"]}"),
                        ],
                      ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                                // To edit the data stored
                        IconButton(
                          onPressed: () {
                            showForm(userData["key"]);
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

void showForm(int? itemKey) async {
    // itemKey == null -> create new item
    // itemKey != null -> update an existing item

    if (itemKey != null) {
      // To find the existing item in our  local database
      final existingItem =
          myHiveData.firstWhere((element) => element['key'] == itemKey);
      _activityController.text = existingItem['activity'];
      _priorityController.text = existingItem['priority'];
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
                    itemKey == null ? 'Create New' : 'Update',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  )),
                  TextField(
                    controller: _activityController,
                    decoration: const InputDecoration(hintText: 'Activity'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _priorityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Priority'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Slider(
                    value: _currentDiscreteSliderValue,
                    onChanged: (double value) {
                      setState(() {
                        _currentDiscreteSliderValue = value;
                      });
                    },
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: _currentDiscreteSliderValue.round().toString(),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save new item
                      if (itemKey == null) {
                        print("newPriority: ${_currentDiscreteSliderValue.round().toString()}");
                        HiveFunctions.createActivity({
                          "activity": _activityController.text,
                          "priority": _priorityController.text,
                          "newPriority": _currentDiscreteSliderValue.round()
                        });
                      }

                      // update an existing item
                      if (itemKey != null) {
                        HiveFunctions.updateActivity(itemKey, {
                          "activity": _activityController.text,
                          "priority": _priorityController.text,
                          "newPriority": _currentDiscreteSliderValue.round()
                        });
                      }

                      // Clear the text fields
                      _activityController.text = '';
                      _priorityController.text = '';

                      Navigator.of(context).pop(); // Close the bottom sheet
                      // To refresh the Data stored in Hive after updation
                      getHiveData();
                    },
                    child: Text(itemKey == null ? 'Create New' : 'Update'),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ));
  }
}
