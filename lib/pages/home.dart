import 'package:flutter/material.dart';
import 'package:trical/widgets/drawer_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.electric_bolt,
                color: Colors.amber,
              ),
              SizedBox(width: 8),
              Text(
                "TRICAL",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        drawer: const Tricaldrawer(
          currentPage: "home",
        ));
  }
}
