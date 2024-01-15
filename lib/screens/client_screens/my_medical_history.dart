import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

class MyMedicalHistoryScreen extends StatelessWidget {
  const MyMedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(appBarTitle: 'My Medical History'),
      body: Column(),
    );
  }
}
