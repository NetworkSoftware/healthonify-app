import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';
import 'package:healthonify_mobile/providers/weight_management/diet_plan_provider.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/expert_diet_meal_plan/view_diet_meal_plan.dart';
import 'package:provider/provider.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour, assign }

class DietPlanCard extends StatefulWidget {
  final DietPlan dietPlan;
  final Function deleteDietPlan;
  final bool isFromClient;
  final String clientId;
  final bool isFromTopCard;

  const DietPlanCard({
    Key? key,
    required this.dietPlan,
    required this.deleteDietPlan,
    required this.isFromClient,
    required this.isFromTopCard,
    this.clientId = "",
  }) : super(key: key);

  @override
  State<DietPlanCard> createState() => _DietPlanCardState();
}

class _DietPlanCardState extends State<DietPlanCard> {
  void popScreen() {
    Navigator.of(context).pop();
  }

  Future<void> assignDietPlan() async {
    try {
      await Provider.of<DietPlanProvider>(context, listen: false)
          .assignDietPlan({
        "dietPlanId": widget.dietPlan.id,
        "userId": widget.clientId,
      });
      popScreen();
    } on HttpException catch (e) {
      log("error assigning user ${e.toString}");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error assigning user ${e.toString}");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => ViewDietMealPlan(
                          dietPlan: widget.dietPlan,
                          isEditEnabled: !widget.isFromTopCard,
                        )))
                .then((value) => setState(() {}));
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.dietPlan.name ?? "",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (!widget.isFromTopCard)
                      PopupMenuButton<Menu>(
                        icon: const Icon(Icons.more_vert),
                        // Callback that sets the selected popup menu item.
                        onSelected: (Menu item) {
                          if (item == Menu.itemOne) {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (context) => ViewDietMealPlan(
                                      dietPlan: widget.dietPlan,
                                      isEdit: true,
                                    ),
                                  ),
                                )
                                .then((value) => setState(() {}));
                          }
                          if (item == Menu.itemTwo) {
                            widget.deleteDietPlan();

                            // DietFunc()
                            //     .deleteDietPlan(context, widget.dietPlan.id!);
                          }
                          if (item == Menu.assign) {
                            assignDietPlan();
                            // DietFunc()
                            //     .deleteDietPlan(context, widget.dietPlan.id!);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            widget.isFromClient
                                ? <PopupMenuEntry<Menu>>[
                                    const PopupMenuItem<Menu>(
                                      value: Menu.assign,
                                      child: Text('Assign'),
                                    ),
                                    // const PopupMenuItem<Menu>(
                                    //   value: Menu.itemThree,
                                    //   child: Text('Duplicate'),
                                    // ),
                                  ]
                                : <PopupMenuEntry<Menu>>[
                                    const PopupMenuItem<Menu>(
                                      value: Menu.itemOne,
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem<Menu>(
                                      value: Menu.itemTwo,
                                      child: Text('Delete'),
                                    ),
                                    // const PopupMenuItem<Menu>(
                                    //   value: Menu.itemThree,
                                    //   child: Text('Duplicate'),
                                    // ),
                                  ],
                      ),
                  ],
                ),
                const Text(
                  "Created on 17/06/22 02:43 PM",
                ),
                const SizedBox(
                  height: 20,
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.dietPlan.level ?? "",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const Text("Level"),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        width: 20,
                        thickness: 1,
                        endIndent: 0,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.dietPlan.goal ?? "",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const Text("Goal"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "636.5 kcal (should do calc)",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const Text("Total Calories"),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        width: 20,
                        thickness: 1,
                        endIndent: 0,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.dietPlan.validity ?? 0}",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const Text("Duration"),
                          ],
                        ),
                      )
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
}
