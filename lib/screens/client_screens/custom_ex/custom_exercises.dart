import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/exercise/exercise.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/exercises/exercises_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/custom_ex/add_custom_exercise.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/expert_exer_details_card.dart';
import 'package:provider/provider.dart';

class CustomExercisesScreen extends StatefulWidget {
  const CustomExercisesScreen({Key? key}) : super(key: key);

  @override
  State<CustomExercisesScreen> createState() => _CustomExercisesScreenState();
}

class _CustomExercisesScreenState extends State<CustomExercisesScreen> {
  List<Exercise> exData = [];
  bool isLoading = false;

  Future<void> fetchExercises() async {
    // setState(() {
    //   isLoading = true;
    // });
    try {
      exData = await Provider.of<ExercisesData>(context, listen: false)
          .fetchExercises(
              data:
                  "userId=${Provider.of<UserData>(context, listen: false).userData.id}");
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Something went wrong');
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Something went wrong');
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Custom Exercises',
        // widgetRight: IconButton(
        //   onPressed: () {
        //     // customExerciseSheet(context);
        //   },
        //   icon: Icon(
        //     Icons.filter_alt_outlined,
        //     color: Theme.of(context).colorScheme.onBackground,
        //     size: 26,
        //   ),
        //   splashRadius: 20,
        // ),
      ),
      body: FutureBuilder(
        future: fetchExercises(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : SafeArea(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: exData.length,
                      itemBuilder: (context, index) => ExerciseDetailsCard(
                        exData: exData[index],
                        isSelectEx: false,
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: Container(
        height: 56,
        decoration: const BoxDecoration(
          color: orange,
        ),
        child: TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddCustomExercise();
            })).then((value) {
              fetchExercises();
              setState(() {});
            });
          },
          child: Text(
            'Add Custom Exercises',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }

  void customExerciseSheet(context) {
    String? bodyPart;
    String? category;
    List bodyParts = [
      'Chest',
      'Shoulder',
      'Triceps',
      'Back',
      'Biceps',
      'Quadriceps',
      'Calves',
      'Hamstrings',
      'Cardio',
      'Abs',
      'Obliques',
    ];
    List categories = [
      'Weight Training',
      'Cardio',
      'Crossfit',
      'Functional',
      'Free Body',
      'Care',
      'Strength Training',
      'Aerobic Training',
    ];
    showModalBottomSheet(
        backgroundColor: Theme.of(context).canvasColor,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Select Filter',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    StatefulBuilder(
                      builder: (context, newState) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: DropdownButtonFormField(
                          isDense: true,
                          items:
                              bodyParts.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            newState(() {
                              bodyPart = newValue!;
                            });
                          },
                          value: bodyPart,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.25,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.25,
                              ),
                            ),
                            constraints: const BoxConstraints(
                              maxHeight: 56,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          hint: Text(
                            'Select primary body part',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    StatefulBuilder(
                      builder: (context, thisState) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: DropdownButtonFormField(
                          isDense: true,
                          items:
                              categories.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            thisState(() {
                              category = newValue!;
                            });
                          },
                          value: category,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.25,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.25,
                              ),
                            ),
                            constraints: const BoxConstraints(
                              maxHeight: 56,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          hint: Text(
                            'Select category',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 60,
                          color: Theme.of(context).canvasColor,
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const AddCustomExercise();
                          }));
                        },
                        child: Container(
                          height: 60,
                          color: orange,
                          child: Center(
                              child: Text(
                            'Submit',
                            style: Theme.of(context).textTheme.labelLarge,
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget customExerciseCard(context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Image.asset(
                  'assets/icons/image_placeholder.png',
                  // width: 90,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Bodyweight Leg Raise',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: orange,
                              size: 22,
                            ),
                            splashRadius: 20,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.delete_outline,
                              color: orange,
                              size: 22,
                            ),
                            splashRadius: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Abs',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sequence No : 1',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '3 sets',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar(context) {
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
          hintText: 'Search exercise',
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
