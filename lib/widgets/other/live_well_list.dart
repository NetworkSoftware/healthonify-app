import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/live_well/live_well_models.dart';
import 'package:healthonify_mobile/providers/live_well_providers/live_well_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/sub_categories.dart';
import 'package:provider/provider.dart';

class LiveWellList extends StatelessWidget {
  LiveWellList({Key? key}) : super(key: key);

  List<LiveWellCategories> liveWellCategories = [];

  Future<void> getCategories(BuildContext context) async {
    try {
      liveWellCategories =
          await Provider.of<LiveWellProvider>(context, listen: false)
              .getLiveWellCategories("master=1");
      log('fetched live well categories');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting live well categories: $e");
      Fluttertoast.showToast(msg: "Unable to fetch live well categories");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategories(context),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const SizedBox(
              height: 10,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Live Well',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: liveWellCategories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 120,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return SubCategoriesScreen(
                                            screenTitle:
                                                liveWellCategories[index].name!,
                                            parentCategoryId:
                                                liveWellCategories[index]
                                                    .parentCategoryId!,
                                          );
                                        }));
                                      },
                                      child: Image.asset(
                                        'assets/images/Picture7.png',
                                        height: 150,
                                        width: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${liveWellCategories[index].name}",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
