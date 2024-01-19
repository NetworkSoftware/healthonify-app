import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/body_measurements/body_measurements.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_form/fitness_form.dart';
import 'package:healthonify_mobile/screens/client_screens/medical_history.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        "title": 'Fill your fitness form',
        "icon": 'assets/icons/dumbell.png',
        "onClick": () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
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
        "title": 'Track your weight',
        "icon": 'assets/icons/log_weight.png',
        "onClick": () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const WeightScreen();
          }));
        }
      },
      {
        "title": 'Measurements',
        "icon": 'assets/icons/measure.png',
        "onClick": () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const BodyMeasurementsScreen();
          }));
        }
      },
      {
        "title": 'Chat With Us',
        "icon": 'assets/images/expert_chat.png',
        "onClick": () {
          //print("name : ${widget.clientName}");
         //ZIMKit().showDefaultNewPeerChatDialog(context);
         //  Navigator.push(context, MaterialPageRoute(builder: (context) {
         //    return const ZIMKitMessageListPage(
         //      conversationID: "653ba936d9975f01f93bc011",
         //      conversationType: ZIMConversationType.peer,
         //    );
         //  }));

         //  Navigator.of(
         //    context, /*rootnavigator: true*/
         //  ).push(MaterialPageRoute(builder: (context) {
         //    return const ExpertsChatList();
         //  }));

          launchUrl(Uri.parse('https://api.whatsapp.com/send/?phone=9718297700&text=Hi,&type=phone_number&app_absent=0'),
              mode: LaunchMode.externalApplication);
        }
      }
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
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
                  onTap: data[index]['onClick'],
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
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: orange),
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
        ),
      ),
    );
  }
}

class PhysioScreenCard extends StatelessWidget {
  const PhysioScreenCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {
        "title": 'Fill your medical form',
        "icon": 'assets/icons/dumbell.png',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MedicalHistoryScreen();
          }));
        }
      },
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
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
                onTap: data[index]['onClick'],
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
                              size: 32,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
