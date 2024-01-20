import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/diet/diet_func.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/diet_plan_provider.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/add_diet_plan.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/recipies/recipes_screen.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/search_diet_plans.dart';
import 'package:healthonify_mobile/widgets/experts/dietplans/dietplan_card.dart';
import 'package:provider/provider.dart';

class MyDietPlans extends StatefulWidget {
  final bool isFromTopCard;
  final bool isFromClient;
  final String clientId;
  const MyDietPlans(
      {Key? key,
      this.isFromClient = false,
      this.clientId = "",
      this.isFromTopCard = false})
      : super(key: key);

  @override
  State<MyDietPlans> createState() => _MyDietPlansState();
}

class _MyDietPlansState extends State<MyDietPlans> {
  bool isLoading = false;

  List<DietPlan> dietPlans = [];

  Future<void> fetchDietPlan() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userData = Provider.of<UserData>(context, listen: false).userData;
      String roleTitle = "userId";
      if (userData.roles![0]["name"] == "client") {
        roleTitle = "userId";
      } else {
        roleTitle = "expertId";
      }

      if (widget.isFromTopCard) {
        dietPlans = await Provider.of<DietPlanProvider>(context, listen: false)
            .getUserDietPlans("?userId=${userData.id}");
        return;
      }

      dietPlans = await Provider.of<DietPlanProvider>(context, listen: false)
          .getDietPlans("?$roleTitle=${userData.id}");
      log('fetched diet plans');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting diet details $e");
      Fluttertoast.showToast(msg: "Unable to fetch diet plans");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteDietPlan(int index) async {
    var result = await DietFunc().deleteDietPlan(context, dietPlans[index].id!);
    if (result) {
      dietPlans.removeAt(index);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDietPlan();
    log(widget.isFromTopCard.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        pinned: true,
                        snap: false,
                        centerTitle: false,
                        backgroundColor: orange,
                        title: Text(
                          'My Diet Plans',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        leading: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                        iconTheme: Theme.of(context).iconTheme.copyWith(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color),
                        bottom: AppBar(
                          elevation: 0,
                          backgroundColor: orange,
                          automaticallyImplyLeading: false,
                          title: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const SearchDietPlansScreen();
                              }));
                            },
                            child: IgnorePointer(
                              child: SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 5),
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
                                      hintText: 'Search for diet plans',
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
                        ),
                      ),

                      // Other Sliver Widgets
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            dietPlans.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 30.0),
                                    child: Center(
                                      child: Text("No diet plans available"),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: dietPlans.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (_, index) => DietPlanCard(
                                        dietPlan: dietPlans[index],
                                        isFromClient: widget.isFromClient,
                                        isFromTopCard: widget.isFromTopCard,
                                        clientId: widget.clientId,
                                        deleteDietPlan: () {
                                          deleteDietPlan(index);
                                        }),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                !widget.isFromClient && !widget.isFromTopCard
                    ? Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        color: whiteColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          const RecipesScreen()),
                                    ),
                                  );
                                },
                                child: Container(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  // color: Colors.blue,
                                  child: Center(
                                    child: Text(
                                      "Recipies",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          const AddDietPlan()),
                                    ),
                                  )
                                      .then((value) {
                                    fetchDietPlan();
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  color: Theme.of(context).colorScheme.primary,
                                  child: Center(
                                    child: Text(
                                      "Add Diet Plan",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(color: whiteColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        color: whiteColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          const AddDietPlan()),
                                    ),
                                  )
                                      .then((value) {
                                    fetchDietPlan();
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  color: Theme.of(context).colorScheme.primary,
                                  child: Center(
                                    child: Text(
                                      "Add Diet Plan",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(color: whiteColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
              ],
            ),
    );
  }
}
