import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/health_care/health_care_plans/health_care_plans_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/manage_weight_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/health_care/ayurveda/browse_plans/widgets/hc_plan_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WmPackagesQuickActionsScreen extends StatefulWidget {
  const WmPackagesQuickActionsScreen({Key? key, this.expertiseId})
      : super(key: key);
  final String? expertiseId;

  @override
  State<WmPackagesQuickActionsScreen> createState() =>
      _WmPackagesQuickActionsScreenState();
}

class _WmPackagesQuickActionsScreenState
    extends State<WmPackagesQuickActionsScreen> {
  final bool _isLoading = false;
  final bool _flag = false;
  final RefreshController _refreshController = RefreshController();
  bool isloading = true;
  List<HealthCarePlansModel> healthCarePlans = [];

  Future<void> fetchHealthCarePlans() async {
    try {
      healthCarePlans =
          await Provider.of<ManageWeightPlansProvider>(context, listen: false)
              .getManageWeightPlans();
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
    fetchHealthCarePlans();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  // void getData({bool firstTime = false}) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   await getFunc(
  //     context,
  //     firstTime,
  //   );
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
  //
  // Future<bool> getFunc(
  //   BuildContext context,
  //   bool firstTime, {
  //   bool isRefresh = false,
  // }) async {
  //   if (isRefresh) {
  //     _flag = false;
  //     currentPage = 0;
  //   }
  //   log(currentPage.toString());
  //   // String expertId =
  //   //     Provider.of<UserData>(context, listen: false).userData.id!;
  //   try {
  //     var resultData = await Provider.of<WmPackagesData>(context, listen: false)
  //         .getAllPackages(currentPage.toString());
  //
  //     // log(resultData.length.toString());
  //
  //     if (isRefresh) {
  //       data = resultData;
  //       currentPage++;
  //       setState(() {});
  //       return true;
  //     }
  //     if (resultData.length < 20) {
  //       log("less than 20");
  //       if (_flag == false) {
  //         log("in");
  //         data.addAll(resultData);
  //       }
  //       _flag = true;
  //       _refreshController.loadNoData();
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   snackBar,
  //       // );
  //       setState(() {});
  //       return true;
  //     }
  //     log("normal ");
  //
  //     data.addAll(resultData);
  //
  //     // if (resultData.length != 20) {
  //     //   if (currentPage == 0 && !firstTime) {
  //     //     data = resultData;
  //     //     _refreshController.loadNoData();
  //     //     ScaffoldMessenger.of(context).showSnackBar(
  //     //       snackBar,
  //     //     );
  //     //     return true;
  //     //   } else {
  //     //     log("hey");
  //     //     data.addAll(resultData);
  //     //   }
  //     // } else {
  //     //   data.addAll(resultData);
  //     // }
  //
  //     currentPage = currentPage + 1;
  //     setState(() {});
  //     return true;
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //     // Fluttertoast.showToast(msg: "Unable to get packages");
  //     return false;
  //   } catch (e) {
  //     log("Error get sessions $e");
  //     // Fluttertoast.showToast(msg: "Unable to get packages");
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // User userData = Provider.of<UserData>(context, listen: false).userData;
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'View Manage Weight Plans'),
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
                                healthCarePlansModel: healthCarePlans[index],
                                planName: "manageWeight",
                              ),
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

  CustomFooter footer = CustomFooter(
    builder: (context, mode) {
      Widget? body;
      if (mode == LoadStatus.idle) {
        body = const Text("");
      } else if (mode == LoadStatus.loading) {
        body = const CupertinoActivityIndicator();
      } else if (mode == LoadStatus.failed) {
        body = const Text("Load Failed!Click retry!");
      } else if (mode == LoadStatus.canLoading) {
        body = const Text("Release to load more");
      } else if (mode == LoadStatus.noMore) {
        body = const Text("No more Appointments");
      } else {
        body = const Text("No more Data");
      }
      return SizedBox(
        height: 55.0,
        child: Center(child: body),
      );
    },
  );
}
