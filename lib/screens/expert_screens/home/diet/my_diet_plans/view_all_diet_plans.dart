import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/diet/diet_func.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/diet_plan_provider.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/experts/dietplans/dietplan_card.dart';
import 'package:provider/provider.dart';

class ViewAllDietPlans extends StatefulWidget {
  const ViewAllDietPlans({
    Key? key,
    required this.isFromClient,
    required this.isFromTopCard,
    this.clientId = "",
  }) : super(key: key);
  final bool isFromClient;
  final String clientId;
  final bool isFromTopCard;

  @override
  State<ViewAllDietPlans> createState() => _ViewAllDietPlansState();
}

class _ViewAllDietPlansState extends State<ViewAllDietPlans> {
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

  @override
  void initState() {
    super.initState();
    fetchDietPlan();
  }

  void deleteDietPlan(int index) async {
    var result = await DietFunc().deleteDietPlan(context, dietPlans[index].id!);
    if (result) {
      dietPlans.removeAt(index);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: "Diet Plans"),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
        shrinkWrap: true,
        itemCount: dietPlans.length,
        physics: const ScrollPhysics(),
        itemBuilder: (_, index) => DietPlanCard(
            dietPlan: dietPlans[index],
            isFromClient: widget.isFromClient,
            isFromTopCard: widget.isFromTopCard,
            clientId: widget.clientId,
            isFromMain: false,
            deleteDietPlan: () {
              deleteDietPlan(index);
            }),
      ),
    );
  }
}
