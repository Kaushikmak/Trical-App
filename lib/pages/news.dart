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
      final storageRef = FirebaseStorage.instance.ref('news');
      ListResult result = await storageRef.listAll();

      List<Map<String, dynamic>> newsItems = [];
      for (var folderRef in result.prefixes) {
        // Assuming the JSON file is named "info.json"
        String metadataUrl = await folderRef.child('info.json').getDownloadURL();
        final response = await NetworkAssetBundle(Uri.parse(metadataUrl)).load("");
        final jsonData = json.decode(utf8.decode(response.buffer.asUint8List()));

        newsItems.add(jsonData);
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
        builder: (context) => NewsDetailPage(newsData: newsData), // You need to create this page
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
            return Center(child: const Text("No news available"));
          } else {
            final newsItems = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1, // Ensures square cards
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
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            newsData['body'] ?? 'No Description',
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                            maxLines: 3,
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

