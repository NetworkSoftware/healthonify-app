import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/models/wm/wm_package.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_packages.dart';
import 'package:healthonify_mobile/screens/expert_screens/appointments/wm/packages/expert_create_wm_packages.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/experts/expert_wm_packages_card.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WmPackagesExpertScreen extends StatefulWidget {
  final String userIdToAssign;
  final String consultationId;
  const WmPackagesExpertScreen({
    required this.userIdToAssign,
    required this.consultationId,
    Key? key,
  }) : super(key: key);

  @override
  State<WmPackagesExpertScreen> createState() => _WmPackagesExpertScreenState();
}

class _WmPackagesExpertScreenState extends State<WmPackagesExpertScreen> {
  bool _isLoading = false;
  bool _flag = false;
  final RefreshController _refreshController = RefreshController();
  var snackBar = const SnackBar(
    content: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Text('No more Appointments!'),
    ),
    duration: Duration(milliseconds: 1000),
  );
  int currentPage = 0;
  List<WmPackage> data = [];

  @override
  void initState() {
    //added the pagination function with listener
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    await getFunc(
      context,
    );
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> getFunc(
    BuildContext context, {
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      _flag = false;
      currentPage = 0;
    }
    log(currentPage.toString());
    // String expertId =
    //     Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      var resultData = await Provider.of<WmPackagesData>(context, listen: false)
          .getAllPackages(currentPage.toString());

      // log(resultData.length.toString());

      if (isRefresh) {
        data = resultData;
        currentPage++;
        setState(() {});
        return true;
      }
      if (resultData.length < 20) {
        log("less than 20");
        if (_flag == false) {
          log("in");
          data.addAll(resultData);
        }
        _flag = true;
        _refreshController.loadNoData();
        // ScaffoldMessenger.of(context).showSnackBar(
        //   snackBar,
        // );
        setState(() {});
        return true;
      }
      log("normal ");

      data.addAll(resultData);

      // if (resultData.length != 20) {
      //   if (currentPage == 0 && !firstTime) {
      //     data = resultData;
      //     _refreshController.loadNoData();
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       snackBar,
      //     );
      //     return true;
      //   } else {
      //     log("hey");
      //     data.addAll(resultData);
      //   }
      // } else {
      //   data.addAll(resultData);
      // }

      currentPage = currentPage + 1;
      setState(() {});
      return true;
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: "Unable to get packages");
      return false;
    } catch (e) {
      log("Error get sessions $e");
      // Fluttertoast.showToast(msg: "Unable to get packages");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    User userData = Provider.of<UserData>(context, listen: false).userData;
    return Scaffold(
      appBar: CustomAddPackageAppBar(
        appBarTitle: 'Packages',
        onSubmit: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const ExpertCreateWMPackage();
          }));
        },
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : data.isEmpty
              ? const Center(
                  child: Text("No packages available, please create a package"),
                )
              : SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: true,
                  footer: footer,
                  onRefresh: () async {
                    final result = await getFunc(context, isRefresh: true);
                    if (result) {
                      _refreshController.refreshCompleted();
                    } else {
                      _refreshController.refreshFailed();
                    }
                  },
                  onLoading: () async {
                    final result = await getFunc(
                      context,
                    );
                    if (result) {
                      _refreshController.loadComplete();
                    } else {
                      _refreshController.loadFailed();
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return ExpertWmPackagesCard(
                              consultationId: widget.consultationId,
                              data: data[index],
                              expertData: userData,
                              userIdToAssign: widget.userIdToAssign,
                            );
                          },
                          scrollDirection: Axis.vertical,
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
