import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/Bloc/Navigate_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Subscrptionpaymob extends StatefulWidget {
  final String SubscrptioniframeUrl;
  const Subscrptionpaymob({required this.SubscrptioniframeUrl});

  @override
  _SubscrptionpaymobState createState() => _SubscrptionpaymobState();
}

class _SubscrptionpaymobState extends State<Subscrptionpaymob> {
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
                Future.delayed(Duration(seconds: 5), () async {
                  // final prefs = await SharedPreferences.getInstance();
                  // await prefs.remove('subscription_id');
                  // Navigator.pushReplacementNamed(context, "test_page");

                  context.read<Navigate_Cubit>().ChangeIndex(0);

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "test_page",
                    (route) => false,
                  );
                });
              } else if (url.contains("success=false")) {
                hasNavigated = true;
                Future.delayed(Duration(seconds: 5), () {
                  Navigator.pushReplacementNamed(context, "Screen4");
                });
              }
            }
          },
        ),
      );

    Future.delayed(const Duration(milliseconds: 20), () {
      controller.loadRequest(Uri.parse(widget.SubscrptioniframeUrl));
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
