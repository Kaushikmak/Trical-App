import 'package:flutter/material.dart';

class Tricaldrawer extends StatelessWidget {
  final String currentPage;

  const Tricaldrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: null,
          ),
          ListTile(
            leading: const Icon(
              Icons.home_filled,
              color: Colors.deepPurpleAccent,
            ),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
              if (currentPage != "home") {
                Navigator.pushNamed(context, '/home');
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.photo,
              color: Colors.deepPurpleAccent,
            ),
            title: const Text("Gallery"),
            onTap: () {
              Navigator.pop(context);
              if (currentPage != "gallery") {
                Navigator.pushNamed(context, '/gallery');
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.newspaper,
              color: Colors.deepPurpleAccent,
            ),
            title: const Text("News"),
            onTap: () {
              Navigator.pop(context);
              if (currentPage != "news") {
                Navigator.pushNamed(context, '/news');
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.calendar_month,
              color: Colors.deepPurpleAccent,
            ),
            title: const Text("Time Table"),
            onTap: () {
              Navigator.pop(context);
              if (currentPage != "timetable") {
                Navigator.pushNamed(context, '/timetable');
              }
            },
          ),
          Spacer(),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.deepPurpleAccent,
            ),
            title: const Text("Setting"),
            onTap: () {
              Navigator.pop(context);
              if (currentPage != "settings") {
                Navigator.pushNamed(context, '/settings');
              }
            },
          ),
        ],
      ),
    );
  }
}
