import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class LearnMoreScreen extends StatelessWidget {
  const LearnMoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(appBarTitle: 'Learn More'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('Learn more screen'),
          ),
        ],
      ),
    );
  }
}
