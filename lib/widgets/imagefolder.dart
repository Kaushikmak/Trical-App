import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class FolderImagesPage extends StatefulWidget {
  final String folderName;
  const FolderImagesPage({Key? key, required this.folderName})
      : super(key: key);

  @override
  State<FolderImagesPage> createState() => _FolderImagesPageState();
}

class _FolderImagesPageState extends State<FolderImagesPage> {
  final List<String> _urls = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    try {
      final result = await FirebaseStorage.instance
          .ref('Images/${widget.folderName}/')
          .list(
              const ListOptions(maxResults: 50)); // Limit to 50 images at once

      if (!mounted) return;

      final futures = result.items.map((ref) => ref.getDownloadURL());
      final urls = await Future.wait(futures);

      setState(() {
        _urls.addAll(urls);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName.toUpperCase()),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _urls.isEmpty
              ? const Center(child: Text('No images found'))
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: _urls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showImage(context, index),
                      child: Image.network(
                        _urls[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showImage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewPage(
          urls: _urls,
          initialIndex: index,
        ),
      ),
    );
  }
}

class ImageViewPage extends StatelessWidget {
  final List<String> urls;
  final int initialIndex;

  const ImageViewPage({
    Key? key,
    required this.urls,
    required this.initialIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(onPressed: (){}, icon:const Icon(Icons.share,color: Colors.white,))
        ],
      ),
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: urls.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 3.0,
            child: Center(
              child: Image.network(
                urls[index],
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
