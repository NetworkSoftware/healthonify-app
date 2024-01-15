import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/exercise/exercise.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/exercises/exercises_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/expert_exer_details_card.dart';
import 'package:provider/provider.dart';

class MyExercisesListWidget extends StatefulWidget {
  const MyExercisesListWidget({super.key});

  @override
  State<MyExercisesListWidget> createState() => _MyExercisesListWidgetState();
}

class _MyExercisesListWidgetState extends State<MyExercisesListWidget> {
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
      log("my exercise list widget http error $e");
      Fluttertoast.showToast(msg: 'Something went wrong');
    } catch (e) {
      log("my exercise list widget error $e");
      Fluttertoast.showToast(msg: 'Something went wrong');
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchExercises(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : exData.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                            "No Exercises have been added, you can click on the butto below to add custom exercises"),
                      ),
                    )
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
    );
  }
}
