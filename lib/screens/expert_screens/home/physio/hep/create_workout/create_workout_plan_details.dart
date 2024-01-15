import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/func/workout/workout_func.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/models/workout/add_workout_temp_model.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/my_workoutplans.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/hep/create_workout/add_ex_to_plan.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/hep/hep_list_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/buttons/customappbar_action_btns.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class CreateWorkoutPlanDetails extends StatefulWidget {
  final AddWorkoutModel workoutModel;
  const CreateWorkoutPlanDetails({required this.workoutModel, Key? key})
      : super(key: key);

  @override
  State<CreateWorkoutPlanDetails> createState() =>
      _CreateWorkoutPlanDetailsState();
}

class _CreateWorkoutPlanDetailsState extends State<CreateWorkoutPlanDetails> {
  List<String> exNotes = ['', '', '', '', '', '', ''];
  List days = ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6', 'Day 7'];
  List<Schedule> schedule = [
    Schedule(),
    Schedule(),
    Schedule(),
    Schedule(),
    Schedule(),
    Schedule(),
    Schedule()
  ];

  void popScreen() {
    Navigator.of(context).pop("value");
  }

  void pushAndRemove() {
    var userData = Provider.of<UserData>(context, listen: false).userData;
    if (userData.roles![0]["name"] == "client") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MyWorkouts()),
          (Route<dynamic> route) => route.isFirst);
    } else {
      if(kSharedPreferences.getString('topExp') == 'Physiotherapy'){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const HepListScreen(
                  title: "HEP",
                )),
                (Route<dynamic> route) => route.isFirst);
      }else{
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const HepListScreen(
                  title: "My Workout Plans",
                )),
                (Route<dynamic> route) => route.isFirst);
      }

    }

    // (route) => route.);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: '',
        widgetRight: CustomAppBarTextBtn(
          title: "Create Plan",
          onClick: schedule.isEmpty
              ? () {}
              : () async {
                  LoadingDialog()
                      .onLoadingDialog("Creating workout plan", context);
                  bool result = await WorkoutFunc().postWorkoutData(context,
                      schedule: schedule,
                      workoutModel: widget.workoutModel,
                      exNotes: exNotes);
                  if (result) {
                    popScreen.call();
                    popScreen.call();
                    Fluttertoast.showToast(msg: "Workout plan created");
                  }
                  pushAndRemove.call();
                },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              widget.workoutModel.name ?? "",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              tileColor: Theme.of(context).canvasColor,
              onTap: () {},
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          widget.workoutModel.note!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                  // const Icon(
                  //   Icons.add_circle_outline_rounded,
                  //   color: Colors.blue,
                  //   size: 28,
                  // ),
                ],
              ),
            ),
          ),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: int.parse(widget.workoutModel.duration!),
            itemBuilder: (context, index) {
              return dayCards(context, exNotes[index], days[index], index + 1);
            },
          ),
        ],
      ),
    );
  }

  Widget dayCards(context, String? exercise, String? day, int dayNumber) {
    return ListTile(
      onTap: () {
        // exercise == ''
        //     ? showBottomPanel(context, dayNumber)
        //     :
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => AddExToPlan(
              exercises: schedule[dayNumber - 1].exercises ?? [],
              workoutModel: widget.workoutModel,
              dayNumber: dayNumber,
            ),
          ),
        )
            .then((value) {
          if (value != null) {
            List<ExerciseWorkoutModel> exmodel = value;
            // log("ex model ${exmodel.toString()}");
            setState(() {
              schedule[dayNumber - 1].day = day;
              schedule[dayNumber - 1].exercises = exmodel;
              schedule[dayNumber - 1].note = "";
              schedule[dayNumber - 1].order = dayNumber.toString();
            });
          }
        });
      },
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                day!,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
                initialValue: exNotes[dayNumber - 1],
                decoration: const InputDecoration(
                  hintText: 'Click to add note',
                  fillColor: Colors.transparent,
                  contentPadding: EdgeInsets.all(0),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  exNotes[dayNumber - 1] = value;
                },
                style: Theme.of(context).textTheme.bodySmall!)
            // : Text(
            //     exercise!,
            //     style: Theme.of(context).textTheme.labelSmall,
            //   )
            ,
            if (schedule[dayNumber - 1].day != null)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: schedule[dayNumber - 1].exercises!.length,
                itemBuilder: (context, index) => Text(
                  schedule[dayNumber - 1].exercises![index].exerciseId!["name"],
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Theme.of(context).colorScheme.onBackground,
        size: 30,
      ),
    );
  }

  void showBottomPanel(context, int dayNumber) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add exercises using the below options.',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 20),
              GradientButton(
                title: 'Copy from plan',
                func: () {},
                gradient: blueGradient,
              ),
              const SizedBox(height: 20),
              GradientButton(
                title: 'Add new exercise',
                func: () {
                  Navigator.of(context).pop();
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => AddExToPlan(
                  //       exSchedule: [],
                  //       workoutModel: widget.workoutModel,
                  //       dayNumber: dayNumber,
                  //     ),
                  //   ),
                  // );
                },
                gradient: blueGradient,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
