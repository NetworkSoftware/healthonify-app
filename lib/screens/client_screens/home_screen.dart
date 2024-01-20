import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/trackers/step_tracker.dart';
import 'package:healthonify_mobile/func/trackers/steps_tracker_func.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/tracker_models/steps_model.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/trackers/steps_tracker.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/appointment_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/ayurveda.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/health_meter/HRA/hra_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/current_workout_plan.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/reminders_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/expert_home.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:healthonify_mobile/screens/notifications_screen.dart';
import 'package:healthonify_mobile/widgets/cards/all_appointments_card.dart';
import 'package:healthonify_mobile/widgets/cards/calorie_tracker_card.dart';
import 'package:healthonify_mobile/widgets/cards/fitness_tools_card.dart';
import 'package:healthonify_mobile/widgets/cards/home_cards.dart';
import 'package:healthonify_mobile/widgets/cards/quick_actions_card.dart';
import 'package:healthonify_mobile/widgets/other/activity_tracker.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/scrollers/adventure_scroller.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:healthonify_mobile/widgets/other/live_well_list.dart';
import 'package:healthonify_mobile/widgets/other/navigation_drawer.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../constants/client/home_client/home_top_dropdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Category> categoryData = [];
  int? selectedValue;
  int lastStepCount = 0;
  List<StepCounter> lastStep = [];

  Future<void> getTopLevelExpertise(BuildContext context) async {
    try {
      await Provider.of<ExpertiseData>(context, listen: false)
          .fetchTopLevelExpertiseData();

      // getLocation();
    } on HttpException catch (e) {
      // log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      //log("Error get get top level expertise widget $e");
      Fluttertoast.showToast(msg: "Unable to fetch expertise");
    }
  }

  Future<List<StepCounter>?> getLastSteps(BuildContext context) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      lastStep = await Provider.of<StepTrackerProvider>(context, listen: false)
          .getLastStepsCounter(userId!);
      if (lastStep.isNotEmpty) {
        lastStepCount = lastStep.first.overallStepCounter!;
      }

      initPlatformState();
      return lastStep;
    } on HttpException catch (e) {
      log(e.toString());
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      log("Error getting steps count in steps screen: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    // StepTrackerData stepsData = StepTrackerData();
    // stepsData.stepCount = '0';
    // stepsData.stepsData = [
    //   {
    //     "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
    //     "stepsCount": '0',
    //     "overallStepCount": preferences.getInt('stepCount').toString(),
    //     "time": DateFormat("hh:mm:ss").format(DateTime.now())
    //   }
    // ];
    // StepsTrackerFunc()
    //     .updateStepsService(stepsData.stepsData!, SharedPrefManager().userId);

    preferences.setInt('stepCount', _todaysStepCount);
    preferences.setInt('overAllStepCount', _steps);
    getLastSteps(context);
    //initPlatformState();
    setState(() {
      categoryData = homeTopList;
    });
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    String userName =
        Provider.of<UserData>(context, listen: false).userData.firstName!;

    ZIMKit().connectUser(id: userId, name: userName);
  }

  late Stream<StepCount> _stepCountStream;
  int _steps = 0;
  int _todaysStepCount = 0;

  void onStepCount(StepCount event) {
    var startTime = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
    var currentTime = DateTime.now();
    var diff = currentTime.difference(startTime).inMinutes;
    setState(() {
      _steps = event.steps;
      try {
        if (!preferences.containsKey("totalCountVal") ||
            !preferences.containsKey('updateDate') ||
            preferences.getInt("totalCountVal") == null ||
            preferences.getInt("totalCountVal") == 0) {
          preferences.setInt("totalCountVal", event.steps);
          preferences.setString(
              "updateDate", DateFormat("MM/dd/yyyy").format(DateTime.now()));
          debugPrint(
              "HH==TODAY_CC=======${event.steps - (preferences.getInt("totalCountVal") ?? 0)}");
          preferences.setInt("todayCountVal",
              (event.steps - (preferences.getInt("totalCountVal") ?? 0)));
        } else {
          if ((preferences.getString('updateDate').toString() !=
                  DateFormat("MM/dd/yyyy").format(DateTime.now())) ||
              (diff > 0 && diff < 10)) {
            StepTrackerData stepsData = StepTrackerData();
            stepsData.stepCount =
                (event.steps - (preferences.getInt("totalCountVal") ?? 0))
                    .toString();
            stepsData.stepsData = [
              {
                "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                "stepsCount":
                    (event.steps - (preferences.getInt("totalCountVal") ?? 0))
                        .toString(),
                "time": DateFormat("hh:mm:ss").format(DateTime.now())
              }
            ];
            StepsTrackerFunc().updateSteps(
                context,
                stepsData.stepsData!,
                () => Provider.of<AllTrackersData>(context, listen: false)
                    .localUpdateSteps((event.steps -
                        (preferences.getInt("totalCountVal") ?? 0))));
            preferences.setInt("todayCountVal", 0);
            preferences.setInt("totalCountVal", event.steps);
            preferences.setString(
                "updateDate", DateFormat("MM/dd/yyyy").format(DateTime.now()));
          } else {
            debugPrint(
                "1111HH==TODAY_CC=======${event.steps - (preferences.getInt("totalCountVal") ?? 0)}");
            preferences.setInt("todayCountVal",
                (event.steps - (preferences.getInt("totalCountVal") ?? 0)));
            preferences.setString(
                "updateDate", DateFormat("MM/dd/yyyy").format(DateTime.now()));
          }
        }
      } catch (e) {
        //
      }

      _todaysStepCount = event.steps - lastStepCount;
      preferences.remove('stepCount');
      preferences.remove('overallStepCount');
      preferences.setInt('stepCount', _todaysStepCount);
      preferences.setInt('overAllStepCount', _steps);
      // kSharedPreferences.setInt('stepCount', _steps);
    });
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 0;
    });
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(
      builder: (context, data, _) => data.userData.roles![0]["name"] == "expert"
          ? const ExpertHomeScreen()
          : FutureBuilder(
              future: getTopLevelExpertise(context),
              builder: (context, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(
                        child: Image.asset('assets/logo/splash.gif'),
                        // child: Text('Gathering all of your data'),
                      ),
                    )
                  : Consumer<ExpertiseData>(
                      builder: (context, categoryData, child) {
                        return Scaffold(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          body: NestedScrollView(
                            headerSliverBuilder: (context, value) {
                              return [
                                flexibleAppBar(context, data,
                                    categoryData.topLevelExpertiseData),
                              ];
                            },
                            body: homeContent(
                                context, categoryData.topLevelExpertiseData),
                          ),
                          drawer: const CustomNavigationDrawer(),
                        );
                      },
                    ),
            ),
    );
  }

  Widget homeContent(context, List<TopLevelExpertise> topLevelExpertise) {
    String categoryId = "";
    List<Map<String, dynamic>> imgs = [
      {
        'image': 'assets/images/banner4.jpg',
        'route': () {
          for (int i = 0; i < topLevelExpertise.length; i++) {
            if (topLevelExpertise[i].name == "Health Care") {
              categoryId = topLevelExpertise[i].id!;
            }
          }
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return HealthCareScreen(
                category: 1,
                categoryId: categoryId,
                topLevelExpertise: topLevelExpertise);
          }));
        },
      },
      {
        'image': 'assets/images/banner5.jpg',
        'route': () {
          for (int i = 0; i < topLevelExpertise.length; i++) {
            if (topLevelExpertise[i].name == "Fitness") {
              categoryId = topLevelExpertise[i].id!;
            }
          }
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return FitnessScreen(
                category: 3,
                categoryId: categoryId,
                topLevelExpertise: topLevelExpertise);
          }));
        },
      },
      {
        'image': 'assets/images/banner3.jpg',
        'route': () {
          for (int i = 0; i < topLevelExpertise.length; i++) {
            if (topLevelExpertise[i].name == "Live Well") {
              categoryId = topLevelExpertise[i].id!;
            }
          }
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return LiveWellScreen(
                category: 6,
                categoryId: categoryId,
                topLevelExpertise: topLevelExpertise);
          }));
        },
      },
      {
        'image': 'assets/images/banner2.jpg',
        'route': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const ShopScreen();
          }));
          // launchUrl(Uri.parse('https://healthonify.com/travelonify/'));
        },
      },
    ];
    // List imgs = [
    //   'assets/images/banner-03.png',
    //   'assets/images/banner1.0-04-04.png',
    //   'assets/images/banner1.0-02.png',
    //   'assets/images/banner11-01.png',
    // ];

    List features = [
      {
        'title': 'Free Meditation',
        'image': 'assets/images/features/features1.jpg',
        'route': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LiveWellScreen(category: 6);
          }));
        },
      },
      {
        'title': 'Stress Relieving',
        'image': 'assets/images/features/features2.jpg',
        'route': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LiveWellScreen(category: 6);
          }));
        },
      },
      {
        'title': 'Ayurveda',
        'image': 'assets/images/features/features3.jpg',
        'route': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AyurvedaScreen();
          }));
        },
      },
      {
        'title': 'Workout Plans',
        'image': 'assets/images/features/features4.jpg',
        'route': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CurrentWorkoutPlan();
          }));
        },
      },
      {
        'title': 'Live Fitness',
        'image': 'assets/images/features/features5.jpg',
        'route': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CurrentWorkoutPlan();
          }));
        },
      },
      {
        'title': 'Free Workout',
        'image': 'assets/images/features/features6.jpg',
        'route': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CurrentWorkoutPlan();
          }));
        },
      },
    ];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 10),
          // Center(child: Text("STEP CHECK DATE: ${kSharedPreferences.getString('TodayDate')}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
          // Center(child: Text("STEP CHECK : ${kSharedPreferences.getInt('Step')}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
          // const SizedBox(height: 10),
          const SizedBox(height: 5),
          CustomCarouselSlider(imageUrls: imgs),
          takeHraCard(context),
          const SizedBox(height: 10),
          const ActivityTracker(),
          const SizedBox(height: 10),
          Consumer<AllTrackersData>(
            builder: (context, value, child) => CaloriesTrackerCard(
              stepsGoal: value.allTrackersData.totalStepsGoal ?? 0,
            ),
          ),
          const SizedBox(height: 15),
          const HomeQuickActionsCard(),
          const SizedBox(height: 15),
          const ChallengesScroller(),
          const SizedBox(height: 15),
          AllAppoinmentsCard(
            onRequest: () async {
              // showPopup(context);
            },
          ),
          const SizedBox(height: 15),
          const FitnessToolsCard(),
          const SizedBox(height: 15),
          // GestureDetector(
          //   onTap: () {
          //     launchUrl(Uri.parse("https://healthonify.com/travelonify/"));
          //   },
          //   child: CustomCarouselSlider(
          //     imageUrls: [
          //       {
          //         'image': 'assets/images/homebanner1.jpg',
          //         'route': () async {
          //           await launchUrl(
          //             Uri.parse(
          //               'https://healthonify.com/Shop',
          //             ),
          //           );
          //           // Navigator.of(context).push(MaterialPageRoute(
          //           //   builder: (context) => const AyurvedaScreen(),
          //           // ));
          //         },
          //       },
          //       {
          //         'image': 'assets/images/homebanner2.jpg',
          //         'route': () async {
          //           await launchUrl(
          //             Uri.parse(
          //               'https://healthonify.com/travelonify',
          //             ),
          //           );
          //         },
          //       },
          //       {
          //         'image': 'assets/images/homebanner3.jpg',
          //         'route': () async {
          //           await launchUrl(
          //             Uri.parse(
          //               'https://healthonify.com/corporate',
          //             ),
          //           );
          //           // Navigator.of(context).push(MaterialPageRoute(
          //           //   builder: (context) => const FitnessScreen(),
          //           // ));
          //         },
          //       },
          //       {
          //         'image': 'assets/images/homebanner4.jpg',
          //         'route': () {
          //           launchUrl(Uri.parse("https://healthonify.com/Shop"));
          //         },
          //       },
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 15),
          // const SyncHealthAppCard(),
          const SizedBox(height: 15),
          const HomeCard(),
          const SizedBox(height: 15),

          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
            child: Text(
              'Features',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(
            height: 160,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: features.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: features[index]['route'],
                          child: Image.asset(
                            features[index]['image'],
                            height: 110,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        features[index]['title'],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const AdventureScroller(
            cardTitle: 'Adventures',
            imgUrl:
                'https://images.unsplash.com/photo-1594103057001-d3635a7e6b88?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OTF8fGZlYXR1cmVkfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
            scrollerTitle: 'Adventures',
          ),
          LiveWellList(),
          // const ShopList(
          //   image:
          //       "https://images.unsplash.com/photo-1527156231393-7023794f363c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=411&q=80",
          // ),
          ExpertsHorizontalList(
            title: 'Our Experts',
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget flexibleAppBar(
      context, UserData userdata, List<TopLevelExpertise> topLevelExpertise) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: SliverAppBar(
        pinned: true,
        floating: true,
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: orange,
        leading: IconButton(
          onPressed: () {
            // log('menu button');
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(
            Icons.menu_rounded,
            // color: whiteColor,
            color: Theme.of(context).drawerTheme.backgroundColor,
            size: 25,
          ),
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //color: const Color(0xFFec6a13),
              //color: whiteColor,
              color: Theme.of(context).drawerTheme.backgroundColor,
              // border: Border.all(color: Colors.black, width: 1)
            ),
            child: DropdownButton2(
              buttonHeight: 20,
              buttonWidth: 200,
              itemHeight: 45,
              underline: const SizedBox(),
              dropdownWidth: 240,
              //offset: const Offset(-30, 20),
              dropdownDecoration: BoxDecoration(
                  color: Theme.of(context).drawerTheme.backgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              alignment: Alignment.center,
              value: selectedValue,
              hint: Text(
                'Choose Category',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              items: categoryData.map((list) {
                return DropdownMenuItem(
                  value: list.id,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: list.image,
                      ),
                      Text(
                        list.title,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      )
                    ],
                  ),
                );
              }).toList(),

              onChanged: (value) {
                setState(() async {
                  selectedValue = value as int;
                  String categoryId = "";
                  if (selectedValue == 1) {
                    for (int i = 0; i < topLevelExpertise.length; i++) {
                      if (topLevelExpertise[i].name == "Health Care") {
                        categoryId = topLevelExpertise[i].id!;
                      }
                    }
                    bool result = await Navigator.of(
                      context, /*rootnavigator: true*/
                    ).push(MaterialPageRoute(builder: (context) {
                      return HealthCareScreen(
                          category: 1,
                          categoryId: categoryId,
                          topLevelExpertise: topLevelExpertise);
                    }));

                    if (result == true) {
                      selectedValue = null;
                    }
                  } else if (selectedValue == 2) {
                    for (int i = 0; i < topLevelExpertise.length; i++) {
                      if (topLevelExpertise[i].name == "Weight Management") {
                        categoryId = topLevelExpertise[i].id!;
                      }
                    }
                    bool result = await Navigator.of(
                      context, /*rootnavigator: true*/
                    ).push(MaterialPageRoute(builder: (context) {
                      return ManageWeightScreen(
                          category: 2,
                          categoryId: categoryId,
                          topLevelExpertise: topLevelExpertise);
                    }));

                    if (result == true) {
                      selectedValue = null;
                    }
                  } else if (selectedValue == 3) {
                    for (int i = 0; i < topLevelExpertise.length; i++) {
                      if (topLevelExpertise[i].name == "Fitness") {
                        categoryId = topLevelExpertise[i].id!;
                      }
                    }
                    bool result = await Navigator.of(
                      context, /*rootnavigator: true*/
                    ).push(MaterialPageRoute(builder: (context) {
                      return FitnessScreen(
                          category: 3,
                          categoryId: categoryId,
                          topLevelExpertise: topLevelExpertise);
                    }));

                    if (result == true) {
                      selectedValue = null;
                    }
                  } else if (selectedValue == 4) {
                    for (int i = 0; i < topLevelExpertise.length; i++) {
                      if (topLevelExpertise[i].name == "Physiotherapy") {
                        categoryId = topLevelExpertise[i].id!;
                      }
                    }
                    bool result = await Navigator.of(
                      context, /*rootnavigator: true*/
                    ).push(MaterialPageRoute(builder: (context) {
                      return PhysiotherapyScreen(
                          category: 4,
                          categoryId: categoryId,
                          topLevelExpertise: topLevelExpertise);
                    }));

                    if (result == true) {
                      selectedValue = null;
                    }
                  } else if (selectedValue == 5) {
                    bool result = await Navigator.of(
                      context, /*rootnavigator: true*/
                    ).push(MaterialPageRoute(builder: (context) {
                      return ConsultExpertsScreen(category: 5);
                    }));

                    if (result == true) {
                      selectedValue = null;
                    }
                  } else if (selectedValue == 6) {
                    for (int i = 0; i < topLevelExpertise.length; i++) {
                      if (topLevelExpertise[i].name == "Live Well") {
                        categoryId = topLevelExpertise[i].id!;
                      }
                    }
                    bool result = await Navigator.of(
                      context, /*rootnavigator: true*/
                    ).push(MaterialPageRoute(builder: (context) {
                      return LiveWellScreen(
                          category: 6,
                          categoryId: categoryId,
                          topLevelExpertise: topLevelExpertise);
                    }));

                    if (result == true) {
                      selectedValue = null;
                    }
                  } else if (selectedValue == 7) {
                    for (int i = 0; i < topLevelExpertise.length; i++) {
                      if (topLevelExpertise[i].name == "Ayurveda") {
                        categoryId = topLevelExpertise[i].id!;
                      }
                    }
                    bool result = await Navigator.of(
                      context, /*rootnavigator: true*/
                    ).push(MaterialPageRoute(builder: (context) {
                      return AyurvedaScreen(
                          category: 7,
                          categoryId: categoryId,
                          topLevelExpertise: topLevelExpertise);
                    }));

                    if (result == true) {
                      selectedValue = null;
                    }
                  } else if (selectedValue == 8) {
                    Navigator.of(
                      context, /*rootnavigator: true*/
                    ).push(MaterialPageRoute(builder: (context) {
                      return const ShopScreen();
                    }));
                    //launchUrl(Uri.parse("https://healthonify.com/Shop"));
                  }
                });
              },

              iconSize: 20,
//                  buttonPadding: const EdgeInsets.only(left: 0,bottom: 25,top: 0),
              iconEnabledColor: Theme.of(context).colorScheme.onBackground,
              iconDisabledColor: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        titleSpacing: 0,
        actions: [
          const SizedBox(width: 5),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //color: const Color(0xFFec6a13),
              //color: whiteColor,
              color: Theme.of(context).drawerTheme.backgroundColor,
              // border: Border.all(color: Colors.black, width: 1)
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(
                  context, /*rootnavigator: true*/
                ).push(MaterialPageRoute(builder: (context) {
                  return const RemindersScreen();
                }));
              },
              child: Icon(
                Icons.schedule_rounded,
                color: Theme.of(context).colorScheme.onBackground,
                size: 25,
              ),
            ),
          ),
          // const SizedBox(width: 5),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //color: const Color(0xFFec6a13),
              color: Theme.of(context).drawerTheme.backgroundColor,
              // border: Border.all(color: Colors.black, width: 1)
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(
                  context, /*rootnavigator: true*/
                ).push(MaterialPageRoute(builder: (context) {
                  return NotificationScreen();
                }));
              },
              child: Icon(
                Icons.notifications,
                color: Theme.of(context).colorScheme.onBackground,
                size: 25,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  void showPopup(context) {
    List options = [
      'Voice Call',
      'Video Call',
    ];
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const AppointmentScreen();
                              }));
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(options[index]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget takeHraCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              //const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: const BoxDecoration(
                  color: Color(0xFFec6a13),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: const Center(
                  child: Text(
                    "Take Health Risk Assessment",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Are you Pre-Diabetic at Hypertension risk or Cardiovascular disorders?",
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return const HraScreen(hraData: []);
                      })),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFec6a13),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFec6a13),
                                    border: Border.all(color: Colors.white)),
                                child: const Center(
                                  child: Text(
                                    "GO",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text(
                  "BELIEVE US, Your chronic condition can be reversed",
                  style: TextStyle(
                      color: Color(0xFFec6a13),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget travelCard(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 175,
        width: MediaQuery.of(context).size.width * 0.98,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1454391304352-2bf4678b1a7a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse('http://healthonify.saketherp.in./travelonify'),
                    );
                  },
                  child: Text(
                    'Go to Travelonify',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: whiteColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
