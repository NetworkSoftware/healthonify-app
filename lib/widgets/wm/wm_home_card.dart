import 'package:flutter/material.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/body_measurements/body_measurements.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_form/fitness_form.dart';
import 'package:healthonify_mobile/screens/client_screens/lifestyle_questions.dart';
import 'package:healthonify_mobile/screens/client_screens/medical_history.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/watertracker/water_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_screen.dart';
import 'package:healthonify_mobile/screens/lifestyle_details.dart';
import 'package:provider/provider.dart';

class WmHomeCard extends StatelessWidget {
  const WmHomeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    List<Map<String, dynamic>> data = [
      {
        "title": 'Fill your fitness form',
        "icon": 'assets/icons/dumbell.png',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const FitnessForm();
          }));
        }
      },
      {
        "title": 'Track your diet',
        "icon": 'assets/icons/track_diet.png',
        "onClick": () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const MealPlansScreen();
          }));
        }
      },
      {
        "title": "Today's water intake",
        "icon": 'assets/icons/water.png',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const WaterTrackerScreen();
          }));
        }
      },
      {
        "title": 'Track your weight',
        "icon": 'assets/icons/log_weight.png',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const WeightScreen();
          }));
        }
      },
      {
        "title": 'Measurements',
        "icon": 'assets/icons/measure.png',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const BodyMeasurementsScreen();
          }));
        }
      },
      {
        "title": 'Lifestyle',
        "icon": 'assets/icons/log_weight.png',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const LifestyleQuestionsScreen();
          }));
        }
      },
      {
        "title": 'Lifestyle Details',
        "icon": 'assets/icons/log_weight.png',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LifestyleDetailsScreen(clientId: userId);
          }));
        }
      },
      {
        "title": 'Medical History',
        "icon": 'assets/icons/measure.png',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MedicalHistoryScreen();
          }));
        }
      }
    ];
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.98,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: data[index]["onClick"],
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          Image.asset(
                            data[index]["icon"],
                            height: 32,
                            width: 32,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              data[index]["title"],
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right_rounded,
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1.25,
                      color: Color(0xFFE4E4E4),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
