import 'package:flutter/material.dart';
import 'package:trical/widgets/drawer_widget.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      drawer: const Tricaldrawer(currentPage: "settings"),
    );
  }
}
