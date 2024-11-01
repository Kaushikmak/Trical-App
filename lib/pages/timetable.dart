// import 'package:flutter/material.dart';
// import 'package:trical/widgets/drawer_widget.dart';
//
// class Timetable extends StatelessWidget {
//   const Timetable({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Time Table"),
//         centerTitle: true,
//       ),
//       drawer: const Tricaldrawer(currentPage: "timetable"),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:trical/widgets/drawer_widget.dart';
import 'package:trical/widgets/timetabel_folder_page.dart';


class Timetable extends StatefulWidget {
  const Timetable({super.key});

  @override
  State<Timetable> createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  late Future<List<String>> _folderNames;

  @override
  void initState() {
    super.initState();
    _folderNames = fetchFolderNames();
  }

  // Fetch folder names from Firebase Storage's /Timetable directory
  Future<List<String>> fetchFolderNames() async {
    try {
      ListResult result = await FirebaseStorage.instance.ref('Timetable/').listAll();
      List<String> folders = result.prefixes.map((folderRef) => folderRef.name).toList();
      return folders;
    } catch (e) {
      print("Error fetching folders: $e");
      return []; // Return an empty list on error
    }
  }

  // Navigate to the timetable details page
  void _openFolder(BuildContext context, String folderName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimetableFolderPage(folderName: folderName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Table"),
        centerTitle: true,
      ),
      drawer: const Tricaldrawer(currentPage: "timetable"),
      body: FutureBuilder<List<String>>(
        future: _folderNames,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No timetable folders available"));
          } else {
            final folderNames = snapshot.data!;
            return ListView.builder(
              itemCount: folderNames.length,
              itemBuilder: (context, index) {
                final folderName = folderNames[index];
                return ListTile(
                  title: Text(folderName),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => _openFolder(context, folderName),
                );
              },
            );
          }
        },
      ),
    );
  }
}
