import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

class ExpertsConsultationsScreen extends StatefulWidget {
  const ExpertsConsultationsScreen({Key? key}) : super(key: key);

  @override
  State<ExpertsConsultationsScreen> createState() =>
      _ExpertsConsultationsScreenState();
}

class _ExpertsConsultationsScreenState
    extends State<ExpertsConsultationsScreen> {
  List consultations = [
    'Consultation 1',
    'Consultation 2',
    'Consultation 3',
    'Consultation 4',
    'Consultation 5',
  ];
  Object? groupValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Consultations'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Today's Consultations",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Select an appointment",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: consultations.length,
            itemBuilder: (context, index) {
              return RadioListTile(
                value: index,
                groupValue: groupValue,
                onChanged: (ind) {
                  setState(() {
                    groupValue = ind;
                  });
                },
                title: Text(
                  consultations[index],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Start Live Consultation'),
            ),
          ),
        ],
      ),
    );
  }
}
