import 'package:flutter/material.dart';
import 'package:trical/widgets/drawer_widget.dart';

class Newspage extends StatelessWidget {
  const Newspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
      ),
      drawer: const Tricaldrawer(currentPage: "news"),
    );
  }
}
