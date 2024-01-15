import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/exercise/workout_types.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/func/rzp.dart';
import 'package:healthonify_mobile/func/workout/workout_func.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/hep/hep_plan_details.dart';
import 'package:healthonify_mobile/widgets/buttons/customappbar_action_btns.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class HepDaysPlanScreen extends StatefulWidget {
  final WorkoutModel workoutModel;
  final bool isEditEnabled;
  final bool isPurchase;
  const HepDaysPlanScreen(
      {required this.workoutModel,
      this.isEditEnabled = true,
      Key? key,
      this.isPurchase = false})
      : super(key: key);

  @override
  State<HepDaysPlanScreen> createState() => _HepDaysPlanScreenState();
}

class _HepDaysPlanScreenState extends State<HepDaysPlanScreen> {
  bool onEdit = false;
  List<String> notes = [];
  late String title;
  late String validityInDays;
  late Razorpay _razorpay;

  bool isLoading = false;
  String goal = "Select", level = "Select", duration = "Select";

  void getGoal(String value) =>
      {widget.workoutModel.goal = value, setState(() => goal = value)};

  void getDuration(String value) {
    widget.workoutModel.daysInweek = value;
    setState(() => duration = value);
  }

  void getLevel(String value) {
    widget.workoutModel.level = value;
    setState(() => level = value);
  }

  void popScreen() {
    Navigator.of(context).pop();
  }

  Future<void> deleteWorkout() async {
    LoadingDialog().onLoadingDialog("Deleting hep", context);
    try {
      await Provider.of<WorkoutProvider>(context, listen: false)
          .deleteWorkoutPlan(widget.workoutModel.id!);
      popScreen();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting workout details $e");
      Fluttertoast.showToast(msg: "Unable to delete hep");
    } finally {
      popScreen();
    }
  }

  Future<void> editWorkout() async {
    await WorkoutFunc().updateWorkoutPlan(context,
        workoutModel: widget.workoutModel,
        title: title,
        notes: notes,
        popScreen: popScreen);
  }

  void onEditClick() {
    setState(() => onEdit = !onEdit);
    if (!onEdit) {
      log(notes.toString());
      editWorkout();
    }
  }

  Future<void> buyPlan() async {
    // Rzp.openCheckout(widget.data.price!, "Hey", "rzp_test_ZyEGUT3SkQbtE6", "",
    //     _razorpay, "cId", context, widget.data.expertId!,
    //     uid: "", f: "packages");
    LoadingDialog().onLoadingDialog("Please Wait", context);
    var userData = Provider.of<UserData>(context, listen: false).userData;

    Map<String, dynamic> data = {
      "userId": userData.id!,
      "workoutPlanId": "",
      "startDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "startTime": DateFormat("HH:mm").format(DateTime.now())
    };
    log(data.toString());
    try {
      data["workoutPlanId"] = widget.workoutModel.id;
      await Provider.of<WorkoutProvider>(context, listen: false)
          .purchaseWorkoutPlan(data)
          .then((paymentData) {
        log(paymentData.toString());
        Rzp.openCheckout(
            widget.workoutModel.price!,
            "Purchase Package",
            "rzp_test_ZyEGUT3SkQbtE6",
            paymentData["paymentData"]["rzpOrderId"]!,
            _razorpay,
            paymentData["paymentData"]["workoutPlanId"],
            context,
            "",
            uid: userData.id!,
            f: "workout");
      });
    } on HttpException catch (e) {
      log("http Error submit purchase plan form $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 2000),
          content: CustomSnackBarChild(
            title: e.message,
          ),
        ),
      );
    } catch (e) {
      log("Error submit purchase plan form $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, Rzp.handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, Rzp.handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, Rzp.handleExternalWallet);
    log("hey");
    title = widget.workoutModel.name ?? "";
    validityInDays = widget.workoutModel.validityInDays ?? "";
    if (widget.workoutModel.schedule != null) {
      log("inside");
      notes = List.generate(widget.workoutModel.schedule!.length,
          (index) => widget.workoutModel.schedule![index].note ?? "");
    }
    goal = widget.workoutModel.goal ?? "";
    level = widget.workoutModel.level ?? "";
    duration = widget.workoutModel.daysInweek ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: '',
        widgetRight: widget.isEditEnabled
            ? CustomAppBarTextBtn(
                title: onEdit ? "Save" : "Edit",
                onClick: () {
                  onEditClick();
                  // deleteWorkout();
                },
              )
            : widget.isPurchase
                ? CustomAppBarTextBtn(
                    title: "Buy Plan",
                    onClick: () {
                      buyPlan();
                    },
                  )
                : const SizedBox(),
        actionWIdget2: widget.isEditEnabled
            ? CustomAppBarTextBtn(
                title: "Delete",
                onClick: () {
                  deleteWorkout();
                },
              )
            : const SizedBox(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: !onEdit,
                          initialValue: widget.workoutModel.name ?? "",
                          style: Theme.of(context).textTheme.headlineMedium,
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              fillColor: Colors.transparent,
                              filled: true,
                              contentPadding: EdgeInsets.all(0)),
                          onChanged: (value) => title = value,
                        ),
                      ),
                      if (onEdit) const Icon(Icons.edit),
                    ],
                  ),
            const SizedBox(
              height: 20
            ),
            Text(
              'Description',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,fontSize: 18),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: !onEdit,
                    maxLines: null,
                    initialValue: widget.workoutModel.description ?? "",
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: const InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: Colors.transparent,
                        filled: true,
                        contentPadding: EdgeInsets.all(0)),
                    onChanged: (value) =>
                    widget.workoutModel.description = value,
                  ),
                ),
                if (onEdit)
                  Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
              ],
            ),
            // Text(
            //   widget.workoutModel.description ?? "",
            //   style: Theme.of(context).textTheme.bodySmall,
            // ),
            Text(
              'Price',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,fontSize: 18),
            ),
            const SizedBox(
                height: 10
            ),
            Text(
              widget.workoutModel.price.toString(),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal,fontSize: 18),
            ),
            const SizedBox(
              height: 10
            ),
            otherFieldsCard(),
            // ListView.builder(
            //   physics: const BouncingScrollPhysics(),
            //   shrinkWrap: true,
            //   itemCount: widget.workoutModel.schedule!.length,
            //   itemBuilder: (context, index) {
            //     return dayCards(
            //         widget.workoutModel.schedule![index], notes[index], index);
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget dayCards(Schedule schedule, String note, int index) {
    return ListTile(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: ((context) => HepPlanDetails(
                  schedule: schedule,
                  title: widget.workoutModel.name ?? "",
                  isEdit: onEdit,
                )),
          ),
        )
            .then((value) {
          if (value != null) {
            List<ExerciseWorkoutModel> exmodel = value;
            log("ex model ${exmodel.toString()}");
            setState(() {
              schedule.exercises = exmodel;
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
                schedule.day ?? "",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                      readOnly: !onEdit,
                      initialValue: note,
                      decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: Colors.transparent,
                          hintText: "Enter a note",
                          filled: true,
                          contentPadding: EdgeInsets.all(0)),
                      onChanged: (value) => notes[index] = value,
                      style: Theme.of(context).textTheme.bodySmall!),
                ),
                if (onEdit) const Text("-"),
              ],
            ),
            if (schedule.exercises != null)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: schedule.exercises!.length,
                itemBuilder: (context, index) => Text(
                  "${schedule.exercises![index].exerciseId!["name"]}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
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

  Widget otherFieldsCard() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: dropdownDialog(goalDropdownOptions, goal, getGoal),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: dropdownDialog(levelDropdownOptions, level, getLevel),
            ),
            // Expanded(
            //   child: dropdownDialog(
            //       durationDropdownOptions, duration, getDuration),
            // ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                  readOnly: !onEdit,
                  initialValue:
                      "${widget.workoutModel.validityInDays} days plan",
                  style: Theme.of(context).textTheme.titleSmall,
                  decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      fillColor: Colors.transparent,
                      filled: true,
                      contentPadding: EdgeInsets.all(0)),
                  onChanged: (value) {
                    validityInDays = value;
                    widget.workoutModel.validityInDays;
                  }),
            ),
            if (widget.isPurchase)
              TextButton(
                onPressed: () {
                  buyPlan();
                },
                child: const Text('Buy Plan'),
              ),
            if (onEdit) const Icon(Icons.edit),
          ],
        ),
      ],
    );
  }

  Widget dropdownDialog(
    List options,
    String title,
    Function getFunc,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: grey,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(5),
          onTap: !onEdit
              ? () {}
              : () {
                  showPopUp(options, title, getFunc);
                },
          tileColor: Theme.of(context).canvasColor,
          title: Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          // trailing: const Icon(
          //   Icons.chevron_right_rounded,
          //   color: Colors.grey,
          //   size: 26,
          // ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }

  void showPopUp(List options, String title, Function getFunc) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        getFunc(options[index]["value"]);
                      },
                      title: Text(
                        options[index]["name"],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}
