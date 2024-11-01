import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NewsDetailPage extends StatelessWidget {
  final Map<String, dynamic> newsData;

  const NewsDetailPage({Key? key, required this.newsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = newsData['title'] ?? 'No Title';
    final String body = newsData['body'] ?? 'No Description';
    final List<String> images =
    List<String>.from(newsData['images'] ?? []);

    final List<String> titleWords = title.split(' ');
    final String appBarTitle = titleWords.take(2).join(' ');

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              body,
              style: const TextStyle(fontSize: 16),
            ),
            if (images.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 16),
                  if (images.length > 1)
                    CarouselSlider.builder(
                      itemCount: images.length,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                        null
                                        ? loadingProgress
                                        .cumulativeBytesLoaded /
                                        (loadingProgress
                                            .expectedTotalBytes ?? 1)
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) {
                                return const Center(
                                    child: Text('Failed to load image'));
                              },
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.8,
                        aspectRatio: 2.0,
                        initialPage: 0,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          images.first,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                    null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ??
                                        1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return const Center(
                                child: Text('Failed to load image'));
                          },
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
