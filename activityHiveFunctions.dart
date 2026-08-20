import 'package:hive_flutter/hive_flutter.dart';
import 'package:cicada/activityHiveBoxConst.dart';


class ActivityEditorHiveFunctions {
  // Box which will use to store the things
  static final activityBox = Hive.box(activityEditorHiveBox);
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
        return {"key": key, "activity": value["activity"], "duration": value["duration"], "priority": value['priority']};
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



class ScheduledActivityHiveFunctions {
  // Box which will use to store the things
  static final ScheduledActivityBox = Hive.box(scheduledActivityHiveBox);
  static void createActivity(Map data) {
    ScheduledActivityBox.add(data);
}
// Create or add multiple data in hive
  static void addAllActivity(List data) {
    ScheduledActivityBox.addAll(data);
}
  static List getAllActivities() {
    final data = ScheduledActivityBox.keys.map((key) {
        final value = ScheduledActivityBox.get(key);
        return {"key": key, "activity": value["activity"], "dayOfWeek": value["dayOfWeek"], "startTime": DateTime.parse(value['startTime']), "endTime": DateTime.parse(value['endTime']), "repeatable": bool.fromEnvironment(value['repeatable'])};
    }).toList();

    return data.reversed.toList();
}

// Get data for particular user in hive
  static Map getActivity(int key) {
    return ScheduledActivityBox.get(key);
}
static updateActivity(int key, Map data) {
    ScheduledActivityBox.put(key, data);
  }

}
