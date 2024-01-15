import 'dart:developer';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_dropdown.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blogs_widget.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/expert_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/ayurveda.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/fitness_tools_card.dart';
import 'package:healthonify_mobile/widgets/cards/health_app_sync_card.dart';
import 'package:healthonify_mobile/widgets/cards/home_cards.dart';
import 'package:healthonify_mobile/widgets/physio/physio_my_appointments_card.dart';
import 'package:healthonify_mobile/widgets/cards/quick_actions_card.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/shop_list.dart';
import 'package:healthonify_mobile/widgets/physio/physio_top_list.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/user.dart';
import '../../../providers/user_data.dart';

class PhysiotherapyScreen extends StatefulWidget {
  PhysiotherapyScreen({Key? key, this.category,this.categoryId, this.topLevelExpertise}) : super(key: key);
  int? category;
  String? categoryId;
  List<TopLevelExpertise>? topLevelExpertise;
  @override
  State<PhysiotherapyScreen> createState() => _PhysiotherapyScreenState();
}

class _PhysiotherapyScreenState extends State<PhysiotherapyScreen> {
  final List? expNames = [];
  List<SubCategory> subCategoryData = [];
  bool isloading = true;

  List<User> experts = [];
  int? selectedValue;
  List<Category> categoryData = [];
  String? id;

  Future<void> fetchExperts() async {
    try {
      experts = await Provider.of<UserData>(context, listen: false)
          .getPhysioTherepists();
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

  @override
  void initState() {
    fetchExperts();
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
    var topLevelExpertiseIdList =
        Provider.of<ExpertiseData>(context).topLevelExpertiseData;

    for (var element in topLevelExpertiseIdList) {
      if (element.name == "Physiotherapy") {
        id = element.id!;
      }
    }
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context,true);
        return true;
      },
      child: Consumer<ExpertiseData>(
          builder: (context, categoryData, child) {
            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    flexibleAppBar(context,categoryData.topLevelExpertiseData),
                  ];
                },
                body: physioContent(context),
              ),
            );
          }
      )


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
                 // border: Border.all(color: Colors.black,width: 1)
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
                     // launchUrl(Uri.parse("https://healthonify.com/Shop"));
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

  Widget physioContent(context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhysioTopList(id: id),
          CustomCarouselSlider(imageUrls: [
            {
              'image': 'assets/images/physio/physio1.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/physio/physio2.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/physio/physio3.jpg',
              'route': () {},
            },
          ]),
          const SizedBox(
            height: 25,
          ),
          PhysioMyAppoinmentsCard(
            onRequest: () {
              // showDatePicker(
              //   context: context,
              //   builder: (context, child) {
              //     return Theme(
              //       data: MediaQuery.of(context).platformBrightness ==
              //               Brightness.dark
              //           ? datePickerDarkTheme
              //           : datePickerLightTheme,
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
          const SizedBox(
            height: 5,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: ConditionsButton()),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: BodyPartsButton(),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const QuickActionCard3(),
          const SizedBox(
            height: 25,
          ),
          CustomCarouselSlider(imageUrls: [
            {
              'image': 'assets/images/physio/physio4.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/physio/physio5.jpg',
              'route': () {},
            },
          ]),
          const SizedBox(
            height: 25,
          ),
          const FitnessToolsCard(),
          const BlogsWidget(expertiseId: "6229a980305897106867f787"),
          const SizedBox(
            height: 25,
          ),
          const PhysioScreenCard(),
          // const SizedBox(
          //   height: 5,
          // ),
          //const SyncHealthAppCard(),
          const SizedBox(
            height: 25,
          ),
          CustomCarouselSlider(imageUrls: [
            {
              'image': 'assets/images/physio/physio6.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/physio/physio7.jpg',
              'route': () {},
            },
            {
              'image': 'assets/images/physio/physio8.jpg',
              'route': () {},
            },
          ]),
          const SizedBox(
            height: 5,
          ),
          // const ShopList(
          //   image:
          //       "https://cdn.shopify.com/s/files/1/0005/5335/3267/products/WPC_1000g_Creatine_100g_grande.jpg?v=1648204173",
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Our Experts',
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
          )
        ],
      ),
    );
  }
}
