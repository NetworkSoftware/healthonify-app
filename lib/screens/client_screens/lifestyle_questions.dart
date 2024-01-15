import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/lifestyle_providers/lifestyle_providers.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class LifestyleQuestionsScreen extends StatefulWidget {
  const LifestyleQuestionsScreen({Key? key}) : super(key: key);

  @override
  State<LifestyleQuestionsScreen> createState() =>
      _LifestyleQuestionsScreenState();
}

class _LifestyleQuestionsScreenState extends State<LifestyleQuestionsScreen> {
  String? sleepTime;
  String? wakeupTime;

  String? maritalStat;
  List maritalStatus = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];
  String? numberOfChildren;
  List children = List<String>.generate(
    11,
    (int index) => '$index',
    growable: false,
  );
  List hours = List<String>.generate(
    13,
    (int index) => '$index',
    growable: false,
  );
  List presentHealthMap = [
    {'title': 'Exercise', 'value': false},
    {'title': 'Healthy Diet', 'value': false},
    {'title': 'Chiropractor', 'value': false},
    {'title': 'Medical Doctor', 'value': false},
    {'title': 'Vitamins', 'value': false},
    {'title': 'Minerals', 'value': false},
    {'title': 'Herbs', 'value': false},
    {'title': 'Prescription medicines', 'value': false},
    {'title': 'Relaxation techniques', 'value': false},
    {'title': 'Acupuncture', 'value': false},
    {'title': 'Meditation', 'value': false},
    {'title': 'Other', 'value': false},
  ];
  List stress = [
    'Minimal',
    'Average',
    'Considerable',
    'Unbearable',
  ];

  List frequency = [
    'Once a week',
    '2 days a week',
    '3 days a week',
    '4 days a week',
    '5 days a week',
    '6 days a week',
    '7 days a week',
  ];
  List shortOptions = [
    'Yes',
    'No',
  ];
  List options = [
    'Yes',
    'No',
    'Sometimes',
  ];

  // text field variables
  String healthConcerns = "";
  String feeling = "";
  String causes = "";
  String stressLooksLike = "";
  String copingMechanisms = "";
  String typicalEnergy = "";
  String occupation = "";
  String workTimings = "";
  String noOfCigarettes = "";
  String exercise = "";
  String interestAndHobbies = "";
  String lastVacation = "";

  //dropdown variables
  String? traumaOrLoss;
  String? stressLevel;
  String? hoursOfSleep;
  String? wellRested;
  String? noOfWorkHours;
  String? enjoyWork;
  String? smoke;
  String? secondHandSmoke;
  String? driving;
  String? tv;
  String? reading;
  String? socialMedia;
  String? computer;
  String? walking;
  String? exerciseFrequency;
  String? vacations;
  String? spiritualGroups;

  //checkbox list
  List presentHealth = [];

  Map<String, dynamic> lifestyleMap = {};

  late String userId;

  @override
  void initState() {
    super.initState();

    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    lifestyleMap = {
      "userId": userId,
      "qna": [
        {
          "question": "Marital Status",
          "answer": [],
        },
        {
          "question": "Number of Children",
          "answer": [],
        },
        {
          "question": "What are your main health concerns?",
          "answer": [healthConcerns],
        },
        {
          "question": "How are you feeling?",
          "answer": [feeling],
        },
        {
          "question": "What are you doing for your health presently?",
          "answer": presentHealth,
        },
        {
          "question":
              "What do you believe might be the causes or underlying factors of your current health condition?",
          "answer": [causes],
        },
        {
          "question":
              "Have you experienced any level of trauma or loss in the past?",
          "answer": [],
        },
        {
          "question":
              "What level of stress are you experiencing during this time in your life?",
          "answer": [stressLevel],
        },
        {
          "question": "What does your stress look like?",
          "answer": [stressLooksLike],
        },
        {
          "question": "Do you have any coping mechanisms for your stress?",
          "answer": [copingMechanisms],
        },
        {
          "question": "How many hours do you sleep daily on an average?",
          "answer": [hoursOfSleep],
        },
        {
          "question": "What time do you go to sleep?",
          "answer": [sleepTime],
        },
        {
          "question": "What time do you usually wake up?",
          "answer": [wakeupTime],
        },
        {
          "question": "When you wake up, do you feel well rested?",
          "answer": [wellRested],
        },
        {
          "question": "What is your typical energy level?",
          "answer": [typicalEnergy],
        },
        {
          "question": "What is your occupation?",
          "answer": [occupation],
        },
        {
          "question": "How many hours do you work everyday?",
          "answer": [noOfWorkHours],
        },
        {
          "question": "What time do you start and end work?",
          "answer": [workTimings],
        },
        {
          "question": "Do you enjoy your work?",
          "answer": [enjoyWork],
        },
        {
          "question": "Do you smoke cigarettes?",
          "answer": [smoke],
        },
        {
          "question": "If yes, how many?",
          "answer": [noOfCigarettes],
        },
        {
          "question": "If no, have you ever been exposed to second hand smoke?",
          "answer": [secondHandSmoke],
        },
        {
          "question":
              "How many hours do you spend daily on an average driving?",
          "answer": [driving],
        },
        {
          "question":
              "How many hours do you spend daily on an average watching TV?",
          "answer": [tv],
        },
        {
          "question":
              "How many hours do you spend daily on an average reading?",
          "answer": [reading],
        },
        {
          "question":
              "How many hours do you spend daily on an average on social media?",
          "answer": [socialMedia],
        },
        {
          "question":
              "How many hours do you spend daily on an average using computer?",
          "answer": [computer],
        },
        {
          "question":
              "How many hours do you spend daily on an average walking?",
          "answer": [walking],
        },
        {
          "question": "What do you do for exercise?",
          "answer": [exercise],
        },
        {
          "question": "How frequently do you exercise?",
          "answer": [exerciseFrequency],
        },
        {
          "question": "What are your interests and hobbies?",
          "answer": [interestAndHobbies],
        },
        {
          "question": "Do you take vacations regularly?",
          "answer": [vacations],
        },
        {
          "question": "When was your last vacation?",
          "answer": [lastVacation],
        },
        {
          "question": "Do you actively participate in spiritual groups?",
          "answer": [spiritualGroups],
        },
      ],
    };
  }

  bool isloading = false;

  Future<void> uploadLifestyle() async {
    setState(() {
      isloading = true;
    });
    try {
      await Provider.of<LifeStyleProviders>(context, listen: false)
          .postLifestyleData(lifestyleMap);
      popFunction();
      Fluttertoast.showToast(msg: 'Lifestyle form posted');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to lifestyle form');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  void onSubmit() {
    uploadLifestyle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Lifestyle'),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text('Marital Status'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: maritalStatus
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            maritalStat = newValue!;
                            temp[0] = maritalStat;
                            lifestyleMap['qna'][0]['answer'] = temp;
                          });
                        },
                        value: maritalStat,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('Number of Children'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: children.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            numberOfChildren = newValue!;
                            temp[0] = numberOfChildren;
                            lifestyleMap['qna'][1]['answer'] = temp;
                          });
                        },
                        value: numberOfChildren,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('What are your main health concerns?'),
                    const SizedBox(height: 10),
                    textFields(
                      context,
                      (value) {
                        List temp = [""];
                        setState(() {
                          healthConcerns = value;
                          temp[0] = healthConcerns;
                          lifestyleMap['qna'][2]['answer'] = temp;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('How are you feeling?'),
                    const SizedBox(height: 10),
                    textFields(
                      context,
                      (value) {
                        List temp = [""];
                        setState(() {
                          feeling = value;
                          temp[0] = feeling;
                          lifestyleMap['qna'][3]['answer'] = temp;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('What are you doing for your health presently?'),
                    const SizedBox(height: 10),
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: presentHealthMap.length,
                      itemBuilder: (context, index) {
                        return checkboxTile(
                          index,
                          presentHealthMap,
                          () {
                            if (presentHealthMap[index]['value'] == true) {
                              presentHealth
                                  .add(presentHealthMap[index]['title']);
                            } else {
                              if (presentHealth.isNotEmpty) {
                                presentHealth.removeWhere((value) {
                                  return value ==
                                      presentHealthMap[index]['title'];
                                });
                              }
                            }
                            log(presentHealth.toString());
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        'What do you believe might be the causes or underlying factors of your current health condition?'),
                    const SizedBox(height: 10),
                    textFields(
                      context,
                      (value) {
                        List temp = [""];
                        setState(() {
                          causes = value;
                          temp[0] = causes;
                          lifestyleMap['qna'][5]['answer'] = temp;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Life Stress',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        'Have you experienced any level of trauma or loss in the past?'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items:
                            shortOptions.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            traumaOrLoss = newValue!;
                            temp[0] = traumaOrLoss;
                            lifestyleMap['qna'][6]['answer'] = temp;
                          });
                        },
                        value: traumaOrLoss,
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
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        'What level of stress are you experiencing during this time in your life?'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: stress.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            stressLevel = newValue!;
                            temp[0] = stressLevel;
                            lifestyleMap['qna'][7]['answer'] = temp;
                          });
                        },
                        value: stressLevel,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('What does your stress look like?'),
                    const SizedBox(height: 10),
                    textFields(
                      context,
                      (value) {
                        List temp = [""];
                        setState(() {
                          stressLooksLike = value;
                          temp[0] = stressLooksLike;
                          lifestyleMap['qna'][8]['answer'] = temp;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        'Do you have any coping mechanisms for your stress?'),
                    const SizedBox(height: 10),
                    textFields(
                      context,
                      (value) {
                        List temp = [""];
                        setState(() {
                          copingMechanisms = value;
                          temp[0] = copingMechanisms;
                          lifestyleMap['qna'][9]['answer'] = temp;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sleep Habits',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        'How many hours do you sleep daily on an average?'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: hours.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            hoursOfSleep = newValue!;
                            temp[0] = hoursOfSleep;
                            lifestyleMap['qna'][10]['answer'] = temp;
                          });
                        },
                        value: hoursOfSleep,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('What time do you go to sleep?'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(sleepTime ?? "Choose time"),
                        TextButton(
                          onPressed: () {
                            _timePicker(context, true);
                          },
                          child: const Text('Choose Time'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('What time do usually wake up?'),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(wakeupTime ?? "Choose time"),
                        TextButton(
                          onPressed: () {
                            _timePicker(context, false);
                          },
                          child: const Text('Choose Time'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('When you wake up, do you feel well rested?'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: options.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            wellRested = newValue!;
                          });
                          List temp = [""];
                          setState(() {
                            wellRested = newValue!;
                            temp[0] = wellRested;
                            lifestyleMap['qna'][13]['answer'] = temp;
                          });
                        },
                        value: wellRested,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('What is your typical energy level?'),
                    const SizedBox(height: 10),
                    textFields(
                      context,
                      (value) {
                        List temp = [""];
                        setState(() {
                          typicalEnergy = value;
                          temp[0] = typicalEnergy;
                          lifestyleMap['qna'][14]['answer'] = temp;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Daily Life & Exercise',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    const Text('What is your occupation?'),
                    const SizedBox(height: 10),
                    textFields(
                      context,
                      (value) {
                        List temp = [""];
                        setState(() {
                          occupation = value;
                          temp[0] = occupation;
                          lifestyleMap['qna'][15]['answer'] = temp;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('How many hours do you work everyday?'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: hours.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            noOfWorkHours = newValue!;
                            temp[0] = noOfWorkHours;
                            lifestyleMap['qna'][16]['answer'] = temp;
                          });
                        },
                        value: noOfWorkHours,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('What time do you start and end work?'),
                    const SizedBox(height: 10),
                    textFields(
                      context,
                      (value) {
                        List temp = [""];
                        setState(() {
                          workTimings = value;
                          temp[0] = workTimings;
                          lifestyleMap['qna'][17]['answer'] = temp;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('Do you enjoy your work?'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: options.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            enjoyWork = newValue!;
                          });
                          List temp = [""];
                          setState(() {
                            enjoyWork = newValue!;
                            temp[0] = enjoyWork;
                            lifestyleMap['qna'][18]['answer'] = temp;
                          });
                        },
                        value: enjoyWork,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('Do you smoke cigarettes?'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: options.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            smoke = newValue!;
                            temp[0] = smoke;
                            lifestyleMap['qna'][19]['answer'] = temp;
                          });
                        },
                        value: smoke,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('If yes, how many?'),
                    const SizedBox(height: 10),
                    textFields(
                      context,
                      (value) {
                        List temp = [""];
                        setState(() {
                          noOfCigarettes = value;
                          temp[0] = noOfCigarettes;
                          lifestyleMap['qna'][20]['answer'] = temp;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        'If no, have you ever been exposed to second hand smoke?'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items:
                            shortOptions.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            secondHandSmoke = newValue!;
                            temp[0] = secondHandSmoke;
                            lifestyleMap['qna'][21]['answer'] = temp;
                          });
                        },
                        value: secondHandSmoke,
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
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'How many hours do you spend daily on average?',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 10),
                    const Text('Driving'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: hours.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            driving = newValue!;
                            temp[0] = driving;
                            lifestyleMap['qna'][22]['answer'] = temp;
                          });
                        },
                        value: driving,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('Watching TV'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: hours.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            tv = newValue!;
                            temp[0] = tv;
                            lifestyleMap['qna'][23]['answer'] = temp;
                          });
                        },
                        value: tv,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('Reading'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: hours.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            reading = newValue!;
                            temp[0] = reading;
                            lifestyleMap['qna'][24]['answer'] = temp;
                          });
                        },
                        value: reading,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('Social Media'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: hours.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            socialMedia = newValue!;
                            temp[0] = socialMedia;
                            lifestyleMap['qna'][25]['answer'] = temp;
                          });
                        },
                        value: socialMedia,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('Using Computer'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: hours.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            computer = newValue!;
                            temp[0] = computer;
                            lifestyleMap['qna'][26]['answer'] = temp;
                          });
                        },
                        value: computer,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('Walking'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: hours.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            walking = newValue!;
                            temp[0] = walking;
                            lifestyleMap['qna'][27]['answer'] = temp;
                          });
                        },
                        value: walking,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('What do you do for exercise?'),
                    const SizedBox(height: 10),
                    textFields(
                      context,
                      (value) {
                        List temp = [""];
                        setState(() {
                          exercise = value;
                          temp[0] = exercise;
                          lifestyleMap['qna'][28]['answer'] = temp;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('How frequently do you exercise?'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: frequency.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            exerciseFrequency = newValue!;
                            temp[0] = exerciseFrequency;
                            lifestyleMap['qna'][29]['answer'] = temp;
                          });
                        },
                        value: exerciseFrequency,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('What are your interests and hobbies?'),
                    const SizedBox(height: 10),
                    textFields(
                      context,
                      (value) {
                        List temp = [""];
                        setState(() {
                          interestAndHobbies = value;
                          temp[0] = interestAndHobbies;
                          lifestyleMap['qna'][30]['answer'] = temp;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('Do you take vacations regularly?'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items:
                            shortOptions.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            vacations = newValue!;
                            temp[0] = vacations;
                            lifestyleMap['qna'][31]['answer'] = temp;
                          });
                        },
                        value: vacations,
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
                    ),
                    const SizedBox(height: 10),
                    const Text('When was your last vacation?'),
                    const SizedBox(height: 10),
                    textFields(
                      context,
                      (value) {
                        List temp = [""];
                        setState(() {
                          lastVacation = value;
                          temp[0] = lastVacation;
                          lifestyleMap['qna'][32]['answer'] = temp;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                        'Do you actively participate in spiritual groups?'),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonFormField(
                        isDense: true,
                        items: options.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: Theme.of(context).textTheme.bodyMedium),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          List temp = [""];
                          setState(() {
                            spiritualGroups = newValue!;
                            temp[0] = spiritualGroups;
                            lifestyleMap['qna'][33]['answer'] = temp;
                          });
                        },
                        value: spiritualGroups,
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
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: orangeGradient,
        ),
        child: TextButton(
          onPressed: () {
            log(lifestyleMap.toString());
            onSubmit();
          },
          child: Text(
            'SAVE',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }

  void _timePicker(context, bool isSleepTime) {
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
      List temp = [""];
      setState(() {
        if (isSleepTime) {
          sleepTime = value.format(context);
          temp[0] = sleepTime;
          lifestyleMap['qna'][11]['answer'] = temp;
        } else {
          wakeupTime = value.format(context);
          temp[0] = wakeupTime;
          lifestyleMap['qna'][12]['answer'] = temp;
        }
      });
    });
  }

  Widget checkboxTile(int index, List map, Function onClick) {
    return StatefulBuilder(
      builder: (context, setState) => Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.grey,
        ),
        child: CheckboxListTile(
          value: map[index]['value'],
          title: Text(
            map[index]['title'],
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onChanged: (isTapped) {
            setState(
              () {
                map[index]['value'] = isTapped;
              },
            );
            onClick();
          },
          activeColor: const Color(0xFFff7f3f),
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    );
  }

  Widget textFields(context, Function(String) onchanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          filled: false,
          hintText: 'Kindly explain',
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color(0xFF717579),
              ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: whiteColor,
        onChanged: (value) {
          onchanged(value);
        },
      ),
    );
  }
}
