import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FolderImagesPage extends StatelessWidget {
  final String folderName;

  const FolderImagesPage({Key? key, required this.folderName})
      : super(key: key);

  Future<List<String>> fetchImageUrls() async {
    try {
      ListResult result =
          await FirebaseStorage.instance.ref('Images/$folderName/').listAll();
      List<String> urls = await Future.wait(
          result.items.map((ref) async => await ref.getDownloadURL()).toList());
      print("Fetched URLs for $folderName: $urls"); // Debugging
      return urls;
    } catch (e) {
      print("Error fetching images for $folderName: $e");
      return []; // Return an empty list on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folderName.toUpperCase()),
        centerTitle: true,
      ),
      body: FutureBuilder<List<String>>(
        future: fetchImageUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            print(
                "Error or no data in FutureBuilder (images): ${snapshot.error}");
            return Center(child: const Text("Error loading images"));
          } else {
            final urls = snapshot.data ?? [];
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: urls.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    urls[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error_outline, color: Colors.red),

                      );
                    },
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
