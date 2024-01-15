import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class CycleLengthScreen extends StatelessWidget {
  const CycleLengthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? cycleLength;
    List<String> cycleLengthOptions = List.generate(
      31,
      (int index) => index.toString(),
      growable: false,
    );

    String? periodLength;
    List<String> periodLengthOptions = List.generate(
      11,
      (int index) => index.toString(),
      growable: false,
    );
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Cycle and Period Length'),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Cycle and Period Length',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cycle Length',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            StatefulBuilder(
                              builder: (context, newState) =>
                                  DropdownButtonFormField(
                                isDense: true,
                                items: cycleLengthOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  newState(() {
                                    cycleLength = newValue!;
                                  });
                                },
                                value: cycleLength,
                                style: Theme.of(context).textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.25,
                                    ),
                                  ),
                                  constraints: const BoxConstraints(
                                    maxHeight: 36,
                                    maxWidth: 86,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                hint: Text(
                                  'days',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Period Length',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            StatefulBuilder(
                              builder: (context, newState) =>
                                  DropdownButtonFormField(
                                isDense: true,
                                items: periodLengthOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  newState(() {
                                    periodLength = newValue!;
                                  });
                                },
                                value: periodLength,
                                style: Theme.of(context).textTheme.bodyMedium,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.25,
                                    ),
                                  ),
                                  constraints: const BoxConstraints(
                                    maxHeight: 36,
                                    maxWidth: 86,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                hint: Text(
                                  'days',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Period length is based on the cycle and the period length settings. Please regularly log your period.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientButton(
                  title: 'Save',
                  func: () {
                    Navigator.pop(context);
                  },
                  gradient: orangeGradient,
                ),
              ],
            ),
            // ElevatedButton(
            //   onPressed: () {
            // Navigator.pop(context);
            //   },
            //   child: const Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16),
            //     child: Text('Save'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
