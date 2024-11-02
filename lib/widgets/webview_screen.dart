import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String url;

  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(url),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        debuggingEnabled: true, // Enable debugging for better insights
        onWebResourceError: (WebResourceError error) {
          print("Error loading webpage: ${error.description}");
        },
        onPageFinished: (String url) {
          print("Finished loading: $url");
        },
      )
    );
  }
}
