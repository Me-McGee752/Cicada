import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';  
import 'package:cicada/Hive_box_const.dart';
import 'package:cicada/homeScreen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();
  await Hive.openBox(userHiveBox);

  // Open the Hive box to store items

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       home: HomeScreen()
       );
  }
}
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // title: 'Flutter Demo',
//       // theme: ThemeData(
//       //   colorScheme: .fromSeed(seedColor: Colors.deepPurple),
//       // ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Circada app we need to think of an actual name for this app pronto')
//         ),
//         body: GuessInput(
//           onSubmitGuess: (guess) {
//             print(guess);
//           },
//         ),
//       ),
//     );
//   }
// }
// class GuessInput extends StatelessWidget {
//   GuessInput({super.key, required this.onSubmitGuess});

//   final void Function(String) onSubmitGuess;
//   final TextEditingController _activityController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//         ),
//       ),
      
//       controller: _activityController,
//       onSubmitted: (value) {
//         print(_activityController.text);
//         _activityController.clear();
//       },
//     );
//   }
// }

