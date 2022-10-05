import 'package:flutter/material.dart';
import 'package:forest_garbage_mapper/screens/main_screen/widgets/map_panel.dart';
import 'package:universal_platform/universal_platform.dart';

import 'package:forest_garbage_mapper/screens/main_screen/widgets/stats_panel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Garbage Mapper",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.lightGreen,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: UniversalPlatform.isAndroid ||
              UniversalPlatform.isIOS ||
                  MediaQuery.of(context).size.width < 800
              ? Column(
                  children: const [
                    MapPanel(),
                    SizedBox(height: 15,),
                    StatsPanel(isWideScreen: false)
                  ],
                )
              : Row(
                  children: const [
                    StatsPanel(isWideScreen: true,),
                    SizedBox(height: 15,),
                    MapPanel()
                  ],
                ),
        ));
  }
}
