import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/constants/wl_enquiry_options.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/num_picker.dart';
import 'package:healthonify_mobile/widgets/text%20fields/weight_enquiry.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';

class WeightLossEnquiry extends StatefulWidget {
  final bool isFitnessFlow;
  const WeightLossEnquiry({required this.isFitnessFlow, Key? key})
      : super(key: key);

  @override
  State<WeightLossEnquiry> createState() => _WeightLossEnquiryState();
}

class _WeightLossEnquiryState extends State<WeightLossEnquiry> {
  final _formKey = GlobalKey<FormState>();
  int initAge = 18;

  @override
  void initState() {
    super.initState();
    getExpertise();
  }

  final Map<String, String> _enqData = {
    "userId": "",
    "role": "",
    "name": "",
    "email": "",
    "contactNumber": "",
    "age": "",
    "gender": "",
    "enquiryFor": "",
    "healthConditions": "",
    "profession": "",
    "prefferedLanguage": "",
    "message": "",
    "flow": "manageWeight",
    "category": "Weight Management",
  };

  void getAge(String age) => _enqData['age'] = age;
  void getGender(String gender) => _enqData['gender'] = gender;
  void getEnqFor(String enquiryFor) => _enqData['enquiryFor'] = enquiryFor;
  void getHealthCond(String healthConditions) =>
      _enqData['healthConditions'] = healthConditions;
  void getProfession(String profession) => _enqData['profession'] = profession;
  void getLanguage(String prefferedLanguage) =>
      _enqData['prefferedLanguage'] = prefferedLanguage;
  void getMessage(String message) => _enqData['message'] = message;

  bool isLoading = false;

  void popFunc() {
    Navigator.of(context).pop();
  }

  void onSubmit(BuildContext context) {
    log('on submit called');
    isLoading = true;
    if (!_formKey.currentState!.validate()) {
      isLoading = false;
      return;
    }

    _formKey.currentState!.save();
    _enqData['role'] = 'client';
    _enqData['age'] = initAge.toString();
    submitForm();
    isLoading = false;
    log(_enqData.toString());
  }

  // Future<void> wlEnquiry(BuildContext context) async {
  //   try {
  //     await Provider.of<WMEnqProvider>(context, listen: false)
  //         .postWMdata(_enqData);
  //     popFunc();
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //     Fluttertoast.showToast(msg: e.message);
  //   } catch (e) {
  //     log("Error weight loss enquiry $e");
  //     Fluttertoast.showToast(msg: "Error : $e");
  //   }
  // }

  Future<void> submitForm() async {
    try {
      await Provider.of<EnquiryData>(context, listen: false)
          .submitEnquiryForm(_enqData);
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

  void setUserData(User userData) {
    _enqData['name'] = "${userData.firstName!} ${userData.lastName!}";
    _enqData['email'] = userData.email!;
    _enqData['contactNumber'] = userData.mobile!;
    _enqData['userId'] = userData.id!;
  }

  Future<void> getExpertise() async {
    var topLevelExpertiseIdList =
        Provider.of<ExpertiseData>(context, listen: false)
            .topLevelExpertiseData;
    String? id;
    log("Get exp");
    for (var element in topLevelExpertiseIdList) {
      log("check");

      if (element.name == "Weight Management") {
        id = element.id!;
        log("Weight Management");
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

  List<ValueItem> options = [
    const ValueItem(label: 'Thyroid', value: '1'),
    const ValueItem(label: 'Acidity', value: '2'),
    const ValueItem(label: 'Cholestrol', value: '3'),
    const ValueItem(label: 'Knee Pain', value: '4'),
    const ValueItem(label: 'Back Pain', value: '5'),
    const ValueItem(label: 'Diabetes (T2)', value: '6'),
    const ValueItem(label: 'Blood Pressure', value: '7'),
    const ValueItem(label: 'Pre Diabetes', value: '8'),
    const ValueItem(label: 'PCOD', value: '9'),
    const ValueItem(label: 'Others', value: '10'),
    const ValueItem(label: 'None', value: '11'),
  ];

  List<String> selectedCondition = [];

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context).userData;
    setUserData(userData);
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Request Consultation',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enquiry for',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Consumer<ExpertiseData>(
                builder: (context, data, child) {
                  List<String> options = [];
                  List<String> id = [];
                  for (var element in data.expertise) {
                    options.add(element.name!);
                    id.add(element.id!);
                  }
                  return WeightEnqDropDown(
                    dropDownValues: options,
                    getValue: getEnqFor,
                  );
                },
              ),

              Text(
                'Do you have any of these conditions?',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              // WeightEnqDropDown(
              //   dropDownValues: wlHealthConditions,
              //   getValue: getHealthCond,
              // ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: MultiSelectDropDown(
                  onOptionSelected: (options) {
                    debugPrint("check this ${options.toString()}");
                    selectedCondition.clear();
                    for (int i = 0; i < options.length; i++) {
                      selectedCondition.add(options[i].label);
                    }

                    getHealthCond(selectedCondition.join(","));
                  },
                  options: options,
                  borderWidth: 1,
                  focusedBorderWidth: 2,
                  selectionType: SelectionType.multi,
                  backgroundColor:
                      Theme.of(context).drawerTheme.backgroundColor,
                  hint: 'Choose option',
                  hintStyle: const TextStyle(fontSize: 16, color: Colors.teal),
                  chipConfig: ChipConfig(
                      wrapType: WrapType.scroll,
                      backgroundColor: Theme.of(context).canvasColor,
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      deleteIconColor: orange),
                  dropdownHeight: 300,
                  optionsBackgroundColor:
                      Theme.of(context).drawerTheme.backgroundColor,
                  selectedOptionBackgroundColor:
                      Theme.of(context).drawerTheme.backgroundColor,
                  optionTextStyle: Theme.of(context).textTheme.bodyMedium,
                  selectedOptionIcon:
                      const Icon(Icons.check_circle, color: orange),
                  suffixIcon: Icons.keyboard_arrow_down_rounded,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Profession',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              WeightEnqDropDown(
                dropDownValues: professions,
                getValue: getProfession,
              ),
              Text(
                'Enter your age',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all()),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => {
                        showBottomSheet(context),
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TextButton(
                              onPressed: null,
                              child: Text(
                                'Enter your age',
                              ),
                            ),
                            Text(
                              '$initAge yrs',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Select your gender',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              WeightEnqDropDown(
                dropDownValues: genderList,
                getValue: getGender,
              ),
              Text(
                'Please select your preferred language',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              WeightEnqDropDown(
                dropDownValues: preferredLanguages,
                getValue: getLanguage,
              ),
              Text(
                'Message',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              MessageField(getValue: getMessage),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientButton(
                    title: 'Submit Enquiry',
                    func: () {
                      onSubmit(context);
                      log(_enqData.toString());
                    },
                    gradient: orangeGradient,
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void showBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 12,
            ),
            Text(
              'Enter your age',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            NumPicker(
              minimumValue: 18,
              maximumValue: 100,
              getNumber: (value) {
                setState(() {
                  initAge = value;
                });
              },
              initVal: 18,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Confirm',
                  style: Theme.of(context).textTheme.labelMedium!,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        );
      },
    );
  }
}

class WeightEnqDropDown extends StatefulWidget {
  final List<String> dropDownValues;
  final Function getValue;
  const WeightEnqDropDown({
    required this.getValue,
    required this.dropDownValues,
    Key? key,
  }) : super(key: key);

  @override
  State<WeightEnqDropDown> createState() => _WeightEnqDropDownState();
}

class _WeightEnqDropDownState extends State<WeightEnqDropDown> {
  String? dropdownValue;
  // String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: DropdownButtonFormField(
        items:
            widget.dropDownValues.map<DropdownMenuItem<String>>((String value) {
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
        isExpanded: false,
        borderRadius: BorderRadius.circular(13),
        elevation: 1,
        hint: const Text(
          'Choose option',
          style: TextStyle(color: Colors.teal),
        ),
        onSaved: (value) {
          widget.getValue(value);
        },
        validator: (value) {
          log('validator reached');
          if (value == null) {
            log('if entered');
            return 'Please select an option';
          }
          return null;
        },
      ),
    );
  }
}
