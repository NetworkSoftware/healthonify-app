import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/health_care_actions/health_care_actions.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_dropdown.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/blogs_model/blogs_model.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/models/hra_model/hra_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/blogs_provider/blogs_provider.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/health_risk_assessment/hra_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/all_appointments_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blog_details_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blogs_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/ayurveda.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/browse_plans/browse_hc_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthCareScreen extends StatefulWidget {
  HealthCareScreen(
      {Key? key, this.category, this.categoryId, this.topLevelExpertise})
      : super(key: key);
  int? category;
  String? categoryId;
  List<TopLevelExpertise>? topLevelExpertise;

  @override
  State<HealthCareScreen> createState() => _HealthCareScreenState();
}

class _HealthCareScreenState extends State<HealthCareScreen> {
  bool isLoading = true;
  List<BlogsModel> blogs = [];
  int? selectedValue;
  List<Category> categoryData = [];
  List<SubCategory> subCategoryData = [];

  Future<void> fetchAllBlogs() async {
    try {
      blogs = await Provider.of<BlogsProvider>(context, listen: false)
          .getAllBlogs();
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching blogs');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  late String userId;
  List<HraAnswerModel> hraAnswers = [];
  String ayurvedaId = "";

  Future<void> getHraAnswers() async {
    try {
      hraAnswers = await Provider.of<HraProvider>(context, listen: false)
          .getHraScore(userId);
      log('hra score fetched');
    } on HttpException catch (e) {
      log("Unable to fetch hra score $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error loading hra score $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  // Future<void> getTopLevelExpertise(BuildContext context) async {
  //   try {
  //     await Provider.of<ExpertiseData>(context, listen: false)
  //         .fetchTopLevelExpertiseData();
  //
  //     // getLocation();
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //     Fluttertoast.showToast(msg: e.message);
  //   } catch (e) {
  //     log("Error get get top level expertise widget $e");
  //     Fluttertoast.showToast(msg: "Unable to fetch expertise");
  //   }
  // }

  subCategory() {
    for (int i = 0; i < widget.topLevelExpertise!.length; i++) {
      if (widget.topLevelExpertise![i].parentExpertiseId != null) {
        if (widget.categoryId ==
            widget.topLevelExpertise![i].parentExpertiseId) {
          subCategoryData.add(SubCategory(
              id: widget.topLevelExpertise![i].id!,
              name: widget.topLevelExpertise![i].name!,
              parentId: widget.topLevelExpertise![i].parentExpertiseId!));
        }
      }
    }

    for (int j = 0; j < subCategoryData.length; j++) {
      if (subCategoryData[j].name == "Ayurveda") {
        ayurvedaId = subCategoryData[j].id;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    subCategory();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;

    fetchAllBlogs();
    getHraAnswers();
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
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : pageContent(context),
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
        backgroundColor: orange,
        automaticallyImplyLeading: true,
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
                //color: const Color(0xFFec6a13),
                color: Theme.of(context).drawerTheme.backgroundColor,
                // border: Border.all(color: Colors.black, width: 1)
              ),
              child: DropdownButton2(
                buttonHeight: 20,
                buttonWidth: 200,
                itemHeight: 45,
                underline: const SizedBox(),
                dropdownWidth: 240,
                offset: const Offset(-30, 20),
                dropdownDecoration: BoxDecoration(
                    color: Theme.of(context).drawerTheme.backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                alignment: Alignment.topLeft,
                value: selectedValue,
                hint: Row(
                  children: [
                    Text(
                      'Choose Category',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
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
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                        ),
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

  Widget pageContent(context) {
    List imgs = [
      // 'assets/images/Picture16.jpg',
      {
        'image': 'assets/images/hc/hc1.jpg',
        'route': () {},
      },
      {
        'image': 'assets/images/hc/hc2.jpg',
        'route': () {},
      },
      {
        'image': 'assets/images/hc/hc3.jpg',
        'route': () {},
      },
    ];
    List imgs2 = [
      // 'assets/images/Picture16.jpg',
      {
        'image': 'assets/images/hc/hc4.jpg',
        'route': () {},
      },
      {
        'image': 'assets/images/hc/hc5.jpg',
        'route': () {},
      },
      {
        'image': 'assets/images/hc/hc6.jpg',
        'route': () {},
      },
    ];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HealthcareTopButtons(id: ayurvedaId),
          CustomCarouselSlider(imageUrls: imgs),
          // Card(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8),
          //     child: Column(
          //       children: [
          //         Text(
          //             "Half of the population don't even know that they are having chronic conditions like Diabetes, Hypertension and Cardiovascular disorders? Do you know? ",
          //             style: Theme
          //                 .of(context)
          //                 .textTheme
          //                 .labelSmall),
          //         const SizedBox(
          //           height: 10,
          //         ),
          //         GradientButton(
          //           title: 'Take a Health Risk Assessment',
          //           func: () {
          //             Navigator.of(
          //               context, /*rootnavigator: true*/
          //             ).push(MaterialPageRoute(builder: (context) {
          //               return HraScreen(hraData: hraAnswers);
          //             }));
          //           },
          //           gradient: blueGradient,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          GridView.builder(
            padding: const EdgeInsets.all(4),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisExtent: 130,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
            ),
            itemCount: healthCareGridView.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => healthCareGridView[index]['onClick'](context),
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
                          healthCareGridView[index]["icon"],
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                    //const SizedBox(height: 10),
                    Text(
                      healthCareGridView[index]["title"],
                      style: Theme.of(context).textTheme.labelSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: Card(
                  elevation: 5,
                  color: const Color(0xFFec6a13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(
                              context, /*rootnavigator: true*/
                            ).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AllAppointmentsScreen(flow: 'healthCare'),
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
                                        border: Border.all(
                                            color: const Color(0xFFec6a13))),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Book and View your appointments here',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.white),
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
          //             style: Theme
          //                 .of(context)
          //                 .textTheme
          //                 .labelLarge,
          //           ),
          //           const SizedBox(height: 6),
          //           Text(
          //             'Book and view your consultations here',
          //             style: Theme
          //                 .of(context)
          //                 .textTheme
          //                 .bodySmall,
          //           ),
          //           const SizedBox(height: 10),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Container(
          //                 constraints:
          //                 const BoxConstraints(minWidth: 70, minHeight: 40),
          //                 decoration: BoxDecoration(
          //                   gradient: purpleGradient,
          //                   borderRadius:
          //                   const BorderRadius.all(Radius.circular(10.0)),
          //                 ),
          //                 child: InkWell(
          //                   onTap: () {
          //                     // Navigator.push(context,
          //                     //     MaterialPageRoute(builder: (context) {
          //                     //   return const HealthCareAppointmentsScreen();
          //                     // }));
          //                     Navigator.of(
          //                       context, /*rootnavigator: true*/
          //                     ).push(
          //                       MaterialPageRoute(
          //                         builder: (context) =>
          //                             AllAppointmentsScreen(flow: 'healthCare'),
          //                       ),
          //                     );
          //                   },
          //                   borderRadius: BorderRadius.circular(10),
          //                   child: Center(
          //                     child: Text(
          //                       'View',
          //                       style: Theme
          //                           .of(context)
          //                           .textTheme
          //                           .labelMedium!
          //                           .copyWith(color: whiteColor),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               Container(
          //                 constraints:
          //                 const BoxConstraints(minWidth: 90, minHeight: 40),
          //                 decoration: BoxDecoration(
          //                   gradient: purpleGradient,
          //                   borderRadius:
          //                   const BorderRadius.all(Radius.circular(10.0)),
          //                 ),
          //                 child: InkWell(
          //                   onTap: () {
          //                     Navigator.push(context,
          //                         MaterialPageRoute(builder: (context) {
          //                           return const DoctorConsultationScreen();
          //                         }));
          //                   },
          //                   borderRadius: BorderRadius.circular(10),
          //                   child: Padding(
          //                     padding:
          //                     const EdgeInsets.symmetric(horizontal: 10.0),
          //                     child: Row(
          //                       children: [
          //                         const Icon(
          //                           Icons.add,
          //                           color: Colors.white,
          //                         ),
          //                         Text(
          //                           'Request',
          //                           style: Theme
          //                               .of(context)
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GradientButton(
                    func: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BrowseHealthCarePlans();
                      }));
                    },
                    title: 'Chronic Condition reversal Plans',
                    gradient: orangeGradient,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'Quick Links',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 15.0, bottom: 8),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisExtent: 126,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                ),
                itemCount: healthCareQuickLinks.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () =>
                        healthCareQuickLinks[index]['onClick'](context),
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
                              healthCareQuickLinks[index]["icon"],
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          healthCareQuickLinks[index]["title"],
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          CustomCarouselSlider(imageUrls: imgs2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                child: Text(
                  "Blogs",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BlogsScreen(allBlogs: blogs);
                  }));
                },
                child: const Text('view all'),
              ),
            ],
          ),
          SizedBox(
            height: 154,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BlogDetailsScreen(blogData: blogs[index]);
                            }));
                          },
                          child: Image.network(
                            blogs[index].mediaLink!,
                            height: 110,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        blogs[index].blogTitle!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Hscroller(
          //   cardTitle: blogs[0].blogTitle!,
          //   imgUrl: blogs[0].mediaLink!,
          //   scrollerTitle: 'Blogs',
          //   onTouch: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       return BlogsScreen(allBlogs: blogs);
          //     }));
          //   },
          // ),
          // const ShopList(
          //   image:
          //   "https://images.unsplash.com/photo-1527156231393-7023794f363c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=411&q=80",
          // ),
        ],
      ),
    );
  }

  void locationDisclosure() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "DISCLAIMER",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Healthonify collects location data to enable fitness tracking even when the app is closed or not in use. Location features will be used to detect laboratories around your location. Please grant access to continue.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SubCategory {
  String id;
  String name;
  String parentId;

  SubCategory({required this.id, required this.name, required this.parentId});
}
