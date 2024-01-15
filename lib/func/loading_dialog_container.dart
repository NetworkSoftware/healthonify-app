import 'package:flutter/material.dart';

class LoadingDialog {
  void onLoadingDialog(String text, BuildContext context) {
    showDialog(
        useRootNavigator: false,
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(text),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          );
        });
  }
}
