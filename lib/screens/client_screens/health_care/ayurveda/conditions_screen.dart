import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/health_care/ayurveda_models/ayurveda_plans_model.dart';
import 'package:healthonify_mobile/models/health_care/health_care_plans/health_care_plans_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_plans/health_care_plans_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/browse_plans/widgets/hc_plan_card.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/buy_ayurveda_plan.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class AyurvedaConditionsScreen extends StatefulWidget {
  final String? condition;
  final String? conditionId;
  final String ayurvedaId;
  const AyurvedaConditionsScreen(
      {required this.condition, required this.conditionId, required this.ayurvedaId,Key? key})
      : super(key: key);

  @override
  State<AyurvedaConditionsScreen> createState() => _AyurvedaConditionsScreenState();
}

class _AyurvedaConditionsScreenState extends State<AyurvedaConditionsScreen> {
  List<AyurvedaPlansModel> ayurvedaConditions = [];

  bool isloading = true;
  List<HealthCarePlansModel> healthCarePlans = [];

  Future<void> fetchAyurvedaConditions() async {
    try {
      healthCarePlans =
      await Provider.of<HealthCarePlansProvider>(context, listen: false)
          .getAyurvedaConditionPlans(ayurvedaId: widget.ayurvedaId, conditionId: widget.conditionId!);
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching plans');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  // Future<void> fetchAyurvedaConditions(BuildContext context) async {
  //   try {
  //     ayurvedaConditions =
  //         await Provider.of<AyurvedaProvider>(context, listen: false)
  //             .getAyurvedaPlans("?conditionId=${widget.conditionId}");
  //
  //     log('fetched ayurveda conditions');
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //   } catch (e) {
  //     log('Error fetching ayurveda conditions');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    fetchAyurvedaConditions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: "${widget.condition}"),
      body: isloading
          ? const Center(child: CircularProgressIndicator()) :
      healthCarePlans.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Select Services',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: healthCarePlans.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Card(
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(10),
                        child: HcPlanCard(
                            healthCarePlansModel:
                            healthCarePlans[index]),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      )
          : const Center(
        child: Text("No packages available"),
      ),


      // FutureBuilder(
      //     future: fetchAyurvedaConditions(),
      //     builder: (context, snapshot) =>
      //         snapshot.connectionState == ConnectionState.waiting
      //             ? const Center(
      //                 child: CircularProgressIndicator(),
      //               )
      //             : plansList(context)),
    );
  }

  Widget plansList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        healthCarePlans.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("No plans available"),
                ),
              )
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: healthCarePlans.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${ayurvedaConditions[index].name}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BuyAyurvedaPlan(
                            plan: ayurvedaConditions[index],
                          );
                        }));
                      },
                      child: Text(
                        'View Plan',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(color: Colors.grey);
                },
              ),
        const SizedBox(height: 20),
      ],
    );
  }
}
