import 'package:hive_flutter/hive_flutter.dart';
import 'package:cicada/Hive_box_const.dart';

class HiveFunctions {
  // Box which will use to store the things
  static final userBox = Hive.box(userHiveBox);
  static void createActivity(Map data) {
    userBox.add(data);
}
// Create or add multiple data in hive
  static void addAllUser(List data) {
    userBox.addAll(data);
}
  static List getAllUsers() {
    final data = userBox.keys.map((key) {
        final value = userBox.get(key);
        return {"key": key, "activity": value["activity"], "length": value["length"], "priority": value['priority'], "newPriority": value['newPriority']};
    }).toList();

    return data.reversed.toList();
}

// Get data for particular user in hive
  static Map getActivity(int key) {
    return userBox.get(key);
}
static updateActivity(int key, Map data) {
    userBox.put(key, data);
  }

}