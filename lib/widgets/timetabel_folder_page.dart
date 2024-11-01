import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class TimetableFolderPage extends StatelessWidget {
  final String folderName;

  const TimetableFolderPage({Key? key, required this.folderName}) : super(key: key);

  // Fetch files (e.g., PDFs or images) inside the selected timetable folder
  Future<List<String>> fetchFileUrls() async {
    try {
      ListResult result = await FirebaseStorage.instance.ref('Timetable/$folderName/').listAll();
      List<String> urls = await Future.wait(result.items.map((ref) async => await ref.getDownloadURL()).toList());
      return urls;
    } catch (e) {
      print("Error fetching files for $folderName: $e");
      return []; // Return an empty list on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(folderName)),
      body: FutureBuilder<List<String>>(
        future: fetchFileUrls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No files available in this folder"));
          } else {
            final urls = snapshot.data!;
            return ListView.builder(
              itemCount: urls.length,
              itemBuilder: (context, index) {
                final url = urls[index];
                return ListTile(
                  title: Text("File ${index + 1}"),
                  trailing: const Icon(Icons.download),
                  onTap: () {
                    // Implement file opening or downloading logic here
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
