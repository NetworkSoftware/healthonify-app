import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/exercise/exercise.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/exercises/exercises_data.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/expert_exer_details_card.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ExpertExercisesScreen extends StatefulWidget {
  final bool isConditions;
  final String bodyPartId;
  final bool isSelectEx;

  const ExpertExercisesScreen(
      {Key? key,
      this.isConditions = false,
      this.bodyPartId = "",
      this.isSelectEx = false})
      : super(key: key);

  @override
  State<ExpertExercisesScreen> createState() => _ExpertExercisesScreenState();
}

class _ExpertExercisesScreenState extends State<ExpertExercisesScreen> {
  String query = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  List<Exercise> exData = [];
  int currentPage = 0;
  final RefreshController refreshController = RefreshController();
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

  @override
  void initState() {
    super.initState();
    fetchExercises(
      true,
    );
  }

  Future<bool> fetchExercises(
    bool firstTime, {
    bool isRefresh = false,
  }) async {
    String q = query;

    if (isRefresh) {
      currentPage = 0;
    }
    try {
      var resultData = await Provider.of<ExercisesData>(context, listen: false)
          .searchExercise(
              bodyPartId: widget.bodyPartId,
              page: currentPage.toString(),
              query: q);

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
      log(e.toString());
      Fluttertoast.showToast(msg: 'Something went wrong');
      return false;
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Something went wrong');
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //enable this for filters and another commented code below
      // endDrawer: Drawer(
      //   child: ExFiltersDrawer(isConditions: widget.isConditions),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            title: Text(
              'Exercises',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            iconTheme: Theme.of(context)
                .iconTheme
                .copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
            actions: const [Text("")],
            bottom: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              automaticallyImplyLeading: false,
              title: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 5),
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
                      hintText: 'Search for exercises',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: whiteColor),
                      suffixIcon: const Icon(
                        Icons.search,
                        color: whiteColor,
                      ),
                    ),
                    onChanged: (value) {
                      query = value;
                      fetchExercises(
                        false,
                        isRefresh: true,
                      );
                    },
                  ),
                ),
              ),
              //enable this for filters and another commented code above
              // actions: [

              // IconButton(
              //   onPressed: () {
              //     _scaffoldKey.currentState!.openEndDrawer();
              //   },
              //   icon: const Icon(Icons.filter_alt),
              //   splashRadius: 20,
              // )
              // ],
            ),
          ),
          // Other Sliver Widgets
          SliverList(
            delegate: SliverChildListDelegate(
              [
                isLoading
                    ? const Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : exData.isEmpty
                        ? const Center(child: Text("No exercises found"))
                        : Container(
                            height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.only(bottom: 120),
                            child: SmartRefresher(
                              physics: const BouncingScrollPhysics(),
                              controller: refreshController,
                              enablePullUp: true,
                              footer: footer,
                              onRefresh: () async {
                                final result = await fetchExercises(false,
                                    isRefresh: true);
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
                                  isSelectEx: widget.isSelectEx,
                                ),
                              ),
                            ),
                          ),
              ],
            ),
          ),
        ],
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
