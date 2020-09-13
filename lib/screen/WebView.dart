import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebV extends StatelessWidget {
  WebV(this.url);
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  final accessToken = "SOME_ACCESS_TOKEN";
  String url;

  @override
  Widget build(BuildContext context) {
    flutterWebViewPlugin
        .evalJavascript('document.cookie = "accessToken=$accessToken"');
    return WebviewScaffold(
      url: url,
      withJavascript: true,
      appCacheEnabled: true,
      clearCache: false,
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.redAccent,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                flutterWebViewPlugin.goBack();
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                flutterWebViewPlugin.goForward();
              },
            ),
            IconButton(
              icon: const Icon(Icons.autorenew),
              onPressed: () {
                flutterWebViewPlugin.reload();
              },
            ),
          ],
        ),
      ),
    );
  }
}

