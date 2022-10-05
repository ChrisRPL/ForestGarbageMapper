import 'package:flutter/material.dart';

class StatsPanel extends StatefulWidget {
  final bool isWideScreen;

  const StatsPanel({Key? key, required this.isWideScreen}) : super(key: key);

  @override
  State<StatsPanel> createState() => _StatsPanelState();
}

class _StatsPanelState extends State<StatsPanel> {
  @override
  Widget build(BuildContext context) {
    return widget.isWideScreen ? Column() : Row();
  }
}
