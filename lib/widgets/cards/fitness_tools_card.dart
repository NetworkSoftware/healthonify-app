import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmi_details.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmr_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/body_fat_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/ideal_weight_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/lean_body_mass.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/macros_calc.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/rmr_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/set_calories_target.dart';

class FitnessToolsCard extends StatelessWidget {
  const FitnessToolsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> gridItems = [
      {
        'title': 'BMI',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return BmiDetailsScreen();
          }));
        },
        'icon': 'assets/icons/bmi.png'
      },
      {
        'title': 'BMR',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const BMRScreen();
          }));
        },
        'icon': 'assets/icons/bmr.png'
      },
      {
        'title': 'RMR',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const RMRscreen();
          }));
        },
        'icon': 'assets/icons/rmr.png',
      },
      {
        'title': 'Body Fat',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const BodyFatScreen();
          }));
        },
        'icon': 'assets/icons/body_fat.png'
      },
      {
        'title': 'Calorie\nIntake',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const SetCaloriesTarget();
          }));
        },
        'icon': 'assets/icons/calories.png'
      },
      {
        'title': 'Ideal\nWeight',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const IdealWeightScreen();
          }));
        },
        'icon': 'assets/icons/weigh_machine.png'
      },

      {
        'title': 'Lean\nBody Mass',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const LeanBodyMassScreen();
          }));
        },
        'icon': 'assets/icons/body_mass.png'
      },
      {
        'title': 'Macro\nCalculator',
        'onClick': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const MacrosCalculatorScreen();
          }));
        },
        'icon': 'assets/icons/calculator.png'
      },

    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                'Fitness tools',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisExtent: 126,
                    mainAxisSpacing: 0.0,
                    crossAxisSpacing: 0.0,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: gridItems[index]['onClick'],
                      //borderRadius: BorderRadius.circular(10),
                      child: Column(
                        children: [
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: Image.asset(
                                gridItems[index]["icon"],
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                          Text(
                            gridItems[index]["title"],
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,fontSize: 14),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
