import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_list.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/batches/join_batches.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_dietician.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/consult_doctor/ayurveda_consultation.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/consult_doctor/doctor_consultation.dart';
import 'package:healthonify_mobile/screens/client_screens/expert_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/free_workouts.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/consult_doctor/healer_consultation.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/consult_doctor/mind_consultation.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/consult_doctor/physical_trainer.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/consult_doctor/physio_consulatation.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/consult_doctor/yoga_consultation.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/browse_livewell_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/category_videos.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/sub_categories.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/subscription/live_well_subscription.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/free_workout_plan_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/quick_actions/browse_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/wm_my_consultations.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/weight_loss_enquiry.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/my_diet_plans_screen.dart';
import 'package:provider/provider.dart';

class HomeTopListButtons extends StatefulWidget {
  const HomeTopListButtons({Key? key}) : super(key: key);

  @override
  State<HomeTopListButtons> createState() => _HomeTopListButtonsState();
}

class _HomeTopListButtonsState extends State<HomeTopListButtons> {
  String? role;
  List _homeTopList = [];

  void getRole() async {
    SharedPrefManager pref = SharedPrefManager();
    role = await pref.getRoles();

    if (role == 'ROLE_CORPORATEEMPLOYEE') {
      setState(() {
        _homeTopList = corporateHomeTopList;
      });
    } else {
      setState(() {
        _homeTopList = clientHomeTopList;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getRole();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 10, right: 10),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _homeTopList.length,
            itemBuilder: (ctx, index) => topListItem(
              _homeTopList[index],
              context,
            ),
          ),
        ),
      ],
    );
  }

  Widget topListItem(
    HomeTopList data,
    BuildContext context,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () {
          data.function!(context);
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: data.gradient,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: data.image,
                ),
                Text(
                  data.title!,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: whiteColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HealthcareTopButtons extends StatelessWidget {
  HealthcareTopButtons({Key? key, required this.id}) : super(key: key);
  String id;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 10, right: 10),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: healthcareTopList.length,
            itemBuilder: (ctx, index) => topListItem(
              healthcareTopList[index],
              context
            ),
          ),
        ),
      ],
    );
  }

  Widget topListItem(
      HealthcareTopList data, BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () {
          data.function!(context);
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: data.gradient,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: data.image,
                ),
                Text(
                  data.title!,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: whiteColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AyurvedaTopButtons extends StatelessWidget {
  const AyurvedaTopButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 10, right: 10),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: ayurvedaTopList.length,
            itemBuilder: (ctx, index) => topListItem(
              ayurvedaTopList[index],
              context,
            ),
          ),
        ),
      ],
    );
  }

  Widget topListItem(
    AyurvedaTopList data,
    BuildContext context,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () {
          data.function!(context);
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: data.gradient,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: data.image,
                ),
                Text(
                  data.title!,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: whiteColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExpertsTopList extends StatelessWidget {
  const ExpertsTopList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              expertsListItem(
                context,
                Image.asset('assets/icons/doctor.png'),
                'Doctors',
                Colors.orange,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const DoctorConsultationScreen();
                  }));
                },
              ),
              expertsListItem(
                context,
                Image.asset('assets/icons/heal.png'),
                'Healers',
                Colors.blue,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const HealerConsultation();
                  }));
                },
              ),
              expertsListItem(
                context,
                Image.asset('assets/icons/physiotherapist.png'),
                'Physiotherapist',
                Colors.orange,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const PhysioConsultation();
                  }));
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return const PhysiotherapistScreen();
                  //     },
                  //   ),
                  // );
                },
              ),
              expertsListItem(
                context,
                Image.asset('assets/icons/dietician.png'),
                'Dietician',
                Colors.blue,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ConsultDieticianExpert();
                  }));
                },
              ),
              expertsListItem(
                context,
                Image.asset('assets/icons/mind.png'),
                'Mind',
                Colors.orange,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MindConsultation();
                  }));
                },
              ),
              expertsListItem(
                context,
                Image.asset('assets/icons/yoga.png'),
                'Yoga',
                Colors.blue,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const YogaConsultation();
                  }));
                },
              ),
              expertsListItem(
                context,
                Image.asset('assets/icons/ayurveda.png'),
                'Ayurveda',
                Colors.orange,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AyurvedaConsultation();
                  }));
                },
              ),
              expertsListItem(
                context,
                Image.asset('assets/icons/trainer.png'),
                'Physical Trainers',
                Colors.blue,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const PhysicalTrainerConsultation();
                  }));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return const ExpertScreen();
                  // }));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget expertsListItem(
    BuildContext context,
    Image icon,
    String name,
    Color cardColor,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: icon,
              ),
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ExpertsHorizontalList extends StatefulWidget {
  late String title;

  ExpertsHorizontalList({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<ExpertsHorizontalList> createState() => _ExpertsHorizontalListState();
}

class _ExpertsHorizontalListState extends State<ExpertsHorizontalList> {
  bool isloading = true;

  List<User> experts = [];

  Future<void> fetchExperts() async {
    try {
      experts =
          await Provider.of<UserData>(context, listen: false).getExperts();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting expert details : $e");
      // Fluttertoast.showToast(msg: "Unable to fetch expert details");
    } finally {
      if(mounted){
        setState(() {
          isloading = false;
        });
      }

    }
  }

  @override
  void initState() {
    super.initState();

    fetchExperts();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: experts.length > 20 ? 20 : experts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(
                                context, /*rootnavigator: true*/
                              ).push(MaterialPageRoute(builder: (context) {
                                return ExpertScreen(
                                  expertId: experts[index].id!,
                                );
                              }));
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Center(
                              child: experts[index].imageUrl == null || experts[index].imageUrl == ""
                                  ? const CircleAvatar(
                                      radius: 30,
                                      backgroundImage: AssetImage(
                                          'assets/images/experts.png'),
                                    )
                                  : CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        experts[index].imageUrl!,
                                      ),
                                    ),
                            ),
                          ),
                          Text(experts[index].firstName!,style:  Theme.of(context).textTheme.bodySmall,),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}

class FitnessTopList extends StatelessWidget {
  const FitnessTopList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              fitnessListItem(
                context,
                Image.asset('assets/icons/workout.png'),
                'Free Workout',
                Colors.orange,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const FreeWorkoutPlan();
                  }));
                },
              ),
              fitnessListItem(
                context,
                Image.asset('assets/icons/track_diet.png'),
                'Track Diet',
                Colors.blue,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MealPlansScreen();
                  }));
                },
              ),
              // fitnessListItem(
              //   context,
              //   Image.asset('assets/icons/browse_plans.png'),
              //   'View Plans',
              //   Colors.orange,
              //   () {
              //     // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //     //   return const BrowseWmPlans();
              //     // }));
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (context) => const BrowseFitnessPlans(isExpertCurated: false),
              //       ),
              //     );
              //   },
              // ),
              fitnessListItem(
                context,
                Image.asset('assets/icons/my_diet.png'),
                'My Diet Plan',
                Colors.blue,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyDietPlans(
                      isFromTopCard: true,
                    );
                  }));
                },
              ),
              // fitnessListItem(
              //   context,
              //   Image.asset('assets/icons/shop.png'),
              //   'Shop',
              //   Colors.orange,
              //   () {
              //     launchUrl(
              //       Uri.parse("https://healthonify.com/Shop"),
              //       mode: LaunchMode.externalApplication,
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget fitnessListItem(
    BuildContext context,
    Image icon,
    String name,
    Color cardColor,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: icon,
              ),
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LiveWellTopList extends StatelessWidget {
  const LiveWellTopList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              fitnessListItem(
                context,
                Image.asset('assets/icons/browse_plans.png'),
                'View Plans',
                Colors.orange,
                () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return const BrowseWmPlans();
                  // }));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BrowseLiveWellPlans(),
                    ),
                  );
                },
              ),
              fitnessListItem(
                context,
                Image.asset('assets/icons/my_care.png'),
                "My Subscriptions",
                Colors.blue,
                () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LiveWellViewAllSubscriptions(),
                  ));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget fitnessListItem(
    BuildContext context,
    Image icon,
    String name,
    Color cardColor,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: icon,
              ),
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ManageWeightTopList extends StatelessWidget {
  const ManageWeightTopList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              manageWeightListItem(
                context,
                Image.asset('assets/icons/dietician.png'),
                'Consult Dietician',
                Colors.orange,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const WeightLossEnquiry(isFitnessFlow: false);
                  }));
                },
              ),
              manageWeightListItem(
                context,
                Image.asset('assets/icons/my_diet.png'),
                'My Diet Plan',
                Colors.blue,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MyDietPlans(
                      isFromTopCard: true,
                    );
                  }));
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const MealPlansScreen(),
                  //   ),
                  // );
                },
              ),
              manageWeightListItem(
                context,
                Image.asset('assets/icons/my_consultation.png'),
                'My Consultation',
                Colors.orange,
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const WmMyConsultations(),
                    ),
                  );
                },
              ),
              manageWeightListItem(
                context,
                Image.asset('assets/icons/browse_plans.png'),
                'View Plan',
                Colors.blue,
                () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return const BrowseWmPlans();
                  // }));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const WmPackagesQuickActionsScreen(),
                    ),
                  );
                },
              ),
              manageWeightListItem(
                context,
                Image.asset('assets/icons/my_classes.png'),
                'My Classes',
                Colors.orange,
                () async {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const JoinBatchScreen();
                  }));
                  // await launchUrl(
                  //   Uri.parse(
                  //       "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"),
                  //   mode: LaunchMode.externalApplication,
                  // );
                },
              ),
              manageWeightListItem(
                context,
                Image.asset('assets/icons/track_diet.png'),
                'Track Diet',
                Colors.blue,
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MealPlansScreen(),
                    ),
                  );
                },
              ),
              // manageWeightListItem(
              //   context,
              //   Image.asset('assets/icons/shop.png'),
              //   'Shop',
              //   Colors.orange,
              //   () {
              //     launchUrl(
              //       Uri.parse("https://healthonify.com/Shop"),
              //       mode: LaunchMode.externalApplication,
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget manageWeightListItem(
    BuildContext context,
    Image icon,
    String name,
    Color cardColor,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: icon,
              ),
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CorporateTopList extends StatelessWidget {
  const CorporateTopList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              corporateListItem(
                context,
                Image.asset('assets/icons/workout.png'),
                'Free Workout Plans',
                Colors.orange,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const FreeWorkoutScreen();
                  }));
                },
              ),
              corporateListItem(
                context,
                Image.asset('assets/icons/consult_expert.png'),
                'Consult Experts',
                Colors.blue,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const DoctorConsultationScreen();
                  }));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return const MealPlansScreen();
                  // }));
                },
              ),
              corporateListItem(
                context,
                Image.asset('assets/icons/health_care.png'),
                'Health Care',
                Colors.orange,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HealthCareScreen(category: 1);
                  }));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return const BrowseWmPlans();
                  // }));
                },
              ),
              corporateListItem(
                context,
                Image.asset('assets/icons/brain.png'),
                'Mind',
                Colors.blue,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LiveWellCategoryVideos(
                      screenTitle: "Mind",
                      categoryId: "634fd03d829e8806d2fe2c4c",
                    );
                  }));
                },
              ),
              corporateListItem(
                context,
                Image.asset('assets/icons/soul.png'),
                'Soul',
                Colors.orange,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LiveWellCategoryVideos(
                      screenTitle: "Soul",
                      categoryId: "634fd04a829e8806d2fe2c52",
                    );
                  }));
                },
              ),
              corporateListItem(
                context,
                Image.asset('assets/icons/my_courses.png'),
                'My Courses',
                Colors.blue,
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SubCategoriesScreen(
                      screenTitle: " My Courses",
                      parentCategoryId: "634fd031829e8806d2fe2c4a",
                    );
                  }));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget corporateListItem(
    BuildContext context,
    Image icon,
    String name,
    Color cardColor,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: icon,
              ),
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: whiteColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
