import 'package:flutter/material.dart';
//import 'package:hive_flutter/hive_flutter.dart';
import 'activityHiveFunctions.dart';
import 'activityEditor.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 217, 0))),
      home: ActivitiesPageTab()
    );
  }
}

class ActivitiesPageTab extends StatelessWidget {
  const ActivitiesPageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child:
       Scaffold(
        appBar: AppBar(
          title: const Text("Activities"),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Activities"),
              Tab(
                text: "Scheduled Activites"
              ),
            ]
          )
        ),
        body: TabBarView(
          children:<Widget>[
            ActivityScreen(),
            Center(child: Text('HELP ME!!!!'))
          ]
        )
      )   
    );
  }
}
