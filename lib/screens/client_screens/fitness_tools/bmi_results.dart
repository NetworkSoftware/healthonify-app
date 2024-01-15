import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class BmiResults extends StatelessWidget {
  final Map<String, dynamic>? data;
  final String? from;
  const BmiResults({Key? key, this.data, required this.from}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Results'),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  if (from == "bmi") bmiLayout(context),
                  if (from == "bmr") bmrLayout(context),
                  if (from == 'idealW') idealWeightLayout(context),
                  if (from == "lbm") lbmLayout(context),
                  if (from == "rmr") rmrLayout(context),
                  if (from == "bfp") bfpLayout(context),
                ],
              ),
            ),
            // const Padding(
            //   padding: EdgeInsets.only(top: 12, bottom: 30),
            //   child: BmiGoalCard(),
            // ),
            // const NextButton2(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientButton(
                    title: "Done",
                    func: () {
                      Navigator.of(context).pop();
                    },
                    gradient: orangeGradient),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget bmiLayout(BuildContext context) {
    var tableTextStyle = Theme.of(context).textTheme.bodySmall;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Your BMI is ${data!["bmi"]}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (data!["category"] == "Normal Weight")
            Text(
              "Your weight is ideal",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          if (data!["category"] == "Obesity")
            Text(
              "You are Obese",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          if (data!["category"] == "Over Weight")
            Text(
              "You are over weight",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          if (data!["category"] == "Under Weight")
            Text(
              "You are under weight",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              ''' World Health Organization's (WHO) recommended body weight based on BMI values for adults. It is used for both men and women, age 20 or older.''',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Table(
              border: TableBorder.all(
                color: Theme.of(context).textTheme.bodySmall!.color!,
              ),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Category', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('BMI range-kg/m2', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Severe thinness', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('<16', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Moderate Thinness', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('16-17', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Mild Thinness', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('17-18.5', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Normal', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('18.5-25', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Overweight', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('25-30', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Obese class I', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('30-35', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Obese class II', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('35-40', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Obese class III', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('>40', style: tableTextStyle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bmrLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Your BMR is ${data!["bmr"]} calories/day',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '''Multiply BMR result by scale factor for activity level

- Sedentary *1.2
- Lightly active *1.375
- Moderately active *1.55
- Active *1.725
- Very active *1.9''',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget idealWeightLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Your ideal weight is ${data!["idealWeight"]} kg',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '''The Ideal Weight Calculator computes ideal body weight (IBW) ranges based on height, gender, and age. Knowing your ideal body weight is the first significant step you can take to be healthy. Obesity and being overweight is responsible for the majority of the lifestyle diseases. These include heart disease, stroke, diabetes, obesity, metabolic syndrome, chronic obstructive pulmonary disease, and some types of cancer.''',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget lbmLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Your lean body mass (Weight) ${data!["lbm"]} kg',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '''Lean body mass (LBM) is a part of body composition that is defined as the difference between total body weight and body fat weight. This means that it counts the mass of all organs except body fat, including bones, muscles, blood, skin, and everything else. The Lean Body Mass Calculator computes a person's estimated lean body mass (LBM) based on body weight, height, gender, and age.''',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget rmrLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Your Resting Metabolic Rate is ${data!["rmr"]}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '''RMR is the abbreviation of resting metabolic rate. This parameter tells how many calories are required by your body to perform the most basic functions (to keep itself alive) while resting. These essential functions are e.g., breathing, heart beating, blood circulation, food digestion, functioning of vital organs etc.

Multiply RMR result by scale factor for activity level:
Sedentary *1.2
Lightly active *1.375
Moderately active *1.55
Active *1.725
Very active *1.9


To lose weight, try to eat slightly more than your RMR. This is the minimum calories you need per day to survive, so your body will get the rest from its stored energy sources, e.g. fat. However please consult your doctor before beginning any serious diet change, and stop if you begin to feel any pain.
                      ''',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget bfpLayout(BuildContext context) {
    var tableTextStyle = Theme.of(context).textTheme.bodySmall;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Your body fat percentage is ${data!["bfp"]}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Table(
              border: TableBorder.all(
                color: Theme.of(context).textTheme.bodySmall!.color!,
              ),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Description', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Women', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Men', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Essential Fat', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('10-13%', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('2-5%', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Atheletes', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('14-20%', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('6-13%', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Fitness', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('21-24%', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('14-17%', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Average', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('25-31%', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('18-24%', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Obese', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('32% +', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('25% +', style: tableTextStyle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
