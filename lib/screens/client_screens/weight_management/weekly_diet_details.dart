import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_analysis.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
// import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class WeeklyDietAnalysis extends StatefulWidget {
  final bool isWeekly;
  const WeeklyDietAnalysis({Key? key, this.isWeekly = false}) : super(key: key);

  @override
  State<WeeklyDietAnalysis> createState() => _WeeklyDietAnalysisState();
}

class _WeeklyDietAnalysisState extends State<WeeklyDietAnalysis>
    with TickerProviderStateMixin {
  DietAnalysis data = DietAnalysis();

  Future<void> getData(
    BuildContext context,
  ) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      data = await Provider.of<AllTrackersData>(context, listen: false)
          .getDietAnalysis(
              userId!, DateFormat("yyyy-MM-dd").format(DateTime.now()));
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error something went wrong $e");
      // Fluttertoast.showToast(msg: "Unable to fetch water intake data");
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Diet Analysis'),
      ),
      body: FutureBuilder(
        future: getData(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : caloriesPage(data),
      ),
    );
  }

  Widget caloriesPage(DietAnalysis data) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.chevron_left_rounded,
        //         size: 22,
        //         color: Theme.of(context).colorScheme.secondary,
        //       ),
        //       splashRadius: 18,
        //     ),
        //     Text(
        //       'Today',
        //       style: Theme.of(context).textTheme.labelMedium,
        //     ),
        //     IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.chevron_right_rounded,
        //         size: 22,
        //         color: Theme.of(context).colorScheme.secondary,
        //       ),
        //       splashRadius: 18,
        //     ),
        //   ],
        // ),
        Card(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // mainAxisSpacing: 4,
                      crossAxisSpacing: 10,
                      // mainAxisExtent: ,
                      childAspectRatio: 1 / 0.5,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: data.dietPercentagesData!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 10,
                                      color: Colors.amber,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data.dietPercentagesData![index]!.name ??
                                          "",
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${data.dietPercentagesData![index]!.percentage ?? ""} %',
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "(${data.dietPercentagesData![index]!.caloriesCount ?? ""})",
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
                  ),
                ),
                Divider(
                  color: Colors.grey[350],
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Calories'),
                      Text('${data.totalCalories}'),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[350],
                  height: 20,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: const [
                //       Text('Net Calories'),
                //       Text('0'),
                //     ],
                //   ),
                // ),
                // Divider(
                //   color: Colors.grey[350],
                //   height: 20,
                // ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget macrosPage() {
    return const SizedBox();
    //   return data.calorieProgress!['totalMacrosAnalysisData'] == null
    //       ? const Center(
    //           child: Text("No Data Available"),
    //         )
    //       : ListView(
    //           shrinkWrap: true,
    //           physics: const BouncingScrollPhysics(),
    //           padding: const EdgeInsets.symmetric(horizontal: 8),
    //           children: [
    //             // Row(
    //             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             //   children: [
    //             //     IconButton(
    //             //       onPressed: () {},
    //             //       icon: Icon(
    //             //         Icons.chevron_left_rounded,
    //             //         size: 22,
    //             //         color: Theme.of(context).colorScheme.secondary,
    //             //       ),
    //             //       splashRadius: 18,
    //             //     ),
    //             //     Text(
    //             //       'Today',
    //             //       style: Theme.of(context).textTheme.labelMedium,
    //             //     ),
    //             //     IconButton(
    //             //       onPressed: () {},
    //             //       icon: Icon(
    //             //         Icons.chevron_right_rounded,
    //             //         size: 22,
    //             //         color: Theme.of(context).colorScheme.secondary,
    //             //       ),
    //             //       splashRadius: 18,
    //             //     ),
    //             //   ],
    //             // ),
    //             Card(
    //               child: SizedBox(
    //                 width: MediaQuery.of(context).size.width,
    //                 child: Column(
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.symmetric(vertical: 18),
    //                       child: CircularPercentIndicator(
    //                         radius: 100,
    //                         lineWidth: 14,
    //                         center: Column(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Text("$remainingCals kcal"),
    //                             const Text("Remaining")
    //                           ],
    //                         ),
    //                         percent: baseGoal == 0 ? 0 : remainingCals / baseGoal,
    //                         progressColor: Colors.blueGrey,
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.symmetric(vertical: 8.0),
    //                       child: Row(
    //                         children: [
    //                           Expanded(
    //                             flex: 3,
    //                             child: Column(
    //                               children: [
    //                                 const Text(''),
    //                                 const SizedBox(height: 10),
    //                                 Padding(
    //                                   padding:
    //                                       const EdgeInsets.symmetric(vertical: 4),
    //                                   child: Row(
    //                                     children: [
    //                                       Padding(
    //                                         padding:
    //                                             const EdgeInsets.only(left: 10),
    //                                         child: Container(
    //                                           height: 8,
    //                                           width: 8,
    //                                           color: Colors.red,
    //                                         ),
    //                                       ),
    //                                       const Padding(
    //                                         padding: EdgeInsets.only(left: 10),
    //                                         child: Text('Carbohydrates'),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                                 Padding(
    //                                   padding:
    //                                       const EdgeInsets.symmetric(vertical: 4),
    //                                   child: Row(
    //                                     children: [
    //                                       Padding(
    //                                         padding:
    //                                             const EdgeInsets.only(left: 10),
    //                                         child: Container(
    //                                           height: 8,
    //                                           width: 8,
    //                                           color: Colors.green,
    //                                         ),
    //                                       ),
    //                                       const Padding(
    //                                         padding: EdgeInsets.only(left: 10),
    //                                         child: Text('Fat'),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                                 Padding(
    //                                   padding:
    //                                       const EdgeInsets.symmetric(vertical: 4),
    //                                   child: Row(
    //                                     children: [
    //                                       Padding(
    //                                         padding:
    //                                             const EdgeInsets.only(left: 10),
    //                                         child: Container(
    //                                           height: 8,
    //                                           width: 8,
    //                                           color: Colors.blue,
    //                                         ),
    //                                       ),
    //                                       const Padding(
    //                                         padding: EdgeInsets.only(left: 10),
    //                                         child: Text('Protiens'),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                                 Padding(
    //                                   padding:
    //                                       const EdgeInsets.symmetric(vertical: 4),
    //                                   child: Row(
    //                                     children: [
    //                                       Padding(
    //                                         padding:
    //                                             const EdgeInsets.only(left: 10),
    //                                         child: Container(
    //                                           height: 8,
    //                                           width: 8,
    //                                           color: Colors.purple,
    //                                         ),
    //                                       ),
    //                                       const Padding(
    //                                         padding: EdgeInsets.only(left: 10),
    //                                         child: Text('Fibers'),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           Expanded(
    //                             flex: 1,
    //                             child: Column(
    //                               children: [
    //                                 Text(
    //                                   'Total',
    //                                   style:
    //                                       Theme.of(context).textTheme.labelMedium,
    //                                 ),
    //                                 const SizedBox(height: 10),
    //                                 Padding(
    //                                   padding:
    //                                       const EdgeInsets.symmetric(vertical: 4),
    //                                   child: Text(
    //                                       '${data.calorieProgress!['totalMacrosAnalysisData']['carbs']} gms'),
    //                                 ),
    //                                 Padding(
    //                                   padding:
    //                                       const EdgeInsets.symmetric(vertical: 4),
    //                                   child: Text(
    //                                       '${data.calorieProgress!['totalMacrosAnalysisData']['fats']} gms'),
    //                                 ),
    //                                 Padding(
    //                                   padding:
    //                                       const EdgeInsets.symmetric(vertical: 4),
    //                                   child: Text(
    //                                       '${data.calorieProgress!['totalMacrosAnalysisData']['proteins']} gms'),
    //                                 ),
    //                                 Padding(
    //                                   padding:
    //                                       const EdgeInsets.symmetric(vertical: 4),
    //                                   child: Text(
    //                                       '${data.calorieProgress!['totalMacrosAnalysisData']['fiber']} gms'),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           // Expanded(
    //                           //   flex: 1,
    //                           //   child: Column(
    //                           //     children: [
    //                           //       Text(
    //                           //         'Goal',
    //                           //         style: Theme.of(context).textTheme.labelMedium,
    //                           //       ),
    //                           //       const SizedBox(height: 10),
    //                           //       Padding(
    //                           //         padding: const EdgeInsets.symmetric(vertical: 4),
    //                           //         child: Text(
    //                           //           '50%',
    //                           //           style: Theme.of(context)
    //                           //               .textTheme
    //                           //               .bodyMedium!
    //                           //               .copyWith(color: Colors.blue),
    //                           //         ),
    //                           //       ),
    //                           //       Padding(
    //                           //         padding: const EdgeInsets.symmetric(vertical: 4),
    //                           //         child: Text(
    //                           //           '50%',
    //                           //           style: Theme.of(context)
    //                           //               .textTheme
    //                           //               .bodyMedium!
    //                           //               .copyWith(color: Colors.blue),
    //                           //         ),
    //                           //       ),
    //                           //       Padding(
    //                           //         padding: const EdgeInsets.symmetric(vertical: 4),
    //                           //         child: Text(
    //                           //           '50%',
    //                           //           style: Theme.of(context)
    //                           //               .textTheme
    //                           //               .bodyMedium!
    //                           //               .copyWith(color: Colors.blue),
    //                           //         ),
    //                           //       ),
    //                           //     ],
    //                           //   ),
    //                           // ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(height: 10),
    //           ],
    //         );
  }

  TabBar customTabBar(context, TabController controller) => TabBar(
        controller: controller,
        // isScrollable: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Calories'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Macros',
            ),
          ),
        ],
        labelStyle: Theme.of(context).textTheme.labelMedium,
        indicatorColor: Colors.red,
        indicatorWeight: 2.5,
      );
}
