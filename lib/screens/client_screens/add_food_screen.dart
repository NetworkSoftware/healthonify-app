import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/func/search_food.dart';
import 'package:healthonify_mobile/models/wm/dish_model.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/search_bar.dart';
import 'package:healthonify_mobile/widgets/wm/food_details_btmsheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  String query = "";
  bool isLoading = false;
  List<Dishes> data = [];
  bool flag = false;
  int currentPage = 0;

  final RefreshController _refreshController = RefreshController();
  var snackBar = const SnackBar(
    content: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Text('No more dishes!'),
    ),
    duration: Duration(milliseconds: 1000),
  );

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }

  void getquery(String value) async {
    query = value;
    try {
      var resultData = await SearchFood.searchFoodData(context, query, 0);
      data = resultData;
      log("food data $data");
      currentPage = 1;
      setState(() {});
    } catch (e) {
      log("Error fetch food $e");
    } finally {
      setState(() {});
    }
  }

  Future<bool> searchFood(
    bool firstTime, {
    bool isRefresh = false,
  }) async {
    // String q = query;

    if (isRefresh) {
      flag = false;
      currentPage = 0;
    }
    log("curent page $currentPage");

    try {
      var resultData =
          await SearchFood.searchFoodData(context, query, currentPage);
      if (isRefresh) {
        data = resultData;
        currentPage = 1;
        setState(() {});
        return true;
      }
      if (resultData.length != 10) {
        if (currentPage == 0 && !firstTime) {
          data = resultData;
          _refreshController.loadNoData();
          showSnackBar.call();
          currentPage = currentPage + 1;
          return true;
        } else {
          data.addAll(resultData);
        }
      } else {
        data.addAll(resultData);
      }
      currentPage = currentPage + 1;
      setState(() {});
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "No food available");
      return false;
    }
  }

  void getData({bool firstTime = false}) async {
    setState(() {
      isLoading = true;
    });
    await searchFood(firstTime);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    //added the pagination function with listener
    getData(firstTime: true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("hey");
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SmartRefresher(
              controller: _refreshController,
              enablePullUp: true,
              footer: footer,
              onRefresh: () async {
                final result = await searchFood(false, isRefresh: true);
                if (result) {
                  _refreshController.refreshCompleted();
                } else {
                  _refreshController.refreshFailed();
                }
              },
              onLoading: () async {
                final result = await searchFood(false, isRefresh: false);
                if (result) {
                  _refreshController.loadComplete();
                } else {
                  _refreshController.loadFailed();
                }
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    CustomSearchBar(getValue: getquery),
                    Padding(
                      padding: const EdgeInsets.only(left: 14, top: 14),
                      child: Text(
                        '',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    data.isEmpty
                        ? const Center(
                            child: Text("No dishes available"),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding: const EdgeInsets.only(
                                    bottom: 15, left: 20, right: 20, top: 5),
                                onTap: () {
                                  showBtmSheet(context, index);
                                },
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 9,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (data[index].name) ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          Text(
                                            "Calories: ${data[index].perUnit!.calories}kcal  /  Quantity: ${data[index].perUnit!.weight}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          )
                                        ],
                                      ),
                                    ),
                                    const Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.add_rounded,
                                        color: Color(0xFFff7f3f),
                                      ),
                                    ),
                                  ],
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

  void showBtmSheet(context, index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FoodDetailsBtmSheet(foodData: data[index]);
      },
    );
  }

  CustomFooter footer = CustomFooter(
    builder: (context, mode) {
      Widget? body;
      if (mode == LoadStatus.idle) {
        body = const Text("");
      } else if (mode == LoadStatus.loading) {
        body = const CupertinoActivityIndicator(
          color: Colors.white,
        );
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
