import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/physiotherapy/health_data.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/browse_physio_plans.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class PhysioConditionsScreen extends StatefulWidget {
  final bool? isFromExpertProfile;
  const PhysioConditionsScreen({Key? key, this.isFromExpertProfile})
      : super(key: key);

  @override
  State<PhysioConditionsScreen> createState() => _PhysioConditionsScreenState();
}

class _PhysioConditionsScreenState extends State<PhysioConditionsScreen> {
  Future<void> getHealthConditionsData(BuildContext context) async {
    try {
      await Provider.of<HealthData>(context, listen: false)
          .getHealthConditions();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error login auth widget $e");
      Fluttertoast.showToast(msg: "Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Health Conditions',
      ),
      body: FutureBuilder(
        future: getHealthConditionsData(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Consumer<HealthData>(
                      builder: ((context, data, child) => ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.healthConditions.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 14,
                                ),
                                child: Card(
                                  elevation: 0,
                                  child: InkWell(
                                    onTap: () {
                                      // widget.isFromExpertProfile == null
                                      //     ? Navigator.of(context).push(
                                      //         MaterialPageRoute(
                                      //           builder: (context) =>
                                      //               PackagesByHealth(
                                      //             data: {
                                      //               "healthCondition": data
                                      //                   .healthConditions[index]
                                      //                   .id!
                                      //             },
                                      //           ),
                                      //         ),
                                      //       )
                                      //     : () {};
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BrowsePhysioPlans(
                                               healthConditionId: data
                                                   .healthConditions[index]
                                                   .id!,
                                              ),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      height: 54,
                                      width: MediaQuery.of(context).size.width *
                                          0.98,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Image.asset(
                                              'assets/icons/body_parts.png',
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: Text(
                                              data.healthConditions[index]
                                                  .name!,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Padding(
                                            padding: EdgeInsets.only(right: 12),
                                            child: Icon(
                                              Icons.chevron_right_rounded,
                                              color: Colors.grey,
                                              size: 28,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
