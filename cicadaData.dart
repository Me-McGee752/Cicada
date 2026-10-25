import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'cicadaDataHiveBoxConst.dart';
import 'cicadaDataHiveFunctions.dart';
import 'chart.dart';
import 'main.dart';
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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          title: const Text("Cicada Data"),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          actions: <Widget> [
           InfoButton(Colors.white, "First, rate your energy level from 0-10, where 0 is when you feel the least productive and 10 is when you feel the most productive.\n \nThen, press the check mark to lock it in.\n \nA minimum of two points are required to generate a todo-list"),
          ],
        ),
      body: 
      SingleChildScrollView(
        child: Column(
        children: <Widget> [
          SizedBox(
            height: 30
          ),
          ChartScreen(),
          SizedBox(
            height: 50,
          ),
          CicadaDataInputScreen(),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: (){
              print(averageGraph());
              print(averageGraph().contains(FlSpot(11, 5.4)));
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => NavigatorPage(currentIndex: 2)));
              CicadaDataHiveFunctions.createEnergyPoint({
                "energy": _currentDiscreteSliderValue,
                "time": DateTime.now().hour + (DateTime.now().minute/60),
              });
                  // setState((){
                  //   ChartScreen();
                  // });
                },
                color: Color.fromARGB(255, 14, 12, 3),
              ),
        ]
      )
      )
    );
  }
}

class CicadaDataInputScreen extends StatefulWidget {
  const CicadaDataInputScreen({super.key});

  @override
  State<CicadaDataInputScreen> createState() => _CicadaDataScreenInputState();
}
class _CicadaDataScreenInputState extends State<CicadaDataInputScreen> {
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
    return 
    //Container(
      Center(
        child: Column(
          //mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
              Text(
               'Rate your energy level out of 10',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.amber,
                )
              ),
              NumberSlide(),
              // IconButton(
              //   icon: const Icon(Icons.check),
              //   onPressed: (){
            
              //     CicadaDataHiveFunctions.createEnergyPoint({
              //       "energy": _currentDiscreteSliderValue,
              //       "time": DateTime.now().hour + (DateTime.now().minute/60),
              //     }
              //     );
   
              //   },
              //   color: Color.fromARGB(255, 14, 12, 3),
              // ),              
              
          ]
        ),
      );
    //);
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
    return 
    Slider(
    // ignore: deprecated_member_use
      value: _currentDiscreteSliderValue,
      max: 10,
      divisions: 10,
      label: _currentDiscreteSliderValue.round().toString(),
      activeColor: Colors.amber,
      thumbColor: Colors.amber,
      onChanged: (double value) {
        setState(() {
          _currentDiscreteSliderValue = value;
       });
      },
    );
  }
}
