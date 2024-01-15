import 'package:flutter/material.dart';

class WeightAnalysisCard extends StatelessWidget {
  const WeightAnalysisCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/icons/graph.png',
          width: MediaQuery.of(context).size.width * 0.95,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
