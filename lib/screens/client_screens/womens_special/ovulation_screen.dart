import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class OvulationScreen extends StatelessWidget {
  const OvulationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? lutelPhase;
    List<String> lutelPhaseOptions = List.generate(
      31,
      (int index) => index.toString(),
      growable: false,
    );
    bool isPregnant = false;

    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Ovulation and Fertility'),
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
                        'Ovulation and Fertility',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Lutel Phase',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            StatefulBuilder(
                              builder: (context, newState) =>
                                  DropdownButtonFormField(
                                isDense: true,
                                items: lutelPhaseOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  newState(() {
                                    lutelPhase = newValue!;
                                  });
                                },
                                value: lutelPhase,
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
                      Text(
                        'Lutel Phase is the time between your ovulation and the beginning of your period. If you know the length of your lutel phase, please log it.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const Divider(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Chance of getting pregnant',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            StatefulBuilder(
                              builder: (context, thisState) => Switch(
                                inactiveTrackColor: Colors.grey[600],
                                value: isPregnant,
                                onChanged: (isPreg) {
                                  thisState(() {
                                    isPregnant = isPreg;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'If you turn off this parameter, only the ovulation day will be displayed.',
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
            //     Navigator.pop(context);
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
