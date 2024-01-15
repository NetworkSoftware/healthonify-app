import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/health_care/health_care_plans/health_care_plans_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_plans/health_care_plans_provider.dart';


import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

import 'widgets/hc_plan_card.dart';

class BrowseHealthCarePlans extends StatefulWidget {
  BrowseHealthCarePlans({Key? key,this.isFree}) : super(key: key);

  bool? isFree;
  @override
  State<BrowseHealthCarePlans> createState() => _BrowseHealthCarePlansState();
}

class _BrowseHealthCarePlansState extends State<BrowseHealthCarePlans> {
  bool isloading = true;
  List<HealthCarePlansModel> healthCarePlans = [];

  Future<void> fetchHealthCarePlans() async {
    try {
      healthCarePlans =
          await Provider.of<HealthCarePlansProvider>(context, listen: false)
              .getHealthCarePlans();
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

  Future<void> getHealthCareFreePlans() async {
    try {
      healthCarePlans =
      await Provider.of<HealthCarePlansProvider>(context, listen: false)
          .getHealthCareFreePlans();
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

  @override
  void initState() {
    super.initState();
    if(widget.isFree == true){
      getHealthCareFreePlans();
    }else{
      fetchHealthCarePlans();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'View Health Care Plans'),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                                  healthCarePlansModel: healthCarePlans[index],planName: "healthCare",),
                            ),
                          ),
                        );
                      },

                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
