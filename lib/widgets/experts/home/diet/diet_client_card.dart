import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/wm/create_diet_plan_models.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/expert_diet_meal_plans.dart';

class DietClientCard extends StatefulWidget {
  final String patientName;
  final String patientEmail;
  final String patientContact;
  final String location;
  final String imageUrl;
  final String clientId;

  const DietClientCard({
    Key? key,
    required this.patientName,
    required this.patientEmail,
    required this.patientContact,
    required this.location,
    required this.imageUrl,
    required this.clientId,
  }) : super(key: key);

  @override
  State<DietClientCard> createState() => _DietClientCardState();
}

class _DietClientCardState extends State<DietClientCard> {
  CreateDietPlanModel dietPlanModel = CreateDietPlanModel();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(34),
      ),
      shadowColor: const Color(0xFF000029),
      child: SizedBox(
        child: InkWell(
          borderRadius: BorderRadius.circular(34),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ExpertDietMealPlans(
                      isAssignPlan: false,
                      title: dietPlanModel.name!,
                      createDietPlanModel: dietPlanModel,
                    )));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFff7f3f),
                        radius: 51,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 48,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: widget.imageUrl.isEmpty
                                ? const AssetImage(
                                    "assets/icons/user.png",
                                  ) as ImageProvider
                                : NetworkImage(
                                    widget.imageUrl,
                                  ),
                            radius: 45,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.only(left: 16),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.patientName,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "patientEmail",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Intermediate",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Level",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        Text(
                          "Weight Loss",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Level",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        Text(
                          "Intermediate",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Active",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
