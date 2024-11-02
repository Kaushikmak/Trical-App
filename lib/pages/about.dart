import 'package:flutter/material.dart';
import 'package:trical/widgets/drawer_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trical/widgets/webview_screen.dart'; // Import the WebViewScreen file

class About extends StatelessWidget {
  const About({super.key});

  // Navigate to WebViewScreen
  void _openWebView(String url, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        centerTitle: true,
      ),
      drawer: const Tricaldrawer(currentPage: "about"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.electric_bolt_outlined,
                  size: 60,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 24),
              // App Name
              Text(
                'Trical',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Version
              Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              // Description
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'The trical app connects students to timetables, course materials, and announcements—all in one place for easy, everyday access',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 32),
              // Contact Section
              const Text(
                'Contact & Social',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Contact Cards
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: const Text('kaushikmak35@gmail.com'),
                  onTap: () => _openWebView('https://www.example.com', context),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('GitHub'),
                  subtitle: const Text('github.com/Kaushikmak'),
                  onTap: () => _openWebView('https://www.example.com', context),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                child: ListTile(
                  leading: const FaIcon(FontAwesomeIcons.instagram),
                  title: const Text('Instagram'),
                  subtitle: const Text('@vnit_trical'),
                  onTap: () => _openWebView('https://www.example.com', context),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
