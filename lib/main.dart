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
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseApi().initializeNotifications();

  } catch (e) {}
  runApp(const MyApp());
}

ThemeData buildAppTheme() {
  return ThemeData(
    // Color Scheme
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
      secondary: Colors.blueAccent,
    ),

    // Typography
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),

    // Component Themes
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 2,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),

    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    // General Properties
    useMaterial3: true,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:const HomePage(),
      theme: buildAppTheme(),
      darkTheme: ThemeData.dark().copyWith(
        // Custom dark theme configurations
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.light,
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
