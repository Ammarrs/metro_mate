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
  bool hasNavigated = false;

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
          onPageFinished: (url) {
            setState(() => isLoading = false);


            if (!hasNavigated) {
              if (url.contains("success=true")) {
                hasNavigated = true;
                Future.delayed(Duration(seconds: 5), () {
                  Navigator.pushReplacementNamed(context, "test_page");
                });
              } else if (url.contains("success=false")) {
                hasNavigated = true;
                Future.delayed(Duration(seconds: 5), () {
                  Navigator.pushReplacementNamed(context, "Chosepaymentmethod");
                });
              }
            }
          },
        ),
      );

    Future.delayed(const Duration(milliseconds: 20), () {
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
            SizedBox.expand(
              child: WebViewWidget(controller: controller),
            ),
            if (isLoading)
              Container(
                color: Colors.white,
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