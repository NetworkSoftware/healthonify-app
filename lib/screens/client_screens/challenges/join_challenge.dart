import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/challenges_models/challenges_models.dart';
import 'package:healthonify_mobile/screens/client_screens/challenges/challenge_details.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class JoinChallengeScreen extends StatefulWidget {
  final ChallengesModel challengeData;
  const JoinChallengeScreen({required this.challengeData, Key? key})
      : super(key: key);

  @override
  State<JoinChallengeScreen> createState() => _JoinChallengeScreenState();
}

class _JoinChallengeScreenState extends State<JoinChallengeScreen> {
  String? startDate;
  String? endDate;
  @override
  void initState() {
    super.initState();
    DateTime sDate =
        DateFormat('yyyy-MM-dd').parse(widget.challengeData.startDate!);
    DateTime eDate =
        DateFormat('yyyy-MM-dd').parse(widget.challengeData.endDate!);

    startDate = DateFormat('d MMMM').format(sDate);
    endDate = DateFormat('d MMMM').format(eDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: widget.challengeData.name!,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.event_outlined,
                    size: 22,
                    color: Color(0xFFff7f3f),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$startDate to $endDate',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  // const Icon(
                  //   Icons.group_outlined,
                  //   size: 22,
                  //   color: Color(0xFFff7f3f),
                  // ),
                  // Text(
                  //   '104 participants',
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // ),
                ],
              ),
            ),
            challengeBanner(context),
            // const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/reward.png',
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Winners to get ${widget.challengeData.prizeType} ${widget.challengeData.prizeValue}',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChallengeDetailsScreen(
                        challengeData: widget.challengeData);
                  }));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Join Challenge',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: whiteColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget challengeBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          // color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: widget.challengeData.mediaLink != null
              ? Image.network(
                  widget.challengeData.mediaLink!,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  'https://images.unsplash.com/photo-1552508744-1696d4464960?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80',
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
