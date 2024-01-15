import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/challenges_models/challenges_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/leaderboard_models/leaderboard_models.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/challenges_providers/challenges_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/challenges/food_challenge/food_challenge_logs.dart';
import 'package:healthonify_mobile/screens/client_screens/challenges/food_challenge/log_food_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/steps_screen_card.dart';
import 'package:provider/provider.dart';

enum ChallengeType { food, steps, meditation }

class ChallengesScreen extends StatefulWidget {
  final ChallengesModel challengeData;
  const ChallengesScreen({required this.challengeData, Key? key})
      : super(key: key);

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  bool isLoading = true;

  LeaderboardData leaderboardData = LeaderboardData();
  List<String> ranks = [];
  ChallengeType? challengeType;
  String? startDate;
  String? endDate;
  String? enrollDate;

  Future<void> fetchLeaderboard() async {
    setState(() {
      isLoading = true;
    });
    try {
      print(widget.challengeData.id!);
      leaderboardData =
          await Provider.of<ChallengesProvider>(context, listen: false)
              .fetchLeaderboard(widget.challengeData.id!);
      // log(leaderboardData.usersdata![0].stepsCount.toString());
      if (leaderboardData.fitnessChallengeData!.challengeCategoryId!.id ==
          "634e7895b44bf2b9d453d67a") {
        challengeType = ChallengeType.steps;
      } else if (leaderboardData
              .fitnessChallengeData!.challengeCategoryId!.id ==
          "634ec637a35d16b5cc0b5fba") {
        challengeType = ChallengeType.meditation;
      } else {
        challengeType = ChallengeType.food;
      }

      if (leaderboardData.fitnessChallengeData!.challengeCategoryId!.id ==
          "634e7895b44bf2b9d453d67a") {
        challengeType = ChallengeType.steps;
      } else if (leaderboardData
              .fitnessChallengeData!.challengeCategoryId!.id ==
          "634ec637a35d16b5cc0b5fba") {
        challengeType = ChallengeType.meditation;
      } else {
        challengeType = ChallengeType.food;
      }

      ranks = List.generate(
        leaderboardData.usersCount!,
        (int index) => "${index + 1}",
        growable: false,
      );
      DateTime sDate = DateFormat('yyyy-MM-dd')
          .parse(leaderboardData.fitnessChallengeData!.startDate!);
      DateTime eDate = DateFormat('yyyy-MM-dd')
          .parse(leaderboardData.fitnessChallengeData!.endDate!);

      startDate = DateFormat('d MMMM').format(sDate);
      endDate = DateFormat('d MMMM').format(eDate);

      enrollDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      DateTime updateTime = DateFormat('yyyy-MM-dd')
          .parse(leaderboardData.fitnessChallengeData!.updatedAt!);

      updatedAt = DateFormat('d MMMM, h:mm a').format(updateTime);

      log('fetched leaderboard');
    } on HttpException catch (e) {
      log("HTTP EXCEPTION: $e");
    } catch (e) {
      log('Error fetching leaderboard');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  LeaderboardUsersData findMyRank(List<LeaderboardUsersData> data) {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    for (var element in data) {
      if (element.userId!.id == userId) {
        log(element.stepsCount.toString());
        return element;
      }
    }
    return data[0];
  }

  String? updatedAt;

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
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
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.event_outlined,
                          size: 26,
                          color: Color(0xFFff7f3f),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$startDate to $endDate',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     TextButton(
                    //       onPressed: () {},
                    //       child: Text(
                    //         'Challenge friends',
                    //         style: Theme.of(context)
                    //             .textTheme
                    //             .bodySmall!
                    //             .copyWith(
                    //               color:
                    //                   Theme.of(context).colorScheme.secondary,
                    //             ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    if (challengeType == ChallengeType.steps)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<AllTrackersData>(
                            builder: (context, value, child) => StepsScreenCard(
                              goal: value.allTrackersData.totalStepsGoal ?? 0,
                              startDate: DateFormat("MM/dd/yyyy")
                                  .format(DateTime.now()),
                            ),
                          ),
                        ],
                      ),
                    challengeBanner(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Leaderboard',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Text(
                          updatedAt!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Ranks',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ranks.length,
                      itemBuilder: (context, index) {
                        return rankTile(context, ranks[index], index);
                      },
                    ),
                    // myRank(context),
                    leaderboardData.fitnessChallengeData!.challengeCategoryId!
                                .id ==
                            "634d4abe8a0b108e000c7fda"
                        ? GradientButton(
                            title: 'View Logs',
                            func: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const FoodChallengeLogs();
                              }));
                            },
                            gradient: orangeGradient,
                          )
                        : const SizedBox(),
                    const SizedBox(height: 16),
                    leaderboardData.fitnessChallengeData!.tips!.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tips",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: leaderboardData
                                    .fitnessChallengeData!.tips!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      '- ${leaderboardData.fitnessChallengeData!.tips![index]}',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : const SizedBox(),
                    // Text(
                    //   '1.   Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    // const SizedBox(height: 16),
                    // Text(
                    //   '2.   Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    // const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            persistentFooterButtons: [
              rankFooter(context),
            ],
          );
  }

  Widget challengeBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: leaderboardData.fitnessChallengeData!.mediaLink!,
          errorWidget: (context, url, error) => Image.network(
            'https://images.unsplash.com/photo-1561494653-744c43aed0c1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8ODJ8fGluc3RhZ3JhbXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget rankTile(BuildContext context, String ranks, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 36,
              child: Text(
                ranks,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              leaderboardData.usersdata![index].userId!.imageUrl ??
                  "https://images.unsplash.com/photo-1561494653-744c43aed0c1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8ODJ8fGluc3RhZ3JhbXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
            ),
          ),
          const SizedBox(width: 16),
          Text('${leaderboardData.usersdata![index].userId!.firstName}'),
          const Spacer(),
          Column(
            children: [
              Image.asset(
                'assets/icons/claps.png',
                height: 22,
                width: 22,
              ),
              if (challengeType == ChallengeType.meditation)
                Text(
                  leaderboardData.usersdata![index].totalPlants.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (challengeType == ChallengeType.steps)
                Text(
                  leaderboardData.usersdata![index].stepsCount.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (challengeType == ChallengeType.food)
                Text(
                  // "0",
                  leaderboardData.usersdata![index].foodImagesCount.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget myRank(BuildContext context) {
  //   LeaderboardUsersData data = findMyRank(leaderboardData.usersdata!);
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: Container(
  //       height: 60,
  //       decoration: BoxDecoration(
  //         color: Theme.of(context).canvasColor,
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.only(left: 10),
  //         child: Row(
  //           children: [
  //             const SizedBox(width: 10),
  //             Text(
  //               "${data.rank}",
  //               style: Theme.of(context).textTheme.labelLarge,
  //             ),
  //             const SizedBox(width: 16),
  //             CircleAvatar(
  //               radius: 18,
  //               backgroundImage: NetworkImage(
  //                 data.userId!.imageUrl ??
  //                     "https://images.unsplash.com/photo-1561494653-744c43aed0c1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8ODJ8fGluc3RhZ3JhbXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
  //               ),
  //             ),
  //             const SizedBox(width: 16),
  //             Text(
  //                 '${data.userId!.firstName} ${data.userId!.lastName}hhhhhhhhh'),
  //             const Spacer(),
  //             // Padding(
  //             //   padding: const EdgeInsets.only(right: 8),
  //             //   child: TextButton(
  //             //     onPressed: () {},
  //             //     child: const Text('View more'),
  //             //   ),
  //             // ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget rankFooter(BuildContext context) {
    LeaderboardUsersData data = findMyRank(leaderboardData.usersdata!);

    return leaderboardData.fitnessChallengeData!.challengeCategoryId!.id ==
            "634d4abe8a0b108e000c7fda"
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return LogFoodScreen(
                        challengeData: widget.challengeData,
                      );
                    })).then((value) {
                      setState(() {
                        fetchLeaderboard();
                      });
                    });
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                  child: Text(
                    'Log Food',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: whiteColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )
        : Container(
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    '${data.rank}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      data.userId!.imageUrl ??
                          "https://images.unsplash.com/photo-1561494653-744c43aed0c1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8ODJ8fGluc3RhZ3JhbXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
                    ),
                    radius: 18,
                  ),
                  const SizedBox(width: 16),
                  const Text('My Rank'),
                  const Spacer(),
                  Text(
                    '${data.stepsCount.toString() == "null" ? "0" : data.stepsCount.toString()} points',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/icons/rank_badge.png',
                    height: 28,
                    width: 28,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          );
  }
}
