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
  bool isLoading = true; // <-- اللودينج

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
        ),
      );

    // تحميل الـ iframe بعد قليل
    Future.delayed(const Duration(milliseconds: 80), () {
      controller.loadRequest(Uri.parse(widget.iframeUrl));
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0x000000ff),
        body: Stack(
          children: [
            /// الـ WebView
            SizedBox.expand(
              child: WebViewWidget(controller: controller),
            ),

            /// اللودينج فوقه
            if (isLoading)
              Container(
                color: Colors.white, // خلفية بسيطة
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}