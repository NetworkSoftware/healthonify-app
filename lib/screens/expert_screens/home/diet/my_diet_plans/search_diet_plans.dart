import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/diet_plans/search_diet_plans_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/weight_management/diet_plan_provider.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class SearchDietPlansScreen extends StatefulWidget {
  const SearchDietPlansScreen({super.key});

  @override
  State<SearchDietPlansScreen> createState() => _SearchDietPlansScreenState();
}

class _SearchDietPlansScreenState extends State<SearchDietPlansScreen> {
  bool isLoading = false;
  List<SearchDietPlanModel> dietPlans = [];

  Future<void> searchDietPlan() async {
    setState(() {
      isLoading = true;
    });
    try {
      dietPlans = await Provider.of<DietPlanProvider>(context, listen: false)
          .searchDietPlans(searchDiet ?? "");
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

  @override
  void initState() {
    super.initState();

    searchDietPlan();
  }

  String? searchDiet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Search Diet Plans'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  setState(() {
                    searchDiet = value;
                    searchDietPlan();
                  });
                },
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.black87,
                    ),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF717579),
                  ),
                  constraints: const BoxConstraints(
                    maxHeight: 56,
                  ),
                  fillColor: const Color(0xFFE3E3E3),
                  filled: true,
                  hintText: 'Search diet plans',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF717579),
                    fontFamily: 'OpenSans',
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFFE3E3E3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFFE3E3E3),
                    ),
                  ),
                ),
              ),
            ),
            dietPlans.isEmpty
                ? const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
                    child: Center(
                      child: Text("No diet plans available"),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: dietPlans.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      String created = DateFormat('d MMM yy')
                          .format(dietPlans[index].createdAt!);
                      String createdTime = DateFormat('h:mm a')
                          .format(dietPlans[index].createdAt!);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15),
                        child: Card(
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${dietPlans[index].name}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Created : $created at $createdTime",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${dietPlans[index].level}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${dietPlans[index].goal}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "636.5 kcal (should do calc)",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${dietPlans[index].validity}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge,
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
                    })
          ],
        ),
      ),
    );
  }
}
