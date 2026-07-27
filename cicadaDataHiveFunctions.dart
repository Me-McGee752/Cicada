import 'package:hive_flutter/hive_flutter.dart';
import 'package:cicada/cicadaDataHiveBoxConst.dart';

class CicadaDataHiveFunctions {
  // Box which will use to store the things
  static final energyPointBox = Hive.box(energyPointHiveBox);
  static void createEnergyPoint(Map data) {
    energyPointBox.add(data);
}
// Create or add multiple data in hive
  static void addAllEnergyPoints(List data) {
    energyPointBox.addAll(data);
}
  static List getAllEnergyPoints() {
    final data = energyPointBox.keys.map((key) {
        final value = energyPointBox.get(key);
        return {"key": key, "energy": value["energy"], "time": value["time"]};
    }).toList();

    return data.reversed.toList();
}

// Get data for particular user in hive
  static Map getEnergyPoint(int key) {
    return energyPointBox.get(key);
}
static updateEnergyPoint(int key, Map data) {
    energyPointBox.put(key, data);
  }

}
