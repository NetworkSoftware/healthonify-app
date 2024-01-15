import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_dropdown.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blogs_widget.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/ayurveda.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/quick_actions/browse_plans.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:healthonify_mobile/widgets/cards/batches_card.dart';
import 'package:healthonify_mobile/widgets/cards/fitness_tools_card.dart';
import 'package:healthonify_mobile/widgets/cards/manage_calories.dart';
import 'package:healthonify_mobile/widgets/cards/quick_actions_card.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/diet_log_wm_card.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:healthonify_mobile/widgets/other/manage_workout_calories.dart';
import 'package:healthonify_mobile/widgets/wm/wm_home_card.dart';
import 'package:healthonify_mobile/widgets/wm/wm_my_appointments_card.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageWeightScreen extends StatefulWidget {
  ManageWeightScreen({Key? key, this.category,this.categoryId, this.topLevelExpertise}) : super(key: key);
  int? category;
  String? categoryId;
  List<TopLevelExpertise>? topLevelExpertise;
  @override
  State<ManageWeightScreen> createState() => _ManageWeightScreenState();
}

class _ManageWeightScreenState extends State<ManageWeightScreen> {
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
    print("CategoryID : ${widget.categoryId}");
    selectedValue = widget.category;
    setState(() {
      categoryData = homeTopList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context,true);
        return true;
      },
      child: Scaffold(
        body: Consumer<ExpertiseData>(builder: (context, categoryData, child) {
          return NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                flexibleAppBar(context, categoryData.topLevelExpertiseData),
              ];
            },
            body: manageWeightContent(context),
          );
        })


      ),
    );
  }

  Widget manageWeightContent(context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const ManageWeightTopList(),
          CustomCarouselSlider(
            imageUrls: [
              {
                'image': 'assets/images/wm/wm1.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/wm/wm2.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/wm/wm3.jpg',
                'route': () {},
              },
            ],
          ),
          // const CustomCarouselSliderWithHeader(imageUrls: [
          //   'https://images.unsplash.com/photo-1607081759141-5035e0a710a4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
          //   'https://images.unsplash.com/photo-1606636660801-c61b8e97a1dc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
          //   'https://images.unsplash.com/photo-1606926693996-d1dfbed4e8c9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
          //   'https://images.unsplash.com/photo-1624455806586-037944b1fa1a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80',
          // ], header: []),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return const WmPackagesQuickActionsScreen();
                      }));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('View Plans'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const ManageWorkoutCalories(),
          const CaloriesCard(),
          const ManageCaloriesTracker(),
          WMMyAppoinmentsCard(
            onRequest: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return const WeightLossEnquiry(isFitnessFlow: false);
              // }));
              // showDatePicker(
              //   context: context,
              //   builder: (context, child) {
              //     return Theme(
              //       data: datePickerDarkTheme,
              //       child: child!,
              //     );
              //   },
              //   initialDate: DateTime.now(),
              //   firstDate: DateTime.now(),
              //   lastDate: DateTime(2200),
              // ).then((value) =>
              //     Navigator.push(context, MaterialPageRoute(builder: (context) {
              //       return const AppointmentScreen();
              //     })));
            },
          ),
          const BatchesCard(),
          const QuickActionCardWM(),
          const BlogsWidget(expertiseId: "6229a968eb71920e5c85b0af"),
          const FitnessToolsCard(),
          const WmHomeCard(),
          CustomCarouselSlider(
            imageUrls: [
              // 'assets/images/banner13-01.png',
              // 'assets/images/banner13-03.png',
              {
                'image': 'assets/images/wm/wm4.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/wm/wm5.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/wm/wm6.jpg',
                'route': () {},
              },
              {
                'image': 'assets/images/wm/wm7.jpg',
                'route': () {},
              },
            ],
          ),
          // const SyncHealthAppCard(),
          // const ShopList(
          //   image:
          //       "https://cdn.shopify.com/s/files/1/0005/5335/3267/products/WPC_1000g_Creatine_100g_grande.jpg?v=1648204173",
          // ),
        ],
      ),
    );
  }

  PreferredSizeWidget flexibleAppBar(context, List<TopLevelExpertise> topLevelExpertise) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: SliverAppBar(
        pinned: true,
        floating: true,
        automaticallyImplyLeading: true,
        backgroundColor: orange,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context,true);
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
              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).drawerTheme.backgroundColor,
                  // border: Border.all(color: Colors.black,width: 1
                  // )
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

                      for(int i =0 ; i< topLevelExpertise.length ; i++){
                        if(topLevelExpertise[i].name == "Health Care"){
                          categoryId = topLevelExpertise[i].id!;
                        }
                      }
                      bool result = await Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return HealthCareScreen(category: 1,categoryId: categoryId,topLevelExpertise: topLevelExpertise);
                      }));

                      if (result == true) {
                        selectedValue = null;
                      }
                    } else if (selectedValue == 2) {
                      for(int i =0 ; i< topLevelExpertise.length ; i++){
                        if(topLevelExpertise[i].name == "Weight Management"){
                          categoryId = topLevelExpertise[i].id!;
                        }
                      }
                      bool result = await Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return ManageWeightScreen(category: 2,categoryId: categoryId,topLevelExpertise: topLevelExpertise);
                      }));

                      if (result == true) {
                        selectedValue = null;
                      }
                    } else if (selectedValue == 3) {
                      for(int i =0 ; i< topLevelExpertise.length ; i++){
                        if(topLevelExpertise[i].name == "Fitness"){
                          categoryId = topLevelExpertise[i].id!;
                        }
                      }
                      bool result = await Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return FitnessScreen(category: 3,categoryId: categoryId,topLevelExpertise: topLevelExpertise);
                      }));

                      if (result == true) {
                        selectedValue = null;
                      }
                    } else if (selectedValue == 4) {
                      for(int i =0 ; i< topLevelExpertise.length ; i++){
                        if(topLevelExpertise[i].name == "Physiotherapy"){
                          categoryId = topLevelExpertise[i].id!;
                        }
                      }
                      bool result = await Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return PhysiotherapyScreen(category: 4,categoryId: categoryId,topLevelExpertise: topLevelExpertise);
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
                      for(int i =0 ; i< topLevelExpertise.length ; i++){
                        if(topLevelExpertise[i].name == "Live Well"){
                          categoryId = topLevelExpertise[i].id!;
                        }
                      }
                      bool result = await Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return LiveWellScreen(category: 6,categoryId: categoryId,topLevelExpertise: topLevelExpertise);
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
}
