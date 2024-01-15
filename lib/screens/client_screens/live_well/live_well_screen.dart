// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_top_dropdown.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/live_well/live_well_models.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/live_well_providers/live_well_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/all_appointments_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blogs_widget.dart';
import 'package:healthonify_mobile/screens/client_screens/consult_experts.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/ayurveda.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/health_care.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/sub_categories.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/sub_category_scroller.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/physiotherapy_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/manage_weight_screen.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:healthonify_mobile/widgets/other/horiz_list_view/home_top_list_buttons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/health_care/health_care_expert/health_care_expert.dart';
import '../../../models/user.dart';
import '../../../providers/physiotherapy/enquiry_form_data.dart';
import '../../../widgets/buttons/custom_buttons.dart';
import '../../../widgets/text fields/support_text_fields.dart';

class LiveWellScreen extends StatefulWidget {
  LiveWellScreen({Key? key, this.category,this.categoryId, this.topLevelExpertise}) : super(key: key);
  int? category;
  String? categoryId;
  List<TopLevelExpertise>? topLevelExpertise;
  @override
  State<LiveWellScreen> createState() => _LiveWellScreenState();
}

class _LiveWellScreenState extends State<LiveWellScreen> {
  bool isLoading = true;
  List<LiveWellCategories> liveWellCategories = [];
  List<LiveWellCategories> liveWellSubCategories = [];
  int? selectedCategoryValue;
  List<Category> categoryData = [];
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  List<SubCategory> subCategoryData = [];
  List options = [
    "Physiotherapy",
    "Weight Management",
    "Fitness",
    "Travel",
    "Health Care",
    "Auyrveda",
    "De-stress",
    "Others"
  ];
  final _form = GlobalKey<FormState>();
  final Map<String, String> data = {
    "name": "",
    "email": "",
    "contactNumber": "",
    "userId": "",
    "enquiryFor": "",
    "message": "",
    "category": "",
  };

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

  String? startTime;
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
      // DateTime tempDate = _selectedDate!;
      var todayDate = DateTime.now().toString().split(' ');

      log(todayDate[0]);

      log("qwee${ymdFormat.toString()}");
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
        startTime = format24hrTime;
        log('24h time: $startTime');
        controller.text = value.format(context);
      });
    });
  }

  Future<void> getCategories() async {
    try {
      liveWellCategories =
          await Provider.of<LiveWellProvider>(context, listen: false)
              .getLiveWellCategories("master=1");
      log('fetched live well categories');

      log("${liveWellCategories[0].parentCategoryId}");
      liveWellSubCategories =
          await Provider.of<LiveWellProvider>(context, listen: false)
              .getLiveWellCategories(
                  "parentCategoryId=${liveWellCategories[0].parentCategoryId}");
      log('fetched live well sub categories');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting live well categories: $e");
      Fluttertoast.showToast(msg: "Unable to fetch live well categories");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  late String userName;
  String? description;
  Map<String, dynamic> requestAppointment = {};
  List<HealthCareExpert> expertData = [];
  late String userId;
  TextEditingController descController = TextEditingController();

  String? selectedValue;

  DateTime? _selectedDate;
  String? formattedDate;
  String? ymdFormat = DateFormat('yyyy-MM-dd').format(
      DateFormat('MM/dd/yyyy').parse(DateFormat.yMd().format(DateTime.now())));
  String? startDate;

  Future<void> getExperts() async {
    try {
      // expertData = await Provider.of<ExpertsData>(context, listen: false)
      //     .fetchHealthCareExpertsData(widget.expertId!);
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log("Error get fetch experts $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getExpertise() async {
    var topLevelExpertiseIdList =
        Provider.of<ExpertiseData>(context, listen: false)
            .topLevelExpertiseData;
    String? id;
    log("Get exp");
    for (var element in topLevelExpertiseIdList) {
      log("check");

      if (element.name == "Live Well") {
        id = element.id!;
        log("Live Well");
      }
    }
    try {
      await Provider.of<ExpertiseData>(context, listen: false)
          .fetchExpertise(id!);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get fetch expertise $e");
      Fluttertoast.showToast(msg: "Unable to fetch expertise");
    }
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
    super.initState();
    subCategory();
    //getTopLevelExpertise(context);
    getExpertise();
    userName =
        Provider.of<UserData>(context, listen: false).userData.firstName!;
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    getCategories();
    selectedCategoryValue = widget.category;
    setState(() {
      categoryData = homeTopList;
    });
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context).userData;
    setData(userData);
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
                body: liveWellContent(context),
              ),
            );
          })


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
                  //border: Border.all(color: Colors.black,width: 1)
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

  Widget liveWellContent(context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LiveWellTopList(),
                CustomCarouselSlider(imageUrls: [
                  {
                    'image': 'assets/images/livewell/livewell1.jpg',
                    'route': () {},
                  },
                  {
                    'image': 'assets/images/livewell/livewell2.jpg',
                    'route': () {},
                  },
                  {
                    'image': 'assets/images/livewell/livewell3.jpg',
                    'route': () {},
                  },
                  {
                    'image': 'assets/images/livewell/livewell4.jpg',
                    'route': () {},
                  },
                ]),
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
                                          AllAppointmentsScreen(flow: 'liveWell'),
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
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: liveWellCategories.length,
                  itemBuilder: (context, verticalIndex) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                liveWellCategories[verticalIndex].name!,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              TextButton(
                                onPressed: () {
                                  log(liveWellCategories[verticalIndex]
                                      .parentCategoryId!);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SubCategoriesScreen(
                                      screenTitle:
                                          liveWellCategories[verticalIndex]
                                              .name!,
                                      parentCategoryId:
                                          liveWellCategories[verticalIndex]
                                              .parentCategoryId!,
                                    );
                                  }));
                                },
                                child: const Text('show all'),
                              ),
                            ],
                          ),
                        ),
                        SubCategoryScroller(
                          parentCategoryId: liveWellCategories[verticalIndex]
                              .parentCategoryId!,
                        ),
                      ],
                    );
                  },
                ),
                const BlogsWidget(expertiseId: ""),
              ],
            ),
          );
  }

  void popFunction() {
    Navigator.pop(context);
  }

  bool isFormSubmitting = false;

  Future<void> submitForm() async {
    try {
      await Provider.of<EnquiryData>(context, listen: false)
          .submitEnquiryForm(data);
      Fluttertoast.showToast(
          msg: "Appointment Requested, an expert will get back to you soon");
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      // Fluttertoast.showToast(msg: "Not able to submit your request");
    } finally {
      Navigator.of(context).pop();
    }
  }

  void setData(User userData) {
    data["name"] = userData.firstName!;
    data["email"] = userData.email!;
    data["contactNumber"] = userData.mobile ?? "";
    data["enquiryFor"] = "generalEnquiry";
    data["category"] = "";
    data["userId"] = userData.id!;
    data["message"] = "";
    data["date"] = "";
    data["time"] = "";
    data["flow"] = "liveWell";
  }

  void onSubmit() {
    if (!_form.currentState!.validate()) {
      // setState(() => isLoading = false);
      return;
    }
    if (selectedValue == null) {
      Fluttertoast.showToast(msg: "Please choose a value from the dropdown");
    }
    if (dateController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please choose any date");
    }
    if (timeController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please choose time");
    }
    data["enquiryFor"] = selectedValue!;
    data["category"] = "Live Well";
    data["date"] = startDate!;
    data["time"] = startTime!;
    _form.currentState!.save();
    log(data.toString());
    submitForm();
  }

  void datePicker(TextEditingController controller) {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: datePickerDarkTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      if (value == null) {
        return;
      }
      // var todayDate = DateTime.now().toString().split(' ');
      //
      // log(todayDate[0]);
      //
      // log(ymdFormat.toString());
      //
      //   print("ValueHour : ${value.hour}");
      //   if (value.hour < (DateTime.now().hour + 3)) {
      //     Fluttertoast.showToast(
      //         msg:
      //         'Consultation time must be atleast 3 hours after current time');
      //
      //     return;
      //   }

      setState(() {
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);

        // if (temp.isBefore(DateTime.now())) {
        //   Fluttertoast.showToast(msg: 'Please select a valid date');
        //   return;
        // }

        startDate = DateFormat('yyyy/MM/dd').format(temp);
        log('start date:  $startDate');
        ymdFormat = DateFormat('yyyy-MM-dd').format(temp);
        formattedDate = DateFormat('d MMM yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;
      });
    });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        elevation: 10,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Form(
                  key: _form,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom + 1),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      Center(
                        child: Text(
                          "Request Appointment",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      StatefulBuilder(
                        builder: (context, newState) =>
                            Consumer<ExpertiseData>(
                              builder: (context, data, child) {
                                List<String> options = [];
                                List<String> id = [];
                                for (var element in data.expertise) {
                                  options.add(element.name!);
                                  id.add(element.id!);
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: DropdownButtonFormField(
                                    isDense: true,
                                    items:
                                    options.map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      newState(() {
                                        selectedValue = newValue!;
                                      });
                                    },
                                    value: selectedValue,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                          width: 1.25,
                                        ),
                                      ),
                                      constraints: const BoxConstraints(
                                        maxHeight: 56,
                                      ),
                                      contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    hint: Text(
                                      'Select',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.grey),
                                    ),
                                  ),
                                );
                              },
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Explain your issue",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            IssueField(getValue: (value) {
                              data["message"] = value;
                            }),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Center(
                          child: SaveButton(
                        isLoading: false,
                        submit: onSubmit,
                        title: "Request Now",
                      )),
                    ]),
                  ),
                ),
              ),
            ));
  }
}
