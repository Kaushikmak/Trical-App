import 'package:flutter/material.dart';
import 'package:trical/widgets/drawer_widget.dart';

class Timetable extends StatelessWidget {
  const Timetable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Table"),
        centerTitle: true,
      ),
      drawer: const Tricaldrawer(currentPage: "timetable"),
    );
  }
}
