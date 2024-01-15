import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/get_wm_package_type.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_packages.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/num_picker.dart';
import 'package:healthonify_mobile/widgets/text%20fields/create_package_fields.dart';
import 'package:provider/provider.dart';

class ExpertCreateWMPackage extends StatefulWidget {
  const ExpertCreateWMPackage({
    Key? key,
  }) : super(key: key);

  @override
  State<ExpertCreateWMPackage> createState() => _ExpertCreateWMPackageState();
}

class _ExpertCreateWMPackageState extends State<ExpertCreateWMPackage> {
  int _packageDurationValue = 1;
  int _noOfSessionsValue = 1;
  int _noOfDoctorSessions = 1;
  int _noOfFitnessSessions = 1;
  int _noOfImmunityCounselling = 1;
  int _noOfCustomDietPlans = 1;
  int _noOfFitnessPlans = 1;
  int _noOfDietSessions = 1;

  final _key = GlobalKey<FormState>();

  final Map<String, dynamic> wmData = {
    "name": "",
    "expertId": "",
    "expertiseId": "",
    "price": "",
    "durationInDays": 1,
    "sessionCount": 1,
    "doctorSessionCount": "",
    "fitnessGroupSessionCount": "",
    "immunityBoosterCounselling": "",
    "customizedDietPlan": "",
    "fitnessPlan": "",
    "freeGroupSessionAccess": true,
    "description": "",
    "benefits": "",
    "isActive": true,
    "frequency": "weekly",
    "packageTypeId": "",
  };

  void getPackageDurationValue(int i) =>
      setState(() => _packageDurationValue = i);
  void getNoOfSessionsValue(int i) => setState(() => _noOfSessionsValue = i);
  void getName(String value) => wmData["name"] = value;
  void getPrice(String value) => wmData["price"] = value;
  void getDesc(String value) => wmData["description"] = value;
  void getBenefits(String value) => wmData["benefits"] = value;
  void getDoctorsSessions(int i) => setState(() => _noOfDoctorSessions = i);
  void getFitnessSessions(int i) => setState(() => _noOfFitnessSessions = i);
  void getImmunityCounselling(int i) =>
      setState(() => _noOfImmunityCounselling = i);
  void getDietSession(int i) => setState(() => _noOfDietSessions = i);
  void getCustomDiet(int i) => setState(() => _noOfCustomDietPlans = i);
  void getFitnessPlan(int i) => setState(() => _noOfFitnessPlans = i);
  void getPackageType(String id) => wmData["packageTypeId"] = id;

  void onSubmit() {
    User userData = Provider.of<UserData>(context, listen: false).userData;
    if (!_key.currentState!.validate()) {
      return;
    }
    wmData["durationInDays"] = _packageDurationValue;
    wmData["doctorSessionCount"] = _noOfDoctorSessions;
    wmData["dietSessionCount"] = _noOfDietSessions;
    wmData["fitnessGroupSessionCount"] = _noOfFitnessSessions;
    wmData["immunityBoosterCounselling"] = _noOfImmunityCounselling;
    wmData["customizedDietPlan"] = _noOfCustomDietPlans;
    wmData["fitnessPlan"] = _noOfFitnessPlans;
    wmData["sessionCount"] = _noOfSessionsValue.toString();
    wmData["expertId"] = userData.id;
    wmData["expertiseId"] = "6229a9cd47494a4f8c77e149";
    _key.currentState!.save();
    createPackage(context, wmData);
  }

  void popFunc() {
    Navigator.of(context).pop();
  }

  Future<void> createPackage(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      await Provider.of<WmPackagesData>(context, listen: false)
          .createWmPackage(wmData);
      popFunc();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get func widget $e");
      Fluttertoast.showToast(msg: "Unable to save your package");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Create Package',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          physics: const BouncingScrollPhysics(),
          children: [
            Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpertPackageTextField(
                      getFunc: getName,
                      title: "Package Name",
                      hint: "Enter the package name"),
                  const SizedBox(
                    height: 10,
                  ),
                  ExpertPackageTextField(
                      getFunc: getPrice,
                      title: "Package Price",
                      textInputType: TextInputType.number,
                      hint: "Enter the package price"),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Type of package',
                    ),
                  ),
                  PackageTypeDropDown(
                    getValue: getPackageType,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text('Package duration'),
                            ChoosePackageDurationBtn(
                              func: showBottomSheet,
                              getV: getPackageDurationValue,
                              val: _packageDurationValue,
                            ),
                          ],
                        ),
                        const SizedBox(width: 6),
                        Column(
                          children: [
                            const Text('No of sessions'),
                            PackageSessionsBtn(
                              func: showBottomSheet,
                              getV: getNoOfSessionsValue,
                              val: _noOfSessionsValue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ExpertPackageTextField(
                      getFunc: getDesc,
                      title: "Package Description",
                      hint: "Enter the package description"),
                  const SizedBox(
                    height: 10,
                  ),
                  ExpertPackageTextField(
                      getFunc: getBenefits,
                      title: "Package Benefits",
                      hint: "Enter the package benefits"),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('No of doctor sessions'),
                      DoctorSessionsBtn(
                        func: showBottomSheet,
                        getV: getDoctorsSessions,
                        val: _noOfDoctorSessions,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('No of Diet sessions'),
                      DietPlansBtn(
                        func: showBottomSheet,
                        getV: getDietSession,
                        val: _noOfDietSessions,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('No of fitness group sessions'),
                      GroupFitnessSessionsBtn(
                        func: showBottomSheet,
                        getV: getFitnessSessions,
                        val: _noOfFitnessSessions,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Immunity booster counselling sessions'),
                      ImmunityCounselBtn(
                        func: showBottomSheet,
                        getV: getImmunityCounselling,
                        val: _noOfImmunityCounselling,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('No of customized diet plans'),
                      CustomDietBtn(
                        func: showBottomSheet,
                        getV: getCustomDiet,
                        val: _noOfCustomDietPlans,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('No of fitness plans'),
                      FitnessPlansBtn(
                        func: showBottomSheet,
                        getV: getFitnessPlan,
                        val: _noOfFitnessPlans,
                      ),
                    ],
                  ),
                  Center(
                    child: SaveButton(
                      isLoading: false,
                      submit: onSubmit,
                      title: "Create Package",
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showBottomSheet(
    context,
    String title,
    Function getVal,
    int minVal,
    int maxVal,
    int intialVal,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            NumPicker(
              minimumValue: minVal,
              maximumValue: maxVal,
              getNumber: getVal,
              initVal: intialVal,
            ),
          ],
        );
      },
    );
  }
}

class PackageTypeDropDown extends StatefulWidget {
  final Function getValue;
  const PackageTypeDropDown({
    required this.getValue,
    Key? key,
  }) : super(key: key);

  @override
  State<PackageTypeDropDown> createState() => _PackageTypeDropDownState();
}

class _PackageTypeDropDownState extends State<PackageTypeDropDown> {
  String? dropdownValue;

  Future<void> getWmPackageType() async {
    try {
      await Provider.of<GetWmPackageType>(context, listen: false)
          .getPackageType();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get package type widget $e");
      Fluttertoast.showToast(msg: "Unable get package type");
    }
  }

  String? idv;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWmPackageType(),
      builder: (context, snapshot) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Consumer<GetWmPackageType>(
          builder: (context, value, child) => DropdownButtonFormField(
            items:
                value.packageName.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            value: dropdownValue,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.25,
                ),
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey,
            ),
            isExpanded: true,
            borderRadius: BorderRadius.circular(13),
            elevation: 1,
            hint: const Text(
              'Choose option',
              style: TextStyle(color: Colors.teal),
            ),
            onSaved: (String? newValue) {
              int idx = value.packageName.indexOf(newValue!);
              idv = value.packageId[idx];
              widget.getValue(idv);
              log(idv.toString());
            },
            validator: (value) {
              if (value == null) {
                return 'Please select an option';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
