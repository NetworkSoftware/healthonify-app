import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/challenges_models/challenges_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/challenges_providers/challenges_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class FoodChallengeLogs extends StatefulWidget {
  const FoodChallengeLogs({super.key});

  @override
  State<FoodChallengeLogs> createState() => _FoodChallengeLogsState();
}

class _FoodChallengeLogsState extends State<FoodChallengeLogs> {
  bool isLoading = true;

  List<FoodChallengeImages> foodChallengeImages = [];
  Future<void> fetchFoodChallengeImages() async {
    try {
      foodChallengeImages =
          await Provider.of<ChallengesProvider>(context, listen: false)
              .fetchFoodChallengeImages(userId);

      log('fetched food images');
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching food images');
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
    userId = Provider.of<UserData>(context, listen: false).userData.id!;

    fetchFoodChallengeImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Food Challenge Logs'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : foodChallengeImages.isEmpty
              ? const Center(child: Text('No food images uploaded'))
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: foodChallengeImages.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Date: ${foodChallengeImages[index].date}",
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                              GridView.builder(
                                padding: const EdgeInsets.all(4),
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisExtent: 136,
                                  crossAxisCount: 3,
                                ),
                                itemCount: foodChallengeImages[index]
                                    .mediaLinks!
                                    .length,
                                itemBuilder: (context, idx) {
                                  return InkWell(
                                    onTap: () {
                                      viewImage(
                                        foodChallengeImages[index]
                                            .mediaLinks![idx],
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image.network(
                                            foodChallengeImages[index]
                                                .mediaLinks![idx],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  void viewImage(String imageUrl) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 32,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
