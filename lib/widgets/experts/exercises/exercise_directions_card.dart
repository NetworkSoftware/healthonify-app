import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:provider/provider.dart';

import '../../../models/exercise/exercise.dart';
import '../../../models/exercise/exercise_directions_model.dart';
import '../../../models/http_exception.dart';
import '../../../providers/exercises/exercises_data.dart';

class ExerciseDirectionsCard extends StatefulWidget {
  final Exercise exerciseData;
  const ExerciseDirectionsCard({
    Key? key,
    required this.exerciseData,
  }) : super(key: key);

  @override
  State<ExerciseDirectionsCard> createState() => _ExerciseDirectionsCardState();
}

class _ExerciseDirectionsCardState extends State<ExerciseDirectionsCard> {
  List<ExerciseDirection> exData = [];
  var data;
  Future<void> fetchExercises() async {
    try {
      exData = await Provider.of<ExercisesData>(context, listen: false)
          .fetchExerciseDirection(data: "${widget.exerciseData.id}");
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
     data = exData[0].description!;
    
  }

  @override
  Widget build(BuildContext context) {
    var desc = widget.exerciseData.id;
    log(desc.toString());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: Card(
        child: FutureBuilder(
          future: fetchExercises(),
          builder: (context, snapshot) {
            // if(!snapshot.hasData){
            //   return CircularProgressIndicator();
            // }
            if(data!= null){
               return Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Directions",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: whiteColor),
                        ),
                        IconButton(
                          onPressed: () {},
                          splashRadius: 20,
                          color: whiteColor,
                          icon: const Icon(Icons.videocam),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Position",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text("$data",
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            );
            }
           else{
            return const Center(child: CircularProgressIndicator());
           }
          }
        ),
      ),
    );
  }
}
