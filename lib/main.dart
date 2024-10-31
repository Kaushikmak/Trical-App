import 'package:flutter/material.dart';
import 'package:trical/pages/news.dart';
import 'pages/home.dart';
import 'pages/gallery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trical/api/firebase_api.dart';
import 'package:trical/pages/timetable.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    await FirebaseApi().initializeNotifications();
  } catch (e) {}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/gallery': (context) => const GalleryPage(),
        '/news': (context) => const Newspage(),
        '/home': (context) => const HomePage(),
        '/timetable'  : (context) =>  const Timetable(),
      },
    );
  }
}
