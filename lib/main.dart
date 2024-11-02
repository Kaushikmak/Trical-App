import 'package:flutter/material.dart';
import 'package:trical/pages/news.dart';
import 'pages/home.dart';
import 'pages/gallery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trical/api/firebase_api.dart';
import 'package:trical/pages/timetable.dart';
import 'package:trical/pages/about.dart';


Future<void> main() async {
  try {
    await Firebase.initializeApp();
    await FirebaseApi().initializeNotifications();
    WidgetsFlutterBinding.ensureInitialized();
  } catch (e) {}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:const HomePage(),
      routes: {
        '/gallery': (context) => const GalleryPage(),
        '/news': (context) => const NewsPage(),
        '/home': (context) => const HomePage(),
        '/timetable'  : (context) =>  const Timetable(),
        '/about'  : (context) =>  const About(),
      },
    );
  }
}
