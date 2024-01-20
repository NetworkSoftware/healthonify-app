import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/hra_model/hra_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_risk_assessment/hra_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class HraQuestionnaire extends StatefulWidget {
  const HraQuestionnaire({Key? key}) : super(key: key);

  @override
  State<HraQuestionnaire> createState() => _HraQuestionnaireState();
}

class _HraQuestionnaireState extends State<HraQuestionnaire> {
  String? userId;
  bool isLoading = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController heightFeetController = TextEditingController();
  TextEditingController waistController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<HraModel> hraQuestions = [];
  String? dropdownValue;
  List dropDownOptions = ['Male', 'Female', 'Other'];

  void getGender(String value) => {
        setState(() {
          dropdownValue = value;
        })
      };

  sendData() async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    log(userId!);
    log(heightController.text);
    await Provider.of<HraProvider>(context, listen: false).updateHraDetails(
        userId: userId,
        height: heightController.text,
        waist: waistController.text,
        weight: weightController.text,
        gender: dropdownValue,
        age: ageController.text);
  }

  Future<void> getHraQuestions() async {
    try {
      hraQuestions =
          await Provider.of<HraProvider>(context, listen: false).getQuestions();
      log('hra questions fetched');
    } on HttpException catch (e) {
      log("Unable to fetch hra questions $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error loading hra questions $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> postHraAnswers() async {
    LoadingDialog().onLoadingDialog("Please wait.....", context);
    try {
      await Provider.of<HraProvider>(context, listen: false)
          .postHraAnswers(answersMap);

      popFunction();
      Fluttertoast.showToast(msg: 'HRA completed');
    } on HttpException catch (e) {
      log("Unable to post hra answers $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error posting hra answers $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {}
  }

  List<Map<String, dynamic>> hraAnswers = [];
  Map<String, dynamic> answersMap = {};
  String? radioAnswer;
  int? radioPoints;
  int? i;

  void onSubmit() {
    answersMap['userId'] = userId;
    answersMap['date'] = DateFormat("yyyy-MM-dd").format(DateTime.now());
    answersMap['answers'] = hraAnswers;
    log(json.encode(answersMap));
    postHraAnswers();
  }

  void popFunction() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context, true);
  }

  PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;

    getHraQuestions();
  }

  Object? groupVal;
  int current = 0;

  void conversion(double centimeter) {
    double inches = 0.3937 * centimeter;
    double feet = 0.0328 * centimeter;
    log(inches.toString());
    heightFeetController.text = feet.toStringAsFixed(2);
  }

  void conversionToCms(double feet) {
    double cms = feet / 0.0328;

    heightController.text = cms.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Health Risk Assessment'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: StatefulBuilder(
                builder: (context, newState) => SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: pageController,
                          itemCount: hraQuestions.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return questionnaireFormCard();
                            } else {
                              return questionnaireCards(
                                context,
                                index,
                                hraQuestions[index].question!,
                                hraQuestions[index].options!,
                              );
                            }
                          },
                          onPageChanged: (index) {
                            newState(
                              () {
                                current = index;
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: darkGrey,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.chevron_left_rounded,
                                    size: 30,
                                    color: whiteColor,
                                  ),
                                  Text(
                                    'EXIT',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          color: whiteColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(width: 14),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: current == 0
                                  ? () async {
                                      if (!formKey.currentState!.validate()) {
                                        Fluttertoast.showToast(
                                          msg: 'Please answer all questions',
                                        );
                                        return;
                                      } else {
                                        await sendData();
                                        await pageController.nextPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.linear,
                                        );
                                      }
                                    }
                                  : current ==
                                          hraQuestions
                                              .indexOf(hraQuestions.last)
                                      ? () {
                                          hraAnswers.add(
                                            {
                                              'questionId':
                                                  hraQuestions[current]
                                                      .questionId,
                                              'answer': radioAnswer,
                                              'points': radioPoints,
                                            },
                                          );
                                          //! onSubmit function !//
                                          onSubmit();
                                        }
                                      : groupVal == null
                                          ? () {
                                              Fluttertoast.showToast(
                                                msg: 'Please choose an answer',
                                              );
                                              log(groupVal.toString());
                                            }
                                          : () {
                                              groupVal = null;

                                              pageController.nextPage(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.linear,
                                              );
                                              hraAnswers.add(
                                                {
                                                  'questionId':
                                                      hraQuestions[current]
                                                          .questionId,
                                                  'answer': radioAnswer,
                                                  'points': radioPoints,
                                                },
                                              );
                                            },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 14),
                                  Text(
                                    current ==
                                            hraQuestions
                                                .indexOf(hraQuestions.last)
                                        ? 'DONE'
                                        : 'NEXT',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          color: whiteColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 30,
                                    color: whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget questionnaireFormCard() {
    return StatefulBuilder(
      builder: (context, newState) {
        return SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Height in cms',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: heightController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please anser all questions';
                                    } else {}
                                    return null;
                                  },
                                  onChanged: (value) {
                                    if (heightController.text.isEmpty) {
                                      heightFeetController.clear();
                                    } else {
                                      conversion(double.parse(value));
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    // constraints: const BoxConstraints(
                                    //   minHeight: 46,
                                    //   maxWidth: 52,
                                    // ),
                                    hintText: 'Height in cms',
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF959EAD),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Height in feet',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: heightFeetController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please anser all questions';
                                    } else {}
                                    return null;
                                  },
                                  onChanged: (value) {
                                    if (heightFeetController.text.isEmpty) {
                                      heightController.clear();
                                    } else {
                                      conversionToCms(double.parse(value));
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    // constraints: const BoxConstraints(
                                    //   minHeight: 46,
                                    //   maxWidth: 52,
                                    // ),
                                    hintText: 'Height in feet',
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF959EAD),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                questioFormField(
                    controller: weightController, title: 'Weight in kgs'),
                questioFormField(
                    controller: waistController, title: 'Waist in inches'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Gender',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Container(
                                  height: 70,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // color: Colors.white,
                                      border: Border.all(color: Colors.grey)),
                                  child: Center(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      icon: const Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Color(0xFF959EAD),
                                            size: 26),
                                      ),
                                      hint: const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "Select Gender",
                                          style: TextStyle(
                                              color: Color(0xFF959EAD),
                                              fontSize: 18),
                                        ),
                                      ),
                                      underline: const SizedBox(),
                                      items: dropDownOptions.map((gender) {
                                        return DropdownMenuItem<String>(
                                          value: gender,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              gender,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (dynamic newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                        });
                                      },
                                      value: dropdownValue,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Age',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: ageController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please anser all questions';
                                    } else {}
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    // constraints: const BoxConstraints(
                                    //   minHeight: 46,
                                    //   maxWidth: 52,
                                    // ),
                                    hintText: 'Age',
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF959EAD),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget questioFormField({TextEditingController? controller, String? title}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: controller,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please anser all questions';
              } else {}
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(
                minHeight: 46,
                maxWidth: 52,
              ),
              hintText: title,
              hintStyle: const TextStyle(
                color: Color(0xFF959EAD),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget questionnaireCards(
    context,
    index,
    String question,
    List<Options> radOptions,
  ) {
    return StatefulBuilder(
      builder: (context, newState) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  question,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              RadioListBuilder(
                radioOptions: radOptions,
                answerPoints: (index, ind) {
                  newState(() {
                    radioAnswer = radOptions[index].optionValue!;
                    radioPoints = radOptions[index].points!;
                    groupVal = ind;
                    setState(() {});
                  });
                },
                groupValue: groupVal,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget dropdownDialog(
    List options,
    String title,
    Function getFunc,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: grey,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          onTap: () {
            showPopUp(options, title, getFunc);
          },
          tileColor: Theme.of(context).canvasColor,
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey,
            size: 26,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }

  void showPopUp(List options, String title, Function getFunc) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        getFunc(options[index]);
                      },
                      title: Text(
                        options[index],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}

class RadioListBuilder extends StatefulWidget {
  final List<Options> radioOptions;
  final Function(int index, Object? ind) answerPoints;
  final Object? groupValue;

  const RadioListBuilder({
    required this.radioOptions,
    required this.answerPoints,
    this.groupValue,
    Key? key,
  }) : super(key: key);

  @override
  State<RadioListBuilder> createState() => _RadioListBuilderState();
}

class _RadioListBuilderState extends State<RadioListBuilder> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.radioOptions.length,
      itemBuilder: (context, index) {
        return RadioListTile(
          value: index,
          groupValue: widget.groupValue,
          onChanged: (ind) {
            setState(() {
              widget.answerPoints(index, ind);
            });
          },
          title: Text(
            widget.radioOptions[index].optionValue!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
    );
  }
}
