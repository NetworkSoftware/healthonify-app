import 'dart:developer';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/health_care_actions/health_care_actions.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_dropdown.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/models/health_care/ayurveda_models/ayurveda_conditions_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/health_care/ayurveda_provider/ayurveda_provider.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/all_appointments_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/conditions_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care_appointments/healthcare_appointments.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AyurvedaScreen extends StatefulWidget {
  AyurvedaScreen(
      {Key? key,
      this.id,
      this.category,
      this.categoryId,
      this.topLevelExpertise})
      : super(key: key);
  int? category;
  String? categoryId;
  List<TopLevelExpertise>? topLevelExpertise;

  String? id;

  @override
  State<AyurvedaScreen> createState() => _AyurvedaScreenState();
}

class _AyurvedaScreenState extends State<AyurvedaScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  List<AyurvedaConditionsModel> ayurvedaConditions = [];
  int? selectedCategoryValue;
  bool isLoading = true;
  List<Category> categoryData = [];
  Future<void> fetchAyurvedaConditions() async {
    try {
      ayurvedaConditions =
          await Provider.of<AyurvedaProvider>(context, listen: false)
              .getAyurvedaConditions();

      log('fetched ayurveda conditions');
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching ayurveda conditions');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  late String userId;

  @override
  void initState() {
    super.initState();
    print("Ayurveda id : ${widget.id}");
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    selectedCategoryValue = widget.category;
    setState(() {
      categoryData = homeTopList;
    });
    fetchAyurvedaConditions().then(
      (value) {
        for (var ele in ayurvedaConditions) {
          treatmentConditions.add(ele.name);
        }
        log(treatmentConditions.toString());
      },
    );
  }

  String? requestCondition;
  List treatmentConditions = [];

  Map<String, dynamic> consultationData = {};

  Future<void> submitForm() async {
    LoadingDialog().onLoadingDialog("Please wait....", context);
    try {
      await Provider.of<HealthCareProvider>(context, listen: false)
          .consultSpecialist(consultationData);
      popFunction();
      Fluttertoast.showToast(msg: 'Consultation scheduled successfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error request appointment $e");
      Fluttertoast.showToast(msg: "Not able to submit your request");
    } finally {
      popFunction();
    }
  }

  void onSubmit() {
    consultationData['userId'] = userId;
    if (selectedTime != null) {
      consultationData['startTime'] = selectedTime;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation time');
      return;
    }
    if (ymdFormat != null) {
      consultationData['startDate'] = ymdFormat;
    } else {
      Fluttertoast.showToast(msg: 'Please select a consultation date');
      return;
    }
    consultationData['expertiseId'] = '6368b1870a7fad5713edb4b4';

    if (description != null) {
      consultationData['description'] = description;
    } else {
      Fluttertoast.showToast(
          msg: 'Please enter a brief description for your consultation');
      return;
    }

    log(consultationData.toString());
    submitForm();
  }

  void popFunction() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                  body: pageContent(context),
                ),
              );
            })


    );
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            const FlexibleAppBar(
              title: 'Ayurveda',
              listItems: AyurvedaTopButtons(),
            ),
          ];
        },
        body: pageContent(context),
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
                value: selectedCategoryValue,
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
                    selectedCategoryValue = value as int;
                    String categoryId = "";
                    if (selectedCategoryValue == 1) {

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
                        selectedCategoryValue = null;
                      }
                    } else if (selectedCategoryValue == 2) {
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
                        selectedCategoryValue = null;
                      }
                    } else if (selectedCategoryValue == 3) {
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
                        selectedCategoryValue = null;
                      }
                    } else if (selectedCategoryValue == 4) {
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
                        selectedCategoryValue = null;
                      }
                    } else if (selectedCategoryValue == 5) {
                      bool result = await Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return ConsultExpertsScreen(category: 5);
                      }));

                      if (result == true) {
                        selectedCategoryValue = null;
                      }
                    } else if (selectedCategoryValue == 6) {
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
                        selectedCategoryValue = null;
                      }
                    } else if (selectedCategoryValue == 7) {
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
                        selectedCategoryValue = null;
                      }
                    }

                    else if (selectedCategoryValue == 8) {
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
      ),
    );
  }

  Widget pageContent(context) {
    List imgs = [
      // 'assets/images/Picture17.jpg',
      {
        'image': 'assets/images/Picture17.jpg',
        'route': () {},
      },
    ];

    List mostSearchedConditions = [
      'Psoriasis',
      'Eczema',
      'Hair Loss',
      'Dandruff',
      'Arthritis',
      'Diabetes',
      'Obesity',
      'Thyroid',
      'Asthma',
    ];
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AyurvedaTopButtons(),
                CustomCarouselSlider(imageUrls: imgs),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Conditions we treat',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                GridView.builder(
                  padding: const EdgeInsets.all(4),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 136,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: ayurvedaConditions.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AyurvedaConditionsScreen(
                              condition: ayurvedaConditions[index].name,
                              conditionId: ayurvedaConditions[index].id,
                              ayurvedaId: "6368b1870a7fad5713edb4b4",
                            );
                          }));
                        },
                        // onTap: () => ayurvedaGridView[index]['onClick'](context),
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 42,
                                  width: 42,
                                  child: Image.network(
                                    ayurvedaConditions[index].mediaLink!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Image.asset(
                                //   ayurvedaGridView[index]["icon"],
                                //   height: 40,
                                //   width: 40,
                                // ),
                                const SizedBox(height: 10),
                                Text(
                                  ayurvedaConditions[index].name!,
                                  style: Theme.of(context).textTheme.labelSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
                                          AllAppointmentsScreen(flow: 'ayurveda'),
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .labelSmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                CustomCarouselSlider(imageUrls: imgs),
                Padding(
                  padding: const EdgeInsets.only(left: 16,top:8),
                  child: Text(
                    'Quick Links',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall,
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
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelSmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Most searched conditions',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                GridView.builder(
                  padding: const EdgeInsets.all(4),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 40,
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: ayurvedaMostSearchCondition.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () =>
                          ayurvedaMostSearchCondition[index]["onClick"](context),
                      child: Chip(
                        backgroundColor:
                            MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? Colors.grey[700]
                                : Colors.grey[300],
                        label: Text(
                          ayurvedaMostSearchCondition[index]['title'],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
    );
  }

  String? description;

  void requestAppointment(context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).canvasColor,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Treatment Condition',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: DropdownButtonFormField(
                  isDense: true,
                  items: treatmentConditions
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      requestCondition = newValue!;
                    });
                  },
                  value: requestCondition,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.25,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.25,
                      ),
                    ),
                    constraints: const BoxConstraints(
                      maxHeight: 56,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  hint: Text(
                    'Condition',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            datePicker(dateController);
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: dateController,
                              decoration: InputDecoration(
                                fillColor: Theme.of(context).canvasColor,
                                filled: true,
                                hintText: 'Date',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: const Color(0xFF717579),
                                    ),
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    datePicker(dateController);
                                  },
                                  child: Text(
                                    'PICK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: orange),
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                              cursorColor: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            timePicker(timeController);
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              controller: timeController,
                              decoration: InputDecoration(
                                fillColor: Theme.of(context).canvasColor,
                                filled: true,
                                hintText: 'Time',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: const Color(0xFF717579),
                                    ),
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    timePicker(timeController);
                                  },
                                  child: Text(
                                    'PICK',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(color: orange),
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                              cursorColor: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: SizedBox(
                  child: TextFormField(
                    maxLines: 5,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context).canvasColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Describe your issue',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onSubmit();
                    },
                    child: Text(
                      'Request Appointment',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  String? selectedTime;

  void timePicker(TextEditingController controller) {
    showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: customTimePickerTheme,
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }

      var todayDate = DateTime.now().toString().split(' ');

      log(todayDate[0]);

      log(ymdFormat.toString());
      if (ymdFormat.toString() == todayDate[0]) {
        print("ValueHour : ${value.hour}");
        if (value.hour < (DateTime.now().hour + 3)) {
          Fluttertoast.showToast(
              msg:
                  'Consultation time must be atleast 3 hours after current time');

          return;
        }
      }
      setState(() {
        var format24hrTime =
            '${value.hour.toString().padLeft(2, "0")}:${value.minute.toString().padLeft(2, "0")}:00';
        selectedTime = format24hrTime;
        log('24h time: $selectedTime');
        controller.text = value.format(context);
      });
    });
  }

  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat;

  void datePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? datePickerDarkTheme
              : datePickerLightTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        // log(value.toString());
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);
        ymdFormat = DateFormat('yyyy-MM-dd').format(temp);
        // log(ymdFormat!);
        formattedDate = DateFormat('d MMM yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;
      });
    });
  }

  List<Map<String, dynamic>> ayurvedaMostSearchCondition = [
    {
      "title": 'Psoriasis',
      "onClick": (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return const AyurvedaConditionsScreen(
                condition: "Skin Dermatology",
                conditionId: "6368b4e0338de470c41d0e77",
                ayurvedaId: "6368b1870a7fad5713edb4b4",
              );
            }));

      },
    },
    {
      "title": 'Eczema',
      "onClick": (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return const AyurvedaConditionsScreen(
                condition: "Skin Dermatology",
                conditionId: "6368b4e0338de470c41d0e77",
                ayurvedaId: "6368b1870a7fad5713edb4b4",
              );
            }));
      },
    },
    {
      "title": 'Hair Loss',
      "onClick": (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return const AyurvedaConditionsScreen(
                condition: "Hair Trichology",
                conditionId: "6368b4fc338de470c41d0e79",
                ayurvedaId: "6368b1870a7fad5713edb4b4",
              );
            }));
      },
    },
    {
      "title": 'Dandruff',
      "onClick": (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return const AyurvedaConditionsScreen(
                condition: "Skin Dermatology",
                conditionId: "6368b4e0338de470c41d0e77",
                ayurvedaId: "6368b1870a7fad5713edb4b4",
              );
            }));
      },
    },
    {
      "title": 'Arthritis',
      "onClick": (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return const AyurvedaConditionsScreen(
                condition: "Musuclo Skeletal",
                conditionId: "6368b523338de470c41d0e81",
                ayurvedaId: "6368b1870a7fad5713edb4b4",
              );
            }));
      },
    },
    {
      "title":'Diabetes',
      "onClick": (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return const AyurvedaConditionsScreen(
                condition: "Endocrine",
                conditionId: "6368b50a338de470c41d0e7d",
                ayurvedaId: "6368b1870a7fad5713edb4b4",
              );
            }));

      },
    },
    {
      "title": 'Obesity',
      "onClick": (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return const AyurvedaConditionsScreen(
                condition: "Endocrine",
                conditionId: "6368b50a338de470c41d0e7d",
                ayurvedaId: "6368b1870a7fad5713edb4b4",
              );
            }));
      },
    },
    {
      "title": 'Thyroid',
      "onClick": (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return const AyurvedaConditionsScreen(
                condition: "Endocrine",
                conditionId: "6368b50a338de470c41d0e7d",
                ayurvedaId: "6368b1870a7fad5713edb4b4",
              );
            }));
      },
    },
    {
      "title":  'Asthma',
      "onClick": (context) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) {
              return const AyurvedaConditionsScreen(
                condition: "Respiratory",
                conditionId: "6368b53b338de470c41d0e85",
                ayurvedaId: "6368b1870a7fad5713edb4b4",
              );
            }));
      },
    },
  ];
}
