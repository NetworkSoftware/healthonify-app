import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/exercise/exercise.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/exercises/exercises_data.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/expert_exer_details_card.dart';
import 'package:provider/provider.dart';

class ListExerciseWidget extends StatefulWidget {
  final String title;
  final String userWeight;
  const ListExerciseWidget({
    super.key,
    required this.title,
    required this.userWeight,
  });

  @override
  State<ListExerciseWidget> createState() => _ListExerciseWidgetState();
}

class _ListExerciseWidgetState extends State<ListExerciseWidget> {
  final RefreshController refreshController = RefreshController();
  bool isLoading = true;
  List<Exercise> exData = [];
  int currentPage = 0;
  var snackBar = const SnackBar(
    content: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Text('No more posts!'),
    ),
    duration: Duration(milliseconds: 1000),
  );

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }

  Future<bool> fetchExercises(
    bool firstTime, {
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentPage = 0;
    }
    try {
      String title = "";
      if (widget.title == "Cardiovascular") {
        title = "CardioVascular";
      } else if (widget.title == "Strength") {
        title = "Strength";
      } else {
        title = "General Activity";
      }
      var resultData = await Provider.of<ExercisesData>(context, listen: false)
          .fetchExercises(data: "exerciseType=$title");

      if (isRefresh) {
        exData = resultData;
        currentPage = 1;
        setState(() {});
        return true;
      }

      if (resultData.length != 10) {
        if (currentPage == 0 && !firstTime) {
          exData = resultData;
          refreshController.loadNoData();
          showSnackBar.call();
          currentPage = currentPage + 1;
          return true;
        } else {
          exData.addAll(resultData);
        }
      } else {
        exData.addAll(resultData);
      }
      currentPage = currentPage + 1;
      setState(() {});
      return true;
    } on HttpException catch (e) {
      log("error in  exercise screen $e");
      Fluttertoast.showToast(msg: 'Something went wrong');
      return false;
    } catch (e) {
      log("error in  exercise screen $e");
      Fluttertoast.showToast(msg: 'Something went wrong');
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchExercises(
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : exData.isEmpty
            ? const Center(child: Text("No exercises found"))
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SmartRefresher(
                  physics: const BouncingScrollPhysics(),
                  controller: refreshController,
                  enablePullUp: true,
                  footer: footer,
                  onRefresh: () async {
                    final result = await fetchExercises(false, isRefresh: true);
                    if (result) {
                      refreshController.refreshCompleted();
                    } else {
                      refreshController.refreshFailed();
                    }
                  },
                  onLoading: () async {
                    final result = await fetchExercises(false);
                    if (result) {
                      refreshController.loadComplete();
                    } else {
                      refreshController.loadFailed();
                    }
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: exData.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) => ExerciseDetailsCard(
                      exData: exData[index],
                      isSelectEx: false,
                      isImagePresentAndClickable: false,
                      userWeight : widget.userWeight ,
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
        body = const Text("No more posts");
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
