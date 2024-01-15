import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_dropdown.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/screens/client_screens/all_appointments_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_form/my_subscription.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/browse_fitness_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/ayurveda.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:healthonify_mobile/widgets/cards/activity_card.dart';
import 'package:healthonify_mobile/widgets/cards/batches_card.dart';
import 'package:healthonify_mobile/widgets/cards/fitness_log_cards.dart';
import 'package:healthonify_mobile/widgets/cards/fitness_tools_card.dart';
import 'package:healthonify_mobile/widgets/cards/home_cards.dart';
import 'package:healthonify_mobile/widgets/cards/quick_actions_card.dart';
import 'package:healthonify_mobile/widgets/cards/steps_card.dart';
import 'package:healthonify_mobile/widgets/fitness/fitness_centre_nearme_button.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'blogs/blogs_widget.dart';

class FitnessScreen extends StatefulWidget {
  FitnessScreen({Key? key, this.category, this.categoryId, this.topLevelExpertise}) : super(key: key);
  int? category;
  String? categoryId;
  List<TopLevelExpertise>? topLevelExpertise;
  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  int? selectedValue;
  List<Category> categoryData = [];
  List<SubCategory> subCategoryData = [];
  Future<void> getTopLevelExpertise(BuildContext context) async {
    try {
      await Provider.of<ExpertiseData>(context, listen: false)
          .fetchTopLevelExpertiseData();

      // getLocation();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get get top level expertise widget $e");
      Fluttertoast.showToast(msg: "Unable to fetch expertise");
    }
  }

  subCategory() {
    for (int i = 0; i < widget.topLevelExpertise!.length; i++) {
      if (widget.topLevelExpertise![i].parentExpertiseId != null) {
        if (widget.categoryId ==
            widget.topLevelExpertise![i].parentExpertiseId) {
          subCategoryData.add(
              SubCategory(id: widget.topLevelExpertise![i].id!,
                  name: widget.topLevelExpertise![i].name!,
                  parentId: widget.topLevelExpertise![i].parentExpertiseId!)
          );
        }
      }
    }

    print("list1111 : ${subCategoryData.length}");
  }

  @override
  void initState() {
    super.initState();
    subCategory();
    //getTopLevelExpertise(context);
    selectedValue = widget.category;
    setState(() {
      categoryData = homeTopList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(body:
          Consumer<ExpertiseData>(builder: (context, categoryData, child) {
        return NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              flexibleAppBar(context, categoryData.topLevelExpertiseData),
            ];
          },
          body: fitnessContent(context),
        );
      })),
    );
  }

  PreferredSizeWidget flexibleAppBar(
      context, List<TopLevelExpertise> topLevelExpertise) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: SliverAppBar(
        pinned: true,
        floating: true,
        automaticallyImplyLeading: true,
        backgroundColor: orange,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).drawerTheme.backgroundColor,
            size: 25,
          ),
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).drawerTheme.backgroundColor,
                 //border: Border.all(color: Colors.black, width: 1)
              ),
              child: DropdownButton2(
                buttonHeight: 20,
                buttonWidth: 200,
                itemHeight: 45,
                underline: const SizedBox(),
                dropdownWidth: 240,
                offset: const Offset(-30, 20),
                dropdownDecoration:  BoxDecoration(
                    color: Theme.of(context).drawerTheme.backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                alignment: Alignment.topLeft,
                value: selectedValue,
                hint: const Row(
                  children: [
                    Text(
                      'Choose Fitness Category',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Icon(
                    //   Icons.arrow_drop_down,
                    //   color: Colors.white,
                    //   size: 50,
                    // ),
                  ],
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
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold,fontSize: 14),),
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
                            category: 1, categoryId: categoryId,topLevelExpertise: topLevelExpertise);
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
                            category: 2, categoryId: categoryId,topLevelExpertise: topLevelExpertise);
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
                            category: 3, categoryId: categoryId,topLevelExpertise: topLevelExpertise);
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
                            category: 4, categoryId: categoryId,topLevelExpertise: topLevelExpertise);
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
                            category: 6, categoryId: categoryId,topLevelExpertise: topLevelExpertise);
                      }));

                      if (result == true) {
                        selectedValue = null;
                      }
                    }  else if (selectedValue == 7) {
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
                    }

                    else if (selectedValue == 8) {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return const ShopScreen(
                        );
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
        ),
        titleSpacing: 0,
        actions: const [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(
          //       context, /*rootnavigator: true*/
          //     ).push(MaterialPageRoute(builder: (context) {
          //       return const RemindersScreen();
          //     }));
          //   },
          //   icon: Icon(
          //     Icons.schedule_rounded,
          //     color: Theme.of(context).colorScheme.onBackground,
          //     size: 25,
          //   ),
          // ),
          // IconButton(
          //   onPressed: () {
          //     Share.share('Check out Healthonify');
          //     log('message shared');
          //   },
          //   icon: Icon(
          //     Icons.share_rounded,
          //     color: Theme.of(context).colorScheme.onBackground,
          //     size: 25,
          //   ),
          // ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(
          //       context, /*rootnavigator: true*/
          //     ).push(MaterialPageRoute(builder: (context) {
          //       return NotificationScreen();
          //     }));
          //   },
          //   icon: Icon(
          //     Icons.notifications,
          //     color: Theme.of(context).colorScheme.onBackground,
          //     size: 25,
          //   ),
          // ),
        ],
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(50),
        //   child: Container(
        //     color: Theme.of(context).scaffoldBackgroundColor,
        //     child: const HomeTopListButtons(),
        //   ),
        // ),
      ),
    );
  }

  Widget fitnessContent(context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const FitnessTopList(),
          const FitnessTopList(),
          CustomCarouselSlider(
            imageUrls: [
              // 'assets/images/Picture12.png',
              {
                'image': 'assets/images/livewell/livebanner1.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner2.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner3.jpg',
                'route': () {},
              },
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(right: 8, bottom: 12),
          //       child: Container(
          //         height: 36,
          //         decoration: BoxDecoration(
          //           color: Colors.orange,
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         child: TextButton(
          //           onPressed: () {},
          //           child: const Padding(
          //             padding: EdgeInsets.symmetric(horizontal: 4),
          //             child: Text(
          //               'Fitness centre near me',
          // //               style: Theme.of(context)
          //                   .textTheme
          //                   .labelMedium!
          //                   .copyWith(
          //                     color: whiteColor
          //                   ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          const FitnessCenterNearmeButton(),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return const BrowseFitnessPlans(isExpertCurated: false);
                        }),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('View Packages'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MySubscriptions(),
                      ));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('My Packages'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const ChallengesScroller(),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TotalWorkoutHours(),
            ],
          ),
          const StepsCard(),
          const Center(child: ActivityCard()),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.98,
                child: Card(
                  elevation: 5,
                  color: const Color(0xFFec6a13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child:  Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(
                              context, /*rootnavigator: true*/
                            ).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AllAppointmentsScreen(flow: 'fitness'),
                              ),
                            );
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(color: const Color(0xFFec6a13))),
                                    child: const Center(
                                      child: Text(
                                        "View",
                                        style: TextStyle(
                                            color: Color(0xFFec6a13),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Appointments",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .labelLarge!.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Book and View your appointments here',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall!.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(4),
          //   child: Card(
          //     child: Padding(
          //       padding: const EdgeInsets.all(10),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "Your Appointments",
          //             style: Theme.of(context).textTheme.labelLarge,
          //           ),
          //           const SizedBox(height: 6),
          //           Text(
          //             'Book and view your consultations here',
          //             style: Theme.of(context).textTheme.bodySmall,
          //           ),
          //           const SizedBox(height: 10),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Container(
          //                 constraints:
          //                     const BoxConstraints(minWidth: 70, minHeight: 40),
          //                 decoration: BoxDecoration(
          //                   gradient: purpleGradient,
          //                   borderRadius:
          //                       const BorderRadius.all(Radius.circular(10.0)),
          //                 ),
          //                 child: InkWell(
          //                   onTap: () {
          //                     // Navigator.of(context).push(MaterialPageRoute(
          //                     //   builder: (context) =>
          //                     //       const FitnessConsultations(),
          //                     // ));
          //
          //                     Navigator.of(
          //                       context, /*rootnavigator: true*/
          //                     ).push(
          //                       MaterialPageRoute(
          //                         builder: (context) =>
          //                             AllAppointmentsScreen(flow: 'fitness'),
          //                       ),
          //                     );
          //                   },
          //                   borderRadius: BorderRadius.circular(10),
          //                   child: Center(
          //                     child: Text(
          //                       'View',
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .labelMedium!
          //                           .copyWith(color: whiteColor),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               Container(
          //                 constraints:
          //                     const BoxConstraints(minWidth: 90, minHeight: 40),
          //                 decoration: BoxDecoration(
          //                   gradient: purpleGradient,
          //                   borderRadius:
          //                       const BorderRadius.all(Radius.circular(10.0)),
          //                 ),
          //                 child: InkWell(
          //                   onTap: () {
          //                     Navigator.push(context,
          //                         MaterialPageRoute(builder: (context) {
          //                       return const FitnessRequestAppointment(
          //                           isFitnessFlow: true);
          //                     }));
          //                   },
          //                   borderRadius: BorderRadius.circular(10),
          //                   child: Padding(
          //                     padding:
          //                         const EdgeInsets.symmetric(horizontal: 10.0),
          //                     child: Row(
          //                       children: [
          //                         const Icon(
          //                           Icons.add,
          //                           color: Colors.white,
          //                         ),
          //                         Text(
          //                           'Request',
          //                           style: Theme.of(context)
          //                               .textTheme
          //                               .labelMedium!
          //                               .copyWith(color: whiteColor),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          CustomCarouselSlider(
            imageUrls: [
              // 'assets/images/Picture14.png',
              // 'assets/images/Picture15.png',
              // 'assets/images/banner9-03.png',
              {
                'image': 'assets/images/livewell/livebanner4.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner5.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner6.jpg',
                'route': () {},
              },
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 4),
          //   child: Center(
          //     child: SizedBox(
          //       height: 175,
          //       width: MediaQuery.of(context).size.width * 0.98,
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(8),
          //         child: Image.asset(
          //           'assets/images/Picture14.jpg',
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const Center(
            child: QuickActionCard2(),
          ),
          const Center(child: BatchesCard()),
          const BlogsWidget(expertiseId: "63ef2333eef2ad2bdf410333"),
          const HomeCard(),
          const Center(child: FitnessToolsCard()),
          //const SyncHealthAppCard(),
          CustomCarouselSlider(
            imageUrls: [
              // 'assets/images/Picture14.png',
              // 'assets/images/Picture15.png',
              // 'assets/images/banner9-03.png',
              {
                'image': 'assets/images/livewell/livebanner7.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner8.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner9.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/livewell/livebanner10.jpg',
                'route': () {},
              },
            ],
          ),
        ],
      ),
    );
  }
}
