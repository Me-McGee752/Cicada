import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'cicadaDataHiveFunctions.dart';
//import 'cicadaDataHiveBoxConst.dart';

List energyPoints = [];
//List<FlSpot> averageList = [];

void main() => runApp(const ChartScreen());

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}



class _ChartScreenState extends State<ChartScreen> {  
  
  //@override 
  //State<LineChart> createState() => _LineChart();
  void getHiveData() {
    energyPoints = CicadaDataHiveFunctions.getAllEnergyPoints();
    setState(() {});
  }
  
  @override
  void initState() {
      super.initState();
      getHiveData();
    }

  @override
  Widget build(BuildContext context) {
    return  
    //MaterialApp(
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 217, 0))
      // ),
      // home: 
      //Scaffold(
        // appBar: AppBar(
        //   title: const Text("Circadium Rhythm"),
        //   backgroundColor: Colors.amber,
        //   foregroundColor: Colors.white,
        // ),
        //body: 
        Center(child: 
        LineChartWidget(),
        );
      //);
    //);
  }
}

List<FlSpot> averageGraph(){
    List<FlSpot> averageList = [];
    for(int i = 0; i < 24; i++){
      int temp = 0;
      List<int> tempList = [];

      for(var e in energyPoints){
        if((e['time']+0.5).toInt() == i){
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




class _LineChart extends StatelessWidget {
  const _LineChart();


  

  
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
    spots: setUpList()
    //energyPoints.isEmpty ? [FlSpot(0, 0)] : setUpList(),
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
    spots: averageGraph()
    //energyPoints.isEmpty ? [FlSpot(0, 0)] : averageGraph(),
  );
}

class LineChartWidget extends StatefulWidget{
  @override
  State<LineChartWidget> createState() => _LineChartWidgetState(); 
}

class _LineChartWidgetState extends State<LineChartWidget>{
  @override
  Widget build(BuildContext context) {
    return //Container(
      //color: const Color.fromARGB(255, 255, 237, 183),
       const AspectRatio(
        aspectRatio: 1.25,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 25, left: 2.5, bottom: 10),
                child:
                 _LineChart(),
              ),
            ),
          ],
        ),
      );
    //);
  }
}
