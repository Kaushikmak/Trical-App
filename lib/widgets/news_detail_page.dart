import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> newsData;

  const NewsDetailPage({Key? key, required this.newsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extracting information from the news data
    final String title = newsData['title'] ?? 'No Title';
    final String body = newsData['body'] ?? 'No Description';
    final List<String> images = List<String>.from(newsData['images'] ?? []);
    final List<String> videos = List<String>.from(newsData['videos'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Body
            Text(
              body,
              style: const TextStyle(fontSize: 16),
            ),
            // Images
            if (images.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Images",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...images.map((url) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )),
                ],
              ),
            // Videos
            if (videos.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Videos",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...videos.map((url) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      height: 200, // Set a fixed height for video
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          "Video: ${url.split('/').last}", // Show the video filename
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
