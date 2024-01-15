import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/challenges_models/challenges_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/challenges_providers/challenges_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/challenges/challenges_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  final ChallengesModel challengeData;
  const ChallengeDetailsScreen({required this.challengeData, Key? key})
      : super(key: key);

  @override
  State<ChallengeDetailsScreen> createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  late String? userId;
  String? descp;
  String? initText;
  String? expandedText;

  bool isAgreed = false;

  List<dynamic> toDos = [];
  String? startDate;
  String? endDate;
  String? enrollDate;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id;
    descp = widget.challengeData.description!;
    toDos = widget.challengeData.needToDo!;

    DateTime sDate =
        DateFormat('yyyy-MM-dd').parse(widget.challengeData.startDate!);
    DateTime eDate =
        DateFormat('yyyy-MM-dd').parse(widget.challengeData.endDate!);

    startDate = DateFormat('d MMMM').format(sDate);
    endDate = DateFormat('d MMMM').format(eDate);

    enrollDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (descp!.length > 50) {
      initText = descp!.substring(0, 150);
      expandedText = descp!.substring(50, descp!.length);
    } else {
      initText = descp;
      expandedText = "";
    }
  }

  Map<String, dynamic> challengeJoiningMap = {};

  void navigate() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ChallengesScreen(challengeData: widget.challengeData);
    }));
  }

  Future<void> joinChallenge() async {
    try {
      await Provider.of<ChallengesProvider>(context, listen: false)
          .joinChallenges(challengeJoiningMap);
      navigate();
      Fluttertoast.showToast(msg: 'Joined challenge succesfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "This challenge is not active yet!!");
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to join challenge');
    }
  }

  void onJoin() {
    challengeJoiningMap['userId'] = userId;
    challengeJoiningMap['fitnessChallengeId'] = widget.challengeData.id;
    challengeJoiningMap['challengeCategoryId'] =
        widget.challengeData.challengeCategoryId;
    challengeJoiningMap['enrollDate'] = enrollDate;

    log(challengeJoiningMap.toString());
    joinChallenge();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: widget.challengeData.name!,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Description',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(descp!
                    // flag1 ? ("${initText!}...") : (initText! + expandedText!),
                    ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         setState(() {
              //           flag1 = !flag1;
              //         });
              //       },
              //       child: Text(
              //         flag1 ? "show more" : "show less",
              //         style: Theme.of(context).textTheme.labelSmall!.copyWith(
              //             color: Theme.of(context).colorScheme.secondary),
              //       ),
              //     ),
              //   ],
              // ),
              Text(
                'What do you need to do',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: toDos.length,
                  itemBuilder: (context, index) {
                    return Text(
                      toDos[index],
                      style: Theme.of(context).textTheme.bodyMedium,
                    );
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: Text(
              //     flag2 ? ("${initText!}...") : (initText! + expandedText!),
              //   ),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         setState(() {
              //           flag2 = !flag2;
              //         });
              //       },
              //       child: Text(
              //         flag2 ? "show more" : "show less",
              //         style: Theme.of(context).textTheme.labelSmall!.copyWith(
              //             color: Theme.of(context).colorScheme.secondary),
              //       ),
              //     ),
              //   ],
              // ),
              Text(
                'Duration',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text('$startDate to $endDate'),
              ),
              // Text(
              //   'Scoring Pattern',
              //   style: Theme.of(context).textTheme.labelMedium,
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: Text(
              //     flag3 ? ("${initText!}...") : (initText! + expandedText!),
              //   ),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         setState(() {
              //           flag3 = !flag3;
              //         });
              //       },
              //       child: Text(
              //         flag3 ? "show more" : "show less",
              //         style: Theme.of(context).textTheme.labelSmall!.copyWith(
              //             color: Theme.of(context).colorScheme.secondary),
              //       ),
              //     ),
              //   ],
              // ),
              Text(
                'Reward',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Winners to get ${widget.challengeData.prizeType} ${widget.challengeData.prizeValue}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Text(
                'Terms & Conditions',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Terms and Conditions'),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     TextButton(
              //       onPressed: () {
              //         setState(() {
              //           flag4 = !flag4;
              //         });
              //       },
              //       child: Text(
              //         flag4 ? "show more" : "show less",
              //         style: Theme.of(context).textTheme.labelSmall!.copyWith(
              //             color: Theme.of(context).colorScheme.secondary),
              //       ),
              //     ),
              //   ],
              // ),
              CheckboxListTile(
                title: Text(
                  'I agree to all the terms and conditions',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                value: isAgreed,
                onChanged: (isChecked) {
                  setState(() {
                    isAgreed = isChecked!;
                  });
                },
                activeColor: const Color(0xFFff7f3f),
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    isAgreed == false
                        ? Fluttertoast.showToast(
                            msg: 'Please agree to the terms and conditions')
                        : onJoin();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      'JOIN',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: whiteColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
