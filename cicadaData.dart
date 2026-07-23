import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

final timeSet = List.empty(growable: true);
final dataSet = List.empty(growable: true);

//double _currentSliderValue = 20;
double _currentDiscreteSliderValue = 5;

void main() {
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cicadas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 217, 0))
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: 
            <Widget> [
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

