// import 'package:flutter/material.dart';
// import 'package:trical/widgets/drawer_widget.dart';
//
// class Newspage extends StatelessWidget {
//   const Newspage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("News"),
//       ),
//       drawer: const Tricaldrawer(currentPage: "news"),
//     );
//   }
// }

///////////////////////

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:trical/widgets/drawer_widget.dart';
import 'package:trical/widgets/news_detail_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<List<Map<String, dynamic>>> fetchNewsItems() async {
    try {
      final storageRef = FirebaseStorage.instance.ref('News');
      ListResult result = await storageRef.listAll();

      List<Map<String, dynamic>> newsItems = [];
      for (var folderRef in result.prefixes) {
        try {
          ListResult folderContents = await folderRef.listAll();

          // Initialize lists to hold image and video URLs
          List<String> images = [];
          List<String> videos = [];

          Map<String, dynamic>? jsonData;

          for (var item in folderContents.items) {
            if (item.name.endsWith('.json') && jsonData == null) {
              String metadataUrl = await item.getDownloadURL();
              final response = await NetworkAssetBundle(Uri.parse(metadataUrl)).load("");
              jsonData = json.decode(utf8.decode(response.buffer.asUint8List()));
            } else if (item.name.endsWith('.jpg') || item.name.endsWith('.jpeg') || item.name.endsWith('.png')) {
              images.add(await item.getDownloadURL());
            } else if (item.name.endsWith('.mp4')) {
              videos.add(await item.getDownloadURL());
            }
          }

          if (jsonData == null) {
            print("No JSON metadata file found in folder ${folderRef.name}");
            continue; // Skip folders without a JSON file
          }

          // Add images and videos to the JSON data
          jsonData['images'] = images;
          jsonData['videos'] = videos;
          jsonData['folderName'] = folderRef.name; // Optional: folder name for UI

          newsItems.add(jsonData);
        } catch (e) {
          print("Error loading data for folder ${folderRef.name}: $e");
        }
      }

      return newsItems;
    } catch (e) {
      print("Error fetching news items: $e");
      return [];
    }
  }

  void openNewsDetail(BuildContext context, Map<String, dynamic> newsData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailPage(newsData: newsData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
      ),
      drawer: const Tricaldrawer(currentPage: "news"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchNewsItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No news available"));
          } else {
            final newsItems = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2,
              ),
              itemCount: newsItems.length,
              itemBuilder: (context, index) {
                final newsData = newsItems[index];
                return GestureDetector(
                  onTap: () => openNewsDetail(context, newsData),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          newsData['title'] ?? 'No Title',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            newsData['body'] ?? 'No Description',
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
