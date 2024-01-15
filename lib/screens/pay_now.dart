import "package:flutter/material.dart";
import "package:flutter_inappwebview/flutter_inappwebview.dart";
import "package:healthonify_mobile/widgets/cards/custom_appbar.dart";

class PayNowScreen extends StatefulWidget {
  const PayNowScreen({Key? key,required this.paymentUrl}) : super(key: key);
  final String paymentUrl;

  @override
  State<PayNowScreen> createState() => _PayNowScreenState();
}

class _PayNowScreenState extends State<PayNowScreen> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: ()async{
        var isLastPage = await inAppWebViewController.canGoBack();
        if(isLastPage){
          inAppWebViewController.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: const CustomAppBar(appBarTitle: 'Pay'),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse(widget.paymentUrl)
              ),
              onWebViewCreated: (InAppWebViewController controller){
                inAppWebViewController = controller;
              },
              onProgressChanged: (InAppWebViewController controller , int progress){
                setState(() {
                  _progress = progress / 100;
                });
              },
            ),
            _progress < 1 ? LinearProgressIndicator(
              value: _progress,
            ):const SizedBox()
          ],
        ),
      ),
    );
  }
}
