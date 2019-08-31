import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatelessWidget {
  final String authUrl;
  final String callbackUrl;

  WebViewWidget({@required this.authUrl, @required this.callbackUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        initialUrl: authUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (String url) {
          if (url.startsWith(callbackUrl)) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
