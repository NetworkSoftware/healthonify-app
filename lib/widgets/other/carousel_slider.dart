import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/challenges_models/challenges_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/challenges_providers/challenges_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/challenges/challenges_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/challenges/join_challenge.dart';
import 'package:provider/provider.dart';

class CustomCarouselSlider extends StatefulWidget {
  final List? imageUrls;

  const CustomCarouselSlider({Key? key, required this.imageUrls})
      : super(key: key);

  @override
  State<CustomCarouselSlider> createState() => _CustomCarouselSliderState();
}

class _CustomCarouselSliderState extends State<CustomCarouselSlider> {
  int myActiveIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.25,
                autoPlay: true,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                scrollPhysics: const BouncingScrollPhysics(),
                onPageChanged: (index, reason) {
                  setState(() {
                    myActiveIndex = index;
                  });
                }),
            itemCount: widget.imageUrls!.length,
            itemBuilder: (context, index, realIndex) {
              final imageUrl = widget.imageUrls![index]['image'];
              return GestureDetector(
                onTap: widget.imageUrls![index]['route'],
                child: Card(
                  //  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imageUrl,
                      width: MediaQuery.of(context).size.width * 0.93,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChallengesScroller extends StatefulWidget {
  const ChallengesScroller({Key? key}) : super(key: key);

  @override
  State<ChallengesScroller> createState() => _ChallengesScrollerState();
}

class _ChallengesScrollerState extends State<ChallengesScroller> {
  bool isLoading = true;

  List<ChallengesModel> allChallenges = [];
  List<ChallengesModel> allActiveChallenges = [];

  Future<void> fetchAllChallenges() async {
    try {
      allChallenges =
          await Provider.of<ChallengesProvider>(context, listen: false)
              .getAllChallenges();

      for (int i = 0; i < allChallenges.length; i++) {
        if (allChallenges[i].isActive == true) {
          allActiveChallenges.add(allChallenges[i]);
        }
      }
      print(allChallenges);
      log('fetched all challenges');
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching logs');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllChallenges();
  }

  Future<bool> fetchJoinedChallenges(String challengeId) async {
    var userId = Provider.of<UserData>(context, listen: false).userData.id!;

    print("challengeId : $challengeId");
    try {
      List<JoinedChallenges> joinedChallenges =
          await Provider.of<ChallengesProvider>(context, listen: false)
              .getJoinedChallenges(userId);

      for (var element in joinedChallenges) {
        if (element.fitnessChallengeId == challengeId) {
          return true;
        }
      }
      return false;
    } on HttpException catch (e) {
      log(e.toString());
      return false;
    } catch (e) {
      log('Error fetching joined challenges');
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Challenges for you',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        const SizedBox(height: 8),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: 230,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 2),
                  scrollDirection: Axis.horizontal,
                  itemCount: allActiveChallenges.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Card(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? darkGrey
                            : Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () async {
                            // allChallenges[index].isActive == false ?
                            bool result = await fetchJoinedChallenges(
                                allActiveChallenges[index].id!);

                            print("Result : $result");
                            log(allActiveChallenges[index].name.toString());
                            if (result) {
                              Navigator.of(
                                context, /*rootnavigator: true*/
                              ).push(MaterialPageRoute(builder: (context) {
                                return ChallengesScreen(
                                  challengeData: allActiveChallenges[index],
                                );
                              }));
                              return;
                            }
                            Navigator.of(
                              context, /*rootnavigator: true*/
                            ).push(MaterialPageRoute(builder: (context) {
                              return JoinChallengeScreen(
                                challengeData: allActiveChallenges[index],
                              );
                            }));
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                    decoration: const BoxDecoration(
                                        color: orange,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    child: Text(
                                      allActiveChallenges[index].name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: allActiveChallenges[index]
                                                  .mediaLink !=
                                              null
                                          ? Image.network(
                                              allActiveChallenges[index]
                                                  .mediaLink!,
                                              height: 100,
                                              // width: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/icons/some.png',
                                              height: 100,
                                              width: 120,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                      allActiveChallenges[index]
                                          .shortDescription!,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      // textAlign: TextAlign.center,
                                    ),
                                  ),
                                  // Expanded(
                                  //   flex: 2,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.symmetric(
                                  //       horizontal: 20,
                                  //     ),
                                  //     child: Column(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.center,
                                  //       crossAxisAlignment:
                                  //           CrossAxisAlignment.start,
                                  //       children: [
                                  //
                                  //
                                  //       ],
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class CustomCarouselSliderWithHeader extends StatefulWidget {
  final List? imageUrls;
  final List<String>? header;

  const CustomCarouselSliderWithHeader(
      {Key? key, required this.imageUrls, required this.header})
      : super(key: key);

  @override
  State<CustomCarouselSliderWithHeader> createState() =>
      _CustomCarouselSliderWithHeaderState();
}

class _CustomCarouselSliderWithHeaderState
    extends State<CustomCarouselSliderWithHeader> {
  int myActiveIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.3,
                autoPlay: true,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                scrollPhysics: const BouncingScrollPhysics(),
                onPageChanged: (index, reason) {
                  setState(() {
                    myActiveIndex = index;
                  });
                }),
            itemCount: widget.imageUrls!.length,
            itemBuilder: (context, index, realIndex) {
              final imageUrl = widget.imageUrls![index];
              return Stack(children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Image.network(
                      imageUrl,
                      width: MediaQuery.of(context).size.width * 0.92,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 30,
                  child: Text(
                    "Workshop Header",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ]);
            },
          ),
        ],
      ),
    );
  }
}
