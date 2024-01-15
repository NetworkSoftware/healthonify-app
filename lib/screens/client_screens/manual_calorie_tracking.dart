import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/goal_end.dart';
import 'package:healthonify_mobile/widgets/text%20fields/set_calories_fields.dart';

class ManualCalorieTracking extends StatelessWidget {
  const ManualCalorieTracking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? dropdownValue1;
    List<String> dropDownOptions1 = [
      'Lose Weight',
      'Gain Weight',
      'Maintain Weight',
    ];
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: ''),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                child: Text(
                  'Set Calories Target',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
                child: Text(
                  'Goal',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: StatefulBuilder(
                  builder: (context, thisState) => DropdownButtonFormField(
                    items: dropDownOptions1
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      thisState(() {
                        dropdownValue1 = newValue!;
                      });
                    },
                    value: dropdownValue1,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.25,
                        ),
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey,
                    ),
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(13),
                    elevation: 1,
                    hint: Text(
                      'Select',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey),
                    ),
                    onSaved: (value) {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Calories',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const CaloriesTextField(),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Current Weight',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFC3CAD9),
                      ),
                    ),
                    hintText: 'Current Weight in Kgs',
                    hintStyle: const TextStyle(
                      color: Color(0xFF959EAD),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Target Weight',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFC3CAD9),
                      ),
                    ),
                    hintText: 'Target Weight in Kgs',
                    hintStyle: const TextStyle(
                      color: Color(0xFF959EAD),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onChanged: (value) {},
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Goal End Date',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const Center(child: GoalEndCard()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientButton(
                    title: 'Submit',
                    func: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const MealPlansScreen();
                      }));
                    },
                    gradient: orangeGradient,
                  ),
                ],
              ),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return const MealPlansScreen();
              // }));
              //     },
              //     child: const Text('Submit'),
              //     style: Theme.of(context).elevatedButtonTheme.style,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
