import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_dropdown.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/all_appointments_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/expert_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/ayurveda.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:healthonify_mobile/widgets/other/testimonial_scroller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsultExpertsScreen extends StatefulWidget {
  ConsultExpertsScreen({Key? key, this.category}) : super(key: key);
  int? category;

  @override
  State<ConsultExpertsScreen> createState() => _ConsultExpertsScreenState();
}

class _ConsultExpertsScreenState extends State<ConsultExpertsScreen> {
  bool isloading = true;

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

  List<User> experts = [];

  List<User> healthCareExperts = [];
  List<User> physioExperts = [];
  List<User> fitnessExperts = [];
  List<User> weightManagementExperts = [];
  List<User> liveWellExperts = [];
  List<User> dietitianExperts = [];

  Future<void> fetchExperts() async {
    try {
      experts =
          await Provider.of<UserData>(context, listen: false).getExperts();

      for (int i = 0; i < experts.length; i++) {
        if (experts[i].topExpertise == "Health Care") {
          healthCareExperts.add(experts[i]);
        } else if (experts[i].topExpertise == "Physiotherapy") {
          physioExperts.add(experts[i]);
        } else if (experts[i].topExpertise == "Fitness") {
          fitnessExperts.add(experts[i]);
        } else if (experts[i].topExpertise == "Weight Management") {
          weightManagementExperts.add(experts[i]);
        } else if (experts[i].topExpertise == "Live Well") {
          liveWellExperts.add(experts[i]);
        } else if (experts[i].topExpertise == "Dietitian") {
          dietitianExperts.add(experts[i]);
        }
      }
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting user details : $e");
      Fluttertoast.showToast(msg: "Unable to fetch user details");
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  int? selectedValue;
  List<Category> categoryData = [];

  @override
  void initState() {
    super.initState();

    fetchExperts();
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
              // FlexibleAppBar(
              //   title: 'Physiotherapy',
              //   listItems: PhysioTopList(id: id),
              // ),
              flexibleAppBar(context, categoryData.topLevelExpertiseData),
            ];
          },
          body: consultExpertContent(context),
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

  Widget consultExpertContent(context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const ExpertsTopList(),
          CustomCarouselSlider(imageUrls: [
            {
              'image': 'assets/images/consultexp/consultexp1.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/consultexp/consultexp2.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/consultexp/consultexp3.jpg',
              'route': () {},
            },
          ]),
          // EnquiryMyAppoinmentsCard(
          //   onRequest: () {},
          // ),
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
                                    AllAppointmentsScreen(flow: 'consultExpert'),
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
          //                     // Navigator.push(context,
          //                     //     MaterialPageRoute(builder: (context) {
          //                     //       return const HealthCareAppointmentsScreen();
          //                     //     }));
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
          //                     // Navigator.push(context,
          //                     //     MaterialPageRoute(builder: (context) {
          //                     //       return const DoctorConsultationScreen();
          //                     //     }));
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
          isloading
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Our Experts",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      healthCareExperts.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Health Care",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                SizedBox(
                                  height: 100,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: healthCareExperts.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(width: 10);
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ExpertScreen(
                                                expertId:
                                                    healthCareExperts[index]
                                                        .id!,
                                              );
                                            }));
                                          },
                                          child: healthCareExperts[index]
                                                      .imageUrl ==
                                                  null || healthCareExperts[index]
                                              .imageUrl ==
                                              ""
                                              ? const CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: AssetImage(
                                                      'assets/icons/expert_pfp.png'),
                                                )
                                              : CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: NetworkImage(
                                                    healthCareExperts[index]
                                                        .imageUrl!,
                                                  ),
                                                ),
                                        ),
                                        Text(
                                          healthCareExperts[index].firstName!,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      dietitianExperts.isNotEmpty
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Dietitian",
                            style:
                            Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: dietitianExperts.length,
                              separatorBuilder: (context, index) {
                                return const SizedBox(width: 10);
                              },
                              itemBuilder:
                                  (BuildContext context, int index) =>
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                                    return ExpertScreen(
                                                      expertId:
                                                      dietitianExperts[index].id!,
                                                    );
                                                  }));
                                        },
                                        child: dietitianExperts[index]
                                            .imageUrl ==
                                            null || dietitianExperts[index]
                                            .imageUrl ==
                                            ""
                                            ? const CircleAvatar(
                                          radius: 32,
                                          backgroundImage: AssetImage(
                                              'assets/icons/expert_pfp.png'),
                                        )
                                            : CircleAvatar(
                                          radius: 32,
                                          backgroundImage: NetworkImage(
                                            dietitianExperts[index]
                                                .imageUrl!,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        dietitianExperts[index].firstName!,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                        ],
                      )
                          : const SizedBox(),
                      weightManagementExperts.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  "Weight Management",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                SizedBox(
                                  height: 100,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: weightManagementExperts.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(width: 10);
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ExpertScreen(
                                                expertId:
                                                    weightManagementExperts[
                                                            index]
                                                        .id!,
                                              );
                                            }));
                                          },
                                          child: weightManagementExperts[index]
                                                      .imageUrl ==
                                                  null || weightManagementExperts[index]
                                              .imageUrl ==
                                              ""
                                              ? const CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: AssetImage(
                                                      'assets/icons/expert_pfp.png'),
                                                )
                                              : CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: NetworkImage(
                                                    weightManagementExperts[
                                                            index]
                                                        .imageUrl!,
                                                  ),
                                                ),
                                        ),
                                        Text(
                                          weightManagementExperts[index]
                                              .firstName!,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      fitnessExperts.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  "Fitness",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                SizedBox(
                                  height: 100,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: fitnessExperts.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(width: 10);
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ExpertScreen(
                                                expertId:
                                                    fitnessExperts[index].id!,
                                              );
                                            }));
                                          },
                                          child: fitnessExperts[index]
                                                      .imageUrl ==
                                                  null || fitnessExperts[index].imageUrl == ""
                                              ? const CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: AssetImage(
                                                      'assets/icons/expert_pfp.png'),
                                                )
                                              : CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: NetworkImage(
                                                    fitnessExperts[index]
                                                        .imageUrl!,
                                                  ),
                                                ),
                                        ),
                                        Text(
                                          fitnessExperts[index].firstName!,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      physioExperts.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  "Physio Therapy",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                SizedBox(
                                  height: 100,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: physioExperts.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(width: 10);
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ExpertScreen(
                                                expertId:
                                                    physioExperts[index].id!,
                                              );
                                            }));
                                          },
                                          child: physioExperts[index]
                                                      .imageUrl ==
                                                  null || physioExperts[index].imageUrl == ""
                                              ? const CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: AssetImage(
                                                      'assets/icons/expert_pfp.png'),
                                                )
                                              : CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: NetworkImage(
                                                    physioExperts[index]
                                                        .imageUrl!,
                                                  ),
                                                ),
                                        ),
                                        Text(
                                          physioExperts[index].firstName!,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      liveWellExperts.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  "Live Well",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                SizedBox(
                                  height: 100,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: liveWellExperts.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(width: 10);
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ExpertScreen(
                                                expertId:
                                                    liveWellExperts[index].id!,
                                              );
                                            }));
                                          },
                                          child: liveWellExperts[index]
                                                      .imageUrl ==
                                                  null || liveWellExperts[index].imageUrl == ""
                                              ? const CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: AssetImage(
                                                      'assets/icons/expert_pfp.png'),
                                                )
                                              : CircleAvatar(
                                                  radius: 32,
                                                  backgroundImage: NetworkImage(
                                                    liveWellExperts[index]
                                                        .imageUrl!,
                                                  ),
                                                ),
                                        ),
                                        Text(
                                          liveWellExperts[index].firstName!,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
          // ExpertsHorizontalList(
          //   title: 'Doctors',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Ayurveda',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Dieticians',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Fitness Trainers',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Yoga Trainers',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Sleep Specialists',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Psychiatrists',
          // ),
          // ExpertsHorizontalList(
          //   title: 'Meditation',
          // ),
          CustomCarouselSlider(imageUrls: [
            {
              'image': 'assets/images/consultexp/consultexp4.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/consultexp/consultexp5.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/consultexp/consultexp6.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/consultexp/consultexp7.jpg',
              'route': () {},
            },
          ]),
          const TestimonialScroller(),
        ],
      ),
    );
  }
}
