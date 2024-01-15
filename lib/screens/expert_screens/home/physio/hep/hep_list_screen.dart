import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/hep/create_workout/create_new_workout_plan.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/hep/hep_days_plan_screen.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/heplist_details_card.dart';
import 'package:provider/provider.dart';

class HepListScreen extends StatefulWidget {
  final String title;
  final bool isFromClient;
  const HepListScreen(
      {Key? key, required this.title, this.isFromClient = false})
      : super(key: key);

  @override
  State<HepListScreen> createState() => _HepListScreenState();
}

class _HepListScreenState extends State<HepListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: false,
                  title: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                  iconTheme: Theme.of(context).iconTheme.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium!.color),
                  bottom: AppBar(
                    elevation: 0,
                    backgroundColor: orange,
                    automaticallyImplyLeading: false,
                    title: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 5),
                        child: TextField(
                          cursorColor: whiteColor,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: whiteColor),
                          decoration: InputDecoration(
                            fillColor: orange,
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: 'Search for your My Therapy plans',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: whiteColor),
                            suffixIcon: const Icon(
                              Icons.search,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Other Sliver Widgets
                SliverList(
                  delegate:
                      SliverChildListDelegate([const HEPListSliverHolder()]),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            height: 60,
            alignment: Alignment.centerLeft,
            color: orange,
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => const CreateNewWorkoutPlan(),
                      ),
                    )
                    .then((value) => setState(
                          () {},
                        ));
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.add,
                    color: whiteColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Create new workout',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: whiteColor),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      // persistentFooterButtons: [
      //   Container(
      //     height: 50,
      //     color: Colors.red,
      //   )
      // ],
    );
  }
}

class HEPListSliverHolder extends StatefulWidget {
  const HEPListSliverHolder({
    Key? key,
  }) : super(key: key);

  @override
  State<HEPListSliverHolder> createState() => _HEPListSliverHolderState();
}

class _HEPListSliverHolderState extends State<HEPListSliverHolder> {
  bool isLoading = false;

  List<WorkoutModel> workoutsList = [];
  Future<void> fetchWorkout() async {
    setState(() {
      isLoading = true;
    });
    try {
      String expertId =
          Provider.of<UserData>(context, listen: false).userData.id!;
      workoutsList = await Provider.of<WorkoutProvider>(context, listen: false)
          .getWorkoutPlan("?expertId=$expertId");
      log('fetched workout details');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting workout details $e");
      Fluttertoast.showToast(msg: "Unable to fetch HEP");
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
    return isLoading
        ? const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : workoutsList.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 30, left: 10, right: 10),
                  child: Text("No workout plans available. Please create one."),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: workoutsList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) => HEPlistDetailsCard(
                      workoutModel: workoutsList[index],
                      func: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                  builder: (context) => HepDaysPlanScreen(
                                        workoutModel: workoutsList[index],
                                      )),
                            )
                            .then(
                              (value) => setState(
                                () {
                                  fetchWorkout();
                                },
                              ),
                            );
                      },
                    ));
  }
}
