import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/health_data.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/browse_physio_plans.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';
// import 'package:better_player/better_player.dart';

class PhysioBodyParts extends StatefulWidget {
  const PhysioBodyParts({Key? key}) : super(key: key);

  @override
  State<PhysioBodyParts> createState() => _PhysioBodyPartsState();
}

class _PhysioBodyPartsState extends State<PhysioBodyParts> {
  Future<void> getBodyPartsData(BuildContext context) async {
    try {
      await Provider.of<HealthData>(context, listen: false).getBodyParts();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      Fluttertoast.showToast(msg: "Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Body Parts',
      ),
      body: FutureBuilder(
        future: getBodyPartsData(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    unlockAll(context),
                    Consumer<HealthData>(
                      builder: ((context, data, child) => ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.bodyParts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 14),
                                child: Card(
                                  elevation: 0,
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         PackagesByHealth(
                                      //       data: {
                                      //         "bodyPart":
                                      //             data.bodyParts[index].id!
                                      //       },
                                      //     ),
                                      //   ),
                                      // );

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BrowsePhysioPlans(
                                                bodyPartsId: data.bodyParts[index].id!,
                                              ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: SizedBox(
                                        height: 54,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.98,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Image.asset(
                                                'assets/icons/body_parts.png',
                                                height: 30,
                                                width: 30,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16),
                                              child: Text(
                                                  data.bodyParts[index].name!),
                                            ),
                                            const Spacer(),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 12),
                                              child: Icon(
                                                Icons.lock_outline_rounded,
                                                color: Color(0xFFff7f3f),
                                                size: 28,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget unlockAll(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: Card(
        elevation: 0,
        color: const Color(0xFFff7f3f),
        child: InkWell(
          onTap: () {
            showBottomPayment(context);
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 54,
              width: MediaQuery.of(context).size.width * 0.98,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Image.asset(
                      'assets/icons/unlock_all.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'Unlock All',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: whiteColor),
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: whiteColor,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget subscriptionMonths(
    context,
    String title,
    String price,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: Card(
        elevation: 0,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 54,
              width: MediaQuery.of(context).size.width * 0.98,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(title,
                        style: Theme.of(context).textTheme.labelMedium!),
                  ),
                  const Spacer(),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.grey,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showBottomPayment(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Container(
                        height: 4,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.grey[500],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 30,
                      ),
                      splashRadius: 20,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'ACCESS TO THERAPY',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'ALL',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    '3-DAY TRIAL',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ),
                // SizedBox(
                //   height: 200,
                //   child: BetterPlayer.network(
                //     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
                //     betterPlayerConfiguration: const BetterPlayerConfiguration(
                //       aspectRatio: 16 / 9,
                //       autoPlay: false,
                //       fullScreenByDefault: false,
                //     ),
                //   ),
                // ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'I HAVE A PROMO CODE',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.grey,
                          decorationThickness: 2,
                        ),
                  ),
                ),
                subscriptionMonths(context, '1 Month Of Therapy', '₹260'),
                subscriptionMonths(context, '3 Months Of Therapy', '₹650'),
                subscriptionMonths(context, '6 Months Of Therapy', '₹1,400'),
                subscriptionMonths(context, '12 Months Of Therapy', '₹2,600'),
                subscriptionMonths(context, '12 Months Of Therapy', '₹2,600'),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'PRIVACY POLICY',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.grey,
                          decorationThickness: 2,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'TERMS AND CONDITIONS',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.grey,
                          decorationThickness: 2,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'RESTORE PURCHASES',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.grey,
                          decorationThickness: 2,
                        ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
