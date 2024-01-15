// import 'package:flutter/material.dart';
// import 'package:healthonify_mobile/constants/theme_data.dart';
// import 'package:healthonify_mobile/screens/client_screens/plan_details.dart';
// import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
// import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
// import 'package:healthonify_mobile/widgets/other/carousel_slider.dart';

// class PlansScreen extends StatelessWidget {
//   const PlansScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(
//         appBarTitle: 'Plans',
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const CustomCarouselSlider(imageUrls: [
//                 'https://images.unsplash.com/photo-1607081759141-5035e0a710a4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
//                 'https://images.unsplash.com/photo-1606636660801-c61b8e97a1dc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
//                 'https://images.unsplash.com/photo-1606926693996-d1dfbed4e8c9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
//                 'https://images.unsplash.com/photo-1624455806586-037944b1fa1a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80',
//               ]),
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Text(
//                   'View Plans and Buy',
//                   style: Theme.of(context).textTheme.labelLarge,
//                 ),
//               ),
//               ListView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: 6,
//                 itemBuilder: (context, index) {
//                   return expertPlanCard(context);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget expertPlanCard(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 6),
//       child: Card(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 10, left: 10),
//               child: Text(
//                 'Personal Training (L1) (13s)',
//                 style: Theme.of(context).textTheme.labelLarge,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Text(
//                 'Transformation - 45 days',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Text(
//                 'Weight Loss',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Text(
//                 'Duration - 45 days',
//                 style: Theme.of(context).textTheme.bodyMedium,
//               ),
//             ),
//             // const SizedBox(height: 4),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) {
//                         return const PlanDetailsScreen();
//                       }));
//                     },
//                     child: const Text('view more'),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: const BorderRadius.only(
//                   bottomRight: Radius.circular(10),
//                   bottomLeft: Radius.circular(10),
//                 ),
//               ),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '₹ 12,000',
//                       style: Theme.of(context).textTheme.labelLarge,
//                     ),
//                     GradientButton(
//                       func: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (context) {
//                           return const PlanDetailsScreen();
//                         }));
//                       },
//                       title: 'Select',
//                       gradient: orangeGradient,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/hep/hep_days_plan_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

enum PopUp { start, edit, copy }

class PlansScreen extends StatefulWidget {
  final String from;

  const PlansScreen({Key? key, this.from = "wm"}) : super(key: key);

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  bool isLoading = false;
  List<WorkoutModel> workoutsList = [];

  Future<void> fetchWorkout() async {
    setState(() {
      isLoading = true;
    });
    // var userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      workoutsList = await Provider.of<WorkoutProvider>(context, listen: false)
          .getWorkoutPlan("?type=paidPlan");
      log('fetched workout details');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting workout details $e");
      Fluttertoast.showToast(msg: "Unable to fetch workout plans");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorkout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Expert Curated Plans',
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : workoutsList.isEmpty
              ? const Center(
                  child: Text("No workouts available. Create one now."),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: workoutsList.length,
                        itemBuilder: (context, index) {
                          return workoutCard(workoutsList[index]);
                        },
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget workoutCard(WorkoutModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => HepDaysPlanScreen(
                      workoutModel: model,
                      isEditEnabled: false,
                      isPurchase: true,
                    )),
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        model.name!,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    // PopupMenuButton(
                    //   color: Theme.of(context).canvasColor,
                    //   icon: Icon(
                    //     Icons.more_vert,
                    //     color: Theme.of(context).colorScheme.onBackground,
                    //     size: 26,
                    //   ),
                    //   onSelected: (item) {
                    //     if (item == PopUp.edit) {
                    //       Navigator.of(context)
                    //           .push(
                    //             MaterialPageRoute(
                    //                 builder: (context) => HepDaysPlanScreen(
                    //                       workoutModel: model,
                    //                     )),
                    //           )
                    //           .then(
                    //             (value) => setState(
                    //               () {
                    //                 fetchWorkout();
                    //               },
                    //             ),
                    //           );
                    //     }
                    //     if (item == PopUp.start) {
                    //       Navigator.of(context).push(
                    //         MaterialPageRoute(
                    //             builder: (context) => TrackWkDays(
                    //                   workoutModel: model,
                    //                 )),
                    //       );
                    //     }
                    //   },
                    //   itemBuilder: (context) {
                    //     return <PopupMenuEntry<PopUp>>[
                    //       PopupMenuItem(
                    //         value: PopUp.start,
                    //         child: Text(
                    //           'Start',
                    //           style: Theme.of(context).textTheme.bodyMedium,
                    //         ),
                    //       ),
                    //       PopupMenuItem(
                    //         value: PopUp.edit,
                    //         child: Text(
                    //           'Edit',
                    //           style: Theme.of(context).textTheme.bodyMedium,
                    //         ),
                    //       ),

                    //       // PopupMenuItem(
                    //       //   value: PopUp.copy,
                    //       //   child: Text(
                    //       //     'Copy Plan',
                    //       //     style: Theme.of(context).textTheme.bodyMedium,
                    //       //   ),
                    //       // ),
                    //     ];
                    //   },
                    //   splashRadius: 20,
                    // ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    model.description!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 4),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         flex: 1,
                //         child: Column(
                //           children: [
                //             Text(
                //               'Beginner',
                //               style: Theme.of(context).textTheme.labelMedium,
                //             ),
                //             const Text('Level'),
                //           ],
                //         ),
                //       ),
                //       const VerticalDivider(
                //         color: Colors.grey,
                //         indent: 10,
                //         endIndent: 10,
                //       ),
                //       Expanded(
                //         flex: 1,
                //         child: Column(
                //           children: [
                //             Text(
                //               'Fat Loss',
                //               style: Theme.of(context).textTheme.labelMedium,
                //             ),
                //             const Text('Goal'),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              model.daysInweek!,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              'No of days in a week',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: Colors.grey,
                        indent: 10,
                        endIndent: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Text(
                              "${model.validityInDays!} days",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              'Duration',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF717579),
          ),
          fillColor: Theme.of(context).canvasColor,
          filled: true,
          hintText: 'Search workout plan',
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color(0xFF717579),
              ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          contentPadding: const EdgeInsets.all(0),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: whiteColor,
      ),
    );
  }
}
