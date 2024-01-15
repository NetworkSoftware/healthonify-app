import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/wm/create_diet_plan_models.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/expert_diet_meal_plans.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class AddDietPlan extends StatefulWidget {
  final String title;
  const AddDietPlan({
    Key? key,
    this.title = "Add Diet Plan",
  }) : super(key: key);

  @override
  State<AddDietPlan> createState() => _AddDietPlanState();
}

class _AddDietPlanState extends State<AddDietPlan> {
  // bool _isSelected = false;
  CreateDietPlanModel dietPlanModel = CreateDietPlanModel();
  String selectGoal = "Select a goal", selectLevel = "Select a level";
  final _formKey = GlobalKey<FormState>();

  void saveDietPlanName(String value) => dietPlanModel.name = value;

  void saveTotalDietDays(String value) => dietPlanModel.validity = value;

  void saveNote(String value) => dietPlanModel.note = value;

  void saveGoal(String value) {
    selectGoal = value;
    dietPlanModel.goal = value;
    setState(() {});
  }

  void saveLevel(String value) {
    selectLevel = value;
    dietPlanModel.level = value;
    setState(() {});
  }

  void onNext() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    if (dietPlanModel.goal == null || dietPlanModel.goal!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a goal");
      return;
    }
    if (dietPlanModel.level == null || dietPlanModel.level!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a level");
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExpertDietMealPlans(
          title: "Add Plan",
          createDietPlanModel: dietPlanModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(appBarTitle: widget.title),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _textFieldBuilder(context,
                            onSaved: saveDietPlanName,
                            hint:
                                "Diet plan name eg fatloss plan, weight gain plan",
                            title: "Diet Plan Name"),
                        const SizedBox(
                          height: 15,
                        ),

                        _textFieldBuilder(context,
                            textInputType: TextInputType.number,
                            onSaved: saveTotalDietDays,
                            hint: "Total Diet Days",
                            title: "Total Diet Days"),
                        const SizedBox(
                          height: 15,
                        ),
                        // CheckboxListTile(
                        //   contentPadding: const EdgeInsets.all(0),
                        //   title: Text(
                        //     'Delete this plan after total number of days are complete',
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .bodyMedium!
                        //         .copyWith(color: Colors.black),
                        //   ),
                        //   value: _isSelected,
                        //   onChanged: (isChecked) {
                        //     setState(() {
                        //       _isSelected = isChecked!;
                        //     });
                        //   },
                        //   activeColor: const Color(0xFFff7f3f),
                        //   checkboxShape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(4),
                        //   ),
                        //   controlAffinity: ListTileControlAffinity.trailing,
                        // ),
                        _noteFieldBuilder(context,
                            onSaved: saveNote,
                            hint: "Add Note ",
                            title: "Add a note"),
                        const SizedBox(
                          height: 20,
                        ),
                        dropdownDialog(
                            getFunc: saveGoal,
                            options: [
                              'Fat loss',
                              'Muscle Gain',
                              'Weight Gain',
                              'General Fitness',
                              'Maintain Weight',
                            ],
                            title: selectGoal),
                        // SelectCategory(
                        //   dropdownValue: "Fat loss",
                        //   isExpanded: true,
                        //   isUnderline: true,
                        //   data: const [
                        //     'Fat loss',
                        //     'Muscle Gain',
                        //     'Weight Gain',
                        //     'General Fitness',
                        //     'Maintain Weight',
                        //   ],
                        //   title: "Select Goal",
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                        dropdownDialog(
                            getFunc: saveLevel,
                            options: const [
                              'Beginner',
                              'Intermediate Gain',
                              'Advanced',
                              'General',
                            ],
                            title: selectLevel),

                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.secondary,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: () {
                    onNext();
                  },
                  child: Center(
                    child: Text(
                      "Next",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: whiteColor),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textFieldBuilder(
    BuildContext context, {
    required Function onSaved,
    required String title,
    required String hint,
    TextInputType textInputType = TextInputType.name,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          keyboardType: textInputType,
          decoration: InputDecoration(
            hintText: hint,
          ),
          onSaved: (newValue) => onSaved(newValue),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "This field cannot be empty";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _noteFieldBuilder(
    BuildContext context, {
    required Function onSaved,
    required String title,
    required String hint,
    TextInputType textInputType = TextInputType.name,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          keyboardType: textInputType,
          decoration: InputDecoration(
            hintText: hint,
          ),
          onSaved: (newValue) => onSaved(newValue),
          validator: (value) {
            // if (value == null || value.isEmpty) {
            //   return "This field cannot be empty";
            // }
            return null;
          },
        ),
      ],
    );
  }

  Widget dropdownDialog({
    required List options,
    required String title,
    required Function getFunc,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: grey,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ListTile(
            onTap: () {
              showPopUp(options, title, getFunc);
            },
            tileColor: Theme.of(context).canvasColor,
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.grey),
            ),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
              size: 26,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ],
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
                        getFunc(options[index]);
                      },
                      title: Text(
                        options[index],
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
