import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    double progress = 0;
    late InAppWebViewController inAppWebViewController;
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(appBarTitle: 'About Us'),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse("https://healthonify.com/About")
              ),
              onWebViewCreated: (InAppWebViewController controller){
                inAppWebViewController = controller;
              },
              onProgressChanged: (InAppWebViewController controller , int progress){
                // setState(() {
                //   progress = progress / 100;
                // });
              },
            ),
            progress < 1 ? LinearProgressIndicator(
              value: progress,
            ):const SizedBox()
          ],
        ),
      ),
    );
  }
}
