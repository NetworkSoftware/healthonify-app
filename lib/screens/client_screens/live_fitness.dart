import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class LiveFitnessScreen extends StatefulWidget {
  const LiveFitnessScreen({Key? key}) : super(key: key);

  @override
  State<LiveFitnessScreen> createState() => _LiveFitnessScreenState();
}

class _LiveFitnessScreenState extends State<LiveFitnessScreen> {
  @override
  Widget build(BuildContext context) {
    double progressValue = 0;
    late InAppWebViewController inAppWebViewController;
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(appBarTitle: 'Live Fitness'),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse("https://healthonify.com/Personal-training")
              ),
              onWebViewCreated: (InAppWebViewController controller){
                inAppWebViewController = controller;
              },
              onProgressChanged: (InAppWebViewController controller , int progress){
                setState(() {
                  progressValue = progress / 100;
                });
              },
            ),
            progressValue < 1 ? LinearProgressIndicator(
              value: progressValue,
            ):const SizedBox()
          ],
        ),
      ),
    );
  }
}
