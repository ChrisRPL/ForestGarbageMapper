import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forest_garbage_mapper/services/implementations/drone_service.dart';
import 'package:forest_garbage_mapper/services/implementations/garbage_point_service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forest_garbage_mapper/screens/main_screen/main_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => GarbagePointService()),
        ChangeNotifierProvider(create: (ctx) => DroneService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Forest Garbage Mapper',
        home: AnimatedSplashScreen(
            splash: Column(children: const [FaIcon(FontAwesomeIcons.map, color: Colors.white), SizedBox(height: 5,), Text("Forest Garbage Mapper", style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold
            ),)]),
            nextScreen: const MainScreen(),
            splashTransition: SplashTransition.slideTransition,
            pageTransitionType: PageTransitionType.rightToLeftWithFade,
            backgroundColor: Colors.lightGreen
        ),
      ),
    );
  }
}
