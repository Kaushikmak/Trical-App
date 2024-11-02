import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:trical/widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<String>> _imageUrls;

  @override
  void initState() {
    super.initState();
    _imageUrls = _fetchImageUrls();
  }

  Future<List<String>> _fetchImageUrls() async {
    final storageRef = FirebaseStorage.instance.ref().child('/Homepage');
    final ListResult result = await storageRef.listAll();
    final List<String> urls = [];

    for (var ref in result.items) {
      final url = await ref.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.electric_bolt,
              color: Colors.amber,
            ),
            SizedBox(width: 8),
            Text(
              "TRICAL",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      drawer: const Tricaldrawer(
        currentPage: "home",
      ),
      body: FutureBuilder<List<String>>(
        future: _imageUrls,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading images"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No images available"));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: CarouselSlider(
                    items: snapshot.data!
                        .map((url) => Image.network(url, fit: BoxFit.cover))
                        .toList(),
                    options: CarouselOptions(
                      height: 200, // Adjust height as needed
                      autoPlay: true,
                      enlargeCenterPage: true,
                      animateToClosest: true,
                      enlargeFactor: 3,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      pauseAutoPlayOnTouch: true,
                      viewportFraction: 0.7,
                      initialPage: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Add space after the carousel
                // List of info cards
                _buildInfoCard("Random Info #1",
                    "quia molestiae reprehenderit quasi aspernatur\naut expedita occaecati aliquam eveniet laudantium\nomnis quibusdam delectus saepe quia accusamus maiores nam est\ncum et ducimus et vero voluptates excepturi deleniti ratione"),
                _buildInfoCard("Random Info #2",
                    "est natus enim nihil est dolore omnis voluptatem numquam\net omnis occaecati quod ullam at\nvoluptatem error expedita pariatur\nnihil sint nostrum voluptatem reiciendis et"),
                _buildInfoCard("Random Info #3",
                    "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to build info cards
  Widget _buildInfoCard(String title, String body) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(title,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Text(body, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
