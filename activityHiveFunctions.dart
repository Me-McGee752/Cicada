import 'package:hive_flutter/hive_flutter.dart';
import 'package:cicada/activityHiveBoxConst.dart';

class ActivityHiveFunctions {
  // Box which will use to store the things
  static final activityBox = Hive.box(activityHiveBox);
  static void createActivity(Map data) {
    activityBox.add(data);
}
// Create or add multiple data in hive
  static void addAllActivity(List data) {
    activityBox.addAll(data);
}
  static List getAllActivities() {
    final data = activityBox.keys.map((key) {
        final value = activityBox.get(key);
        return {"key": key, "activity": value["activity"], "length": value["length"], "priority": value['priority'], "newPriority": value['newPriority']};
    }).toList();

    return data.reversed.toList();
}

// Get data for particular user in hive
  static Map getActivity(int key) {
    return activityBox.get(key);
}
static updateActivity(int key, Map data) {
    activityBox.put(key, data);
  }

}
