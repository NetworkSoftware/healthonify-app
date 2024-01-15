import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/weight_goal/weight_goal_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/custom_ex/add_custom_exercise.dart';
import 'package:healthonify_mobile/screens/my_diary/exercises/widgets/list_exercise_widget.dart';
import 'package:healthonify_mobile/screens/my_diary/exercises/widgets/my_exercise_list_widget.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class CardioStrengthScreen extends StatefulWidget {
  final String screenName;
  const CardioStrengthScreen({required this.screenName, Key? key})
      : super(key: key);

  @override
  State<CardioStrengthScreen> createState() => _CardioStrengthScreenState();
}

class _CardioStrengthScreenState extends State<CardioStrengthScreen>
    with SingleTickerProviderStateMixin {
  String? currentWeight;
  bool isLoading = false;
  Future<void> getWeightGoal() async {
    setState(() {
      isLoading = true;
    });
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      var data = await Provider.of<WeightGoalProvider>(context, listen: false)
          .getWeightGoals(userId);

      if (data.isNotEmpty) {
        currentWeight = data[0].currentWeight;
      }

      log('fetched weight goals');
    } on HttpException catch (e) {
      log('HTTP Exception: $e');
    } catch (e) {
      log("Error getting weight goals: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    getWeightGoal();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: widget.screenName,
        // widgetRight: Row(
        //   children: [
        //     TextButton(
        //       onPressed: () {},
        //       child: Text(
        //         'Multi-add',
        //         style: Theme.of(context)
        //             .textTheme
        //             .labelSmall!
        //             .copyWith(color: orange),
        //       ),
        //     ),
        //     IconButton(
        //       onPressed: () {},
        //       icon: const Icon(
        //         Icons.more_vert,
        //         color: whiteColor,
        //         size: 26,
        //       ),
        //       splashRadius: 20,
        //     ),
        //   ],
        // ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 64,
                    child: AppBar(
                      bottom: TabBar(
                        controller: tabController,
                        tabs: const [
                          Tab(
                            child: Text('Browse All'),
                          ),
                          Tab(
                            child: Text('My Exercises'),
                          ),
                        ],
                        labelStyle: Theme.of(context).textTheme.labelSmall,
                        indicatorColor: Colors.red,
                        indicatorWeight: 2.5,
                      ),
                    ),
                  ),
                  DefaultTabController(
                    length: 2,
                    child: Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          ListExerciseWidget(
                              title: widget.screenName,
                              userWeight: currentWeight ?? "0"),
                          const MyExercisesListWidget(),
                          // browseAll(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AddCustomExercise();
              }));
            },
            child: Text(
              'CREATE AN EXERCISE',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }

  // Widget mostUsed() {
  // return SingleChildScrollView(
  //   physics: const BouncingScrollPhysics(),
  //   child: Column(
  //     children: [
  //       ListView.builder(
  //         physics: const BouncingScrollPhysics(),
  //         shrinkWrap: true,
  //         itemCount: thisList.length,
  //         itemBuilder: (context, index) => Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
  //           child: ListTile(
  //             onTap: () {},
  //             title: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   thisList[index]['title'],
  //                   style: Theme.of(context).textTheme.bodyMedium,
  //                 ),
  //                 Text(
  //                   thisList[index]['duration'],
  //                   style: Theme.of(context)
  //                       .textTheme
  //                       .bodySmall!
  //                       .copyWith(color: Colors.grey),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),
  // );
  // }

  Widget browseAll() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 25,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListTile(
                onTap: () {},
                title: Text(
                  'Exercise $index',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myExercises() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Want to quickly add your custom exercises? Your my exercises list will show any custom exercises that you have previously created.',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
