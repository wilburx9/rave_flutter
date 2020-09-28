import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:rave_flutter/src/ui/common/overlay_loader.dart';

class WebViewWidget extends StatefulWidget {
  final String authUrl;
  final String callbackUrl;
  final Function(Map) onAuthComplete;

  WebViewWidget({@required this.authUrl, @required this.callbackUrl, this.onAuthComplete});

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.onUrlChanged.listen((String url){
      if (url.startsWith(widget.callbackUrl)) {
        if(widget.onAuthComplete != null) {
          try{
            Uri uri = Uri.parse(Uri.decodeComponent(url));
            Map parameters = jsonDecode(uri.queryParameters["resp"]);
            widget.onAuthComplete(parameters);
          }catch(e){
            print(e);
          }
        }

        Future.delayed(Duration.zero,() {
          Navigator.of(context).pop();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebviewScaffold(
        url: widget.authUrl,
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Center(child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OverlayLoaderWidget(),
            SizedBox(height: 20),
            Text(
              "Please, do not close this page.",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            )
          ],
        ),),
      ),
    );
  }
}
