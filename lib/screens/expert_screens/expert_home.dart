import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/expert/expert_home_cardlist.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/update_profile.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/models/expertise/expertise.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/expert_availability.dart';
import 'package:healthonify_mobile/screens/expert_screens/upload_certificates.dart';
import 'package:healthonify_mobile/screens/notifications_screen.dart';
import 'package:healthonify_mobile/widgets/cards/assign_training_card.dart';
import 'package:healthonify_mobile/widgets/experts/home/clientcard/expert_home_client_card.dart';
import 'package:healthonify_mobile/widgets/experts/home/expert_nav_drawer.dart';
import 'package:healthonify_mobile/widgets/experts/home/home_top_appointments_card.dart';
import 'package:provider/provider.dart';

enum TopExp { physio, diet, healthcare, fitness, nothing, manageWeight,liveWell }

class ExpertHomeScreen extends StatefulWidget {
  const ExpertHomeScreen({Key? key}) : super(key: key);

  @override
  State<ExpertHomeScreen> createState() => _ExpertHomeScreenState();
}

class _ExpertHomeScreenState extends State<ExpertHomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  TopExp topexp = TopExp.nothing;
  String? topLExp;

  void setCards() {
    String topLExp =
        Provider.of<UserData>(context, listen: false).userData.topLevelExpName!;
    log("top level exp set cards $topLExp");
    kSharedPreferences.setString('topExp', topLExp);
    if (topLExp == "Dietitian") {
      topexp = TopExp.diet;
      setState(() {});
    }
    if (topLExp == "Physiotherapy") {
      topexp = TopExp.physio;
      setState(() {});
    }
    if (topLExp == "Health Care") {
      topexp = TopExp.healthcare;
      setState(() {});
    }
    if (topLExp == "Weight Management") {
      topexp = TopExp.manageWeight;
      setState(() {});
    }
    if (topLExp == "Fitness") {
      topexp = TopExp.fitness;
      setState(() {});
    }
    if (topLExp == "Live Well") {
      topexp = TopExp.liveWell;
      setState(() {});
    }
  }

  Future<void> getTopLevelExpertise() async {
    setState(() {
      isLoading = true;
    });
    try {
      Provider.of<ExpertiseData>(context, listen: false)
          .fetchTopLevelExpertiseData()
          .then(
        (value) async {
          SharedPrefManager pref = SharedPrefManager();
          bool isPresent = await pref.getIsTopExp();
          if (!isPresent) {
            Future.delayed(
              Duration.zero,
              () {
                showPopUp(context, value);
              },
            );
          } else {
            setCards();
          }
        },
      );
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get get top level expertise widget $e");
      Fluttertoast.showToast(msg: "Unable to fetch expertise");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  late User userData;

  @override
  void initState() {
    super.initState();
    userData = Provider.of<UserData>(context, listen: false).userData;

    getTopLevelExpertise().then((value) {
      return userData.certificates!.isEmpty
          ? Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const UploadCertificatesScreen();
            }))
          : null;
    }).then((value) {
      return userData.availability!.isEmpty
          ? Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const ExpertAvailabilityScreen();
            }))
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context).userData;
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              toolbarHeight: 60,
              leading: IconButton(
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
                icon: Icon(
                  Icons.menu_rounded,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                splashRadius: 20,
              ),
              title: Text(
                'Welcome ${userData.firstName}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return NotificationScreen();
                      }));
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    splashRadius: 20,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeTopAppointmentsCard(),
                  ExpertHomeClientCard(topLExp: topexp),
                  if (topexp == TopExp.physio) const HomeCircularCards(),
                  // const SubscriptionsCard(),
                  HomeExpertiseCards(
                    topExp: topexp,
                  ),
                  // const SizedBox(height: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     TextButton(
                  //       onPressed: () {
                  //         Navigator.of(context, /*rootnavigator: true*/)
                  //             .push(MaterialPageRoute(builder: (context) {
                  //           return const UploadCertificatesScreen();
                  //         }));
                  //       },
                  //       child: const Text('certificates'),
                  //     ),
                  //     TextButton(
                  //       onPressed: () {
                  //         Navigator.of(context, /*rootnavigator: true*/)
                  //             .push(MaterialPageRoute(builder: (context) {
                  //           return const ExpertAvailabilityScreen();
                  //         }));
                  //       },
                  //       child: const Text('availability'),
                  //     ),
                  //   ],
                  // ),

                  const SizedBox(height: 75),
                ],
              ),
            ),
            drawer: const ExpertNavigationDrawer(topLevelExp: "topLExp"),
          );
  }

  void showPopUp(context, List<TopLevelExpertise> choices) {
    String idV;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: WillPopScope(
            //!prevents the pop up from closing on the press of the back button.
            onWillPop: () => Future.value(false),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Choose your expertise',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: choices.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Card(
                              elevation: 0,
                              child: InkWell(
                                onTap: () async {
                                  idV = choices[index].id!;
                                  log(idV);
                                  Map<String, dynamic> topExpertiseId = {
                                    "set": {
                                      "topExpertise": idV,
                                    }
                                  };
                                  await UpdateProfile.updateProfile(
                                      context, topExpertiseId, onSuccess: () {
                                    Navigator.of(context).pop();
                                    setCards();
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        choices[index].name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeExpertiseCards extends StatelessWidget {
  final TopExp topExp;

  const HomeExpertiseCards({
    Key? key,
    required this.topExp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List cardList = [];

    if (topExp == TopExp.physio) {
      cardList = physioCardDetails;
    }
    if (topExp == TopExp.diet) {
      cardList = dietCardDetails;
    }
    if (topExp == TopExp.healthcare) {
      cardList = healthCareCardDetails;
    }
    if (topExp == TopExp.fitness) {
      cardList = fitnessCardDetails;
    }
    if (topExp == TopExp.manageWeight) {
      cardList = manageWeightCardDetails;
    }
    if (topExp == TopExp.liveWell) {
      cardList = liveWellCardDetails;
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 8,
        childAspectRatio: 1 / 0.9,
      ),
      itemCount: cardList.length,
      itemBuilder: (context, index) {
        return ExpertHomeCards(
          cardTitle: cardList[index]["title"],
          cardSubTitle: cardList[index]["subtitle"],
          imagePath: cardList[index]["icon"],
          onPress: cardList[index]["onClick"],
        );
      },
    );
  }
}

class HomeCircularCards extends StatelessWidget {
  const HomeCircularCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisExtent: 130),
      itemCount: homeCircularCardDetails.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                homeCircularCardDetails[index]["onClick"](context);
              },
              borderRadius: BorderRadius.circular(80),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                radius: 35,
                child: const Icon(
                  Icons.ice_skating,
                  color: whiteColor,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(homeCircularCardDetails[index]["title"]),
          ],
        );
      },
    );
  }
}
