import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VisacardPage extends StatefulWidget {
  final String iframeUrl;
  const VisacardPage({required this.iframeUrl});

  @override
  _VisacardPageState createState() => _VisacardPageState();
}

class _VisacardPageState extends State<VisacardPage> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => isLoading = true),
          onPageFinished: (_) => setState(() => isLoading = false),
        ),
      );

    Future.delayed(const Duration(milliseconds: 50), () {
      controller.loadRequest(Uri.parse(widget.iframeUrl));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x000000ff),
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              ignoring: isLoading,
              child: WebViewWidget(controller: controller),
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}