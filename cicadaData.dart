import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'cicadaDataHiveBoxConst.dart';
import 'cicadaDataHiveFunctions.dart';
//import 'dart:developer' as developer;

final timeSet = List.empty(growable: true);
final dataSet = List.empty(growable: true);

//double _currentSliderValue = 20;
double _currentDiscreteSliderValue = 5;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();
  await Hive.openBox(energyPointHiveBox);

  // Open the Hive box to store items

  runApp(const CicadaDataApp());
}

class CicadaDataApp extends StatelessWidget {
  
  const CicadaDataApp({super.key});
    
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cicadas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 217, 0))
      ),
      home: CicadaDataScreen(),
    );
  }
}
class CicadaDataScreen extends StatefulWidget {
  const CicadaDataScreen({super.key});

  @override
  State<CicadaDataScreen> createState() => _CicadaDataScreenState();
}
class _CicadaDataScreenState extends State<CicadaDataScreen> {
  List myHiveData = [];
  void getHiveData() {
    myHiveData = CicadaDataHiveFunctions.getAllEnergyPoints();
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
    return Scaffold(
      appBar: AppBar(
          title: const Text("Cicada Data"),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
      body: Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
              Text(
               'Rate your energy level out of 10',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 230, 195, 0),
                )
              ),
              NumberSlide(),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: (){
                  dataSet.add(_currentDiscreteSliderValue);
                  timeSet.add(DateTime.now());
                  CicadaDataHiveFunctions.createEnergyPoint({
                    "energy": _currentDiscreteSliderValue,
                    "time": DateTime.now().hour + (DateTime.now().minute/60)
                  });
                  
                },
                color: Color.fromARGB(255, 255, 217, 0),
              ),              
              
          ]
        ),
      )
    );
  }
}




class NumberSlide extends StatefulWidget {
  const NumberSlide({
    super.key,
  });

  @override
  State<NumberSlide> createState() => _NumberSlideState();
}

class _NumberSlideState extends State<NumberSlide> {
  @override
  Widget build(BuildContext context) {
    return Slider(
    // ignore: deprecated_member_use
      value: _currentDiscreteSliderValue,
      max: 10,
      divisions: 10,
      label: _currentDiscreteSliderValue.round().toString(),
      activeColor: Color.fromARGB(255,255,217,0 ),
      thumbColor: Color.fromARGB(255, 255, 217, 0),
      onChanged: (double value) {
        setState(() {
          _currentDiscreteSliderValue = value;
       });
      },
    );
  }
}
