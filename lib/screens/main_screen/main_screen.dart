import 'package:flutter/material.dart';
import 'dart:io' show Platform;

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
          child: Platform.isAndroid ||
                  Platform.isIOS ||
                  MediaQuery.of(context).size.width < 800
              ? Column(
                  children: [],
                )
              : Row(
                  children: [],
                ),
        ));
  }
}
