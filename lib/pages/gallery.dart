import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:trical/widgets/drawer_widget.dart';
import 'package:trical/widgets/imagefolder.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late Future<List<String>> _folderNames;

  @override
  void initState() {
    super.initState();
    _folderNames = fetchFolderNames();
  }

  // Fetch folder names from Firebase Storage
  Future<List<String>> fetchFolderNames() async {
    try {
      ListResult result =
          await FirebaseStorage.instance.ref('Images/').listAll();
      List<String> folders =
          result.prefixes.map((folderRef) => folderRef.name).toList();
      print("Fetched folders: $folders"); // Debugging
      return folders;
    } catch (e) {
      print("Error fetching folders: $e");
      return []; // Return an empty list on error
    }
  }

  void _openFolder(BuildContext context, String folderName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FolderImagesPage(folderName: folderName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gallery"),
        centerTitle: true,
      ),
      drawer: const Tricaldrawer(currentPage: 'gallery'),
      body: FutureBuilder<List<String>>(
        future: _folderNames,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            print("Error or no data in FutureBuilder: ${snapshot.error}");
            return Center(child: const Text("Error loading folders"));
          } else {
            final folderNames = snapshot.data ?? [];
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: folderNames.length,
              itemBuilder: (context, index) {
                final folderName = folderNames[index];
                final randomColor =
                    Colors.primaries[Random().nextInt(Colors.primaries.length)];
                return GestureDetector(
                  onTap: () => _openFolder(context, folderName),
                  child: Container(
                    color: randomColor,
                    alignment: Alignment.center,
                    child: Text(
                      folderName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
