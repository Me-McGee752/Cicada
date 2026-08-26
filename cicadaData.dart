import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'cicadaDataHiveBoxConst.dart';
import 'cicadaDataHiveFunctions.dart';
import 'package:fl_chart/fl_chart.dart';
//import 'dart:developer' as developer;

final timeSet = List.empty(growable: true);
final dataSet = List.empty(growable: true);
//class Argh {
  ValueNotifier<int> energyPointsNotifier = ValueNotifier<int>(1);
void energyPointsChanged() {
  energyPointsNotifier.value = -1 * energyPointsNotifier.value;
}
//}
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
      home: 
      Column(
        children: [
          CicadaDataScreen(),
          // ChartScreen(),
        ],
      ),
    );
  }
}
class CicadaDataScreen extends StatefulWidget {
  const CicadaDataScreen({super.key});

  @override
  State<CicadaDataScreen> createState() => _CicadaDataScreenState();
}
class _CicadaDataScreenState extends State<CicadaDataScreen> {
  // final Argh argh = Argh();
  final _LineChart _lineChart = const _LineChart();
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
                  setState(() {
                    energyPointsChanged();
                  });
                  
                },
                color: Color.fromARGB(255, 255, 217, 0),
              ),              
              Container(
                height: 300,
                width: 600,
                alignment: Alignment.center,
                child: ValueListenableBuilder<int>(
            valueListenable: energyPointsNotifier,
            builder: (BuildContext context, int value, Widget? child) {
              return _LineChart();
           }),
              )
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

List energyPoints = [];

// class ChartScreen extends StatefulWidget {
//   const ChartScreen({super.key});

//   @override
//   State<ChartScreen> createState() => ChartScreenState();
// }

// class ChartScreenState extends State<ChartScreen> {  
//   Argh argh = Argh();
//   // @override 
//   // State<LineChart> createState() => _LineChart();
//   void getHiveData() {
//     energyPoints = CicadaDataHiveFunctions.getAllEnergyPoints();
//     setState(() {});
//   }
  
//   @override
//   void initState() {
//       super.initState();
//       getHiveData();
//     }
   
//   // void energyPointsChanged() {
//   //   energyPointsNotifier.value = !energyPointsNotifier.value;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return  MaterialApp(
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 217, 0))
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Circadium Rhythm"),
//           backgroundColor: Colors.amber,
//           foregroundColor: Colors.white,
//         ),
//         body: Center(
//           child: ValueListenableBuilder<int>(
//             valueListenable: argh.energyPointsNotifier,
//             builder: (BuildContext context, int value, Widget? child) {
//               // setState(() {
//               //   getHiveData();
//               // });
//               energyPoints = CicadaDataHiveFunctions.getAllEnergyPoints();
//               //getHiveData();
//               return const LineChartWidget();
            
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }






class _LineChart extends StatefulWidget {
  const _LineChart();

  @override
  State<_LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<_LineChart> {
  List<FlSpot> averageGraph(){
    List<FlSpot> averageList = [];
    for(int i = 0; i < 24; i++){
      int temp = 0;
      List<int> tempList = [];

      for(var e in energyPoints){
        if(e['time'].toInt() == i){
          tempList.add(e['energy'].toInt());
        }
      }

        if(tempList.isNotEmpty){
          double averageDataPoint = 0;
          
          for(int y = 0; y < tempList.length; y++){
            temp += tempList[y];
          }

          averageDataPoint = (temp/(tempList.length));


          averageList.add(FlSpot(
            (i as num).toDouble(),
            (averageDataPoint as num).toDouble(),
          ));
        }
      }
    return averageList;
  }

  
  List<FlSpot> setUpList() {
    List<FlSpot> pointList = [];
    for (var e in energyPoints) {
      pointList.add(FlSpot(
        (e['time'] as num).toDouble(),
        (e['energy'] as num).toDouble(),
      ));
    }
    return pointList;
  }
  
  @override
  Widget build(BuildContext context) {
    return LineChart(lineChartData);
  }

  LineChartData get lineChartData => LineChartData(
    lineTouchData: lineTouchData(),
    gridData: gridData(),
    titlesData: titlesData(),
    borderData: borderData(),
    lineBarsData: lineBarsData(),
    minX: 0,
    maxX: 24,
    minY: 0,
    maxY: 10,
  );

  LineTouchData lineTouchData() => LineTouchData(
      handleBuiltInTouches: true
    );

  FlGridData gridData() => FlGridData(
    show: true,
    drawVerticalLine: true,
    horizontalInterval: 1,
    verticalInterval: 1,
    getDrawingHorizontalLine: (double _) => FlLine(
      color: const Color.fromARGB(255, 255, 230, 156).withValues(),
      strokeWidth: 1,
    ),
    getDrawingVerticalLine: (double _) => FlLine(
      color: const Color.fromARGB(255, 255, 230, 156).withValues(),
      strokeWidth: 1,
    ),
  );

  FlTitlesData titlesData() => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles(),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  SideTitles bottomTitles() => SideTitles(
    getTitlesWidget: bottomTitleWidgets,
    interval: 1,
    reservedSize: 32,
    showTitles: true,
  );

  SideTitleWidget bottomTitleWidgets(double value, TitleMeta meta) {
    String text = switch (value.toInt()) {
      0 => '12am',
      // 1 => '1am',
      // 2 => '2am',
      3 => '3am',
      // 4 => '4am',
      // 5 => '5am',
      6 => '6am',
      // 7 => '7am',
      // 8 => '8am',
      9 => '9am',
      // 10 => '10am',
      // 11 => '11am',
      12 => '12pm',
      // 13 => '1pm',
      // 14 => '2pm',
      15 => '3pm',
      // 16 => '4pm',
      // 17 => '5pm',
      18 => '6pm',
      // 19 => '7pm',
      // 20 => '8pm',
      21 => '9pm',
      // 22 => '10pm',
      // 23 => '11pm',
      _ => '',
    };

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.amber,
        ),
      ),
    );
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    interval: 1,
    reservedSize: 40,
    showTitles: true,
  );

  Text leftTitleWidgets(double value, TitleMeta meta) {
    String text = switch (value.toInt()) {
      1 => '1',
      2 => '2',
      3 => '3',
      4 => '4',
      5 => '5',
      6 => '6',
      7 => '7',
      8 => '8',
      9 => '9',
      10 => '10',
      _ => '',
    };

    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: Colors.amber),
    );
  }

  FlBorderData borderData() => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(
        color: Colors.amber,
        width: 4,
      ),
      left: const BorderSide(
        color: Colors.amber,
        width: 4,
        ),
      right: const BorderSide(color: Colors.transparent),
      top: const BorderSide(color: Colors.transparent),
    ),
  );

  List<LineChartBarData> lineBarsData() => [
        averageData(),
        scatterFullData(),
      ];


  LineChartBarData scatterFullData() => LineChartBarData(
    isCurved: true,
    curveSmoothness: 0,
    color: const Color.fromARGB(255, 255, 166, 0),
    barWidth: 0,
    preventCurveOverShooting: true,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    spots: 
    energyPoints.isEmpty ? [FlSpot(0, 0)] : setUpList(),
  );
  


  LineChartBarData averageData() => LineChartBarData(
    isCurved: true,
    curveSmoothness: .2,
    color: Colors.amber,
    barWidth: 5,
    preventCurveOverShooting: true,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    spots: 
    energyPoints.isEmpty ? [FlSpot(0, 0)] : averageGraph(),
  );
}


class LineChartWidget extends StatefulWidget{
  const LineChartWidget({super.key});
  
  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: const Color.fromARGB(255, 255, 237, 183),
      child: const AspectRatio(
        aspectRatio: 1.25,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 25, left: 2.5, bottom: 10),
                child: _LineChart(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
