import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/community/community_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/community_provider/community_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/community/community_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyCommunityPosts extends StatefulWidget {
  const MyCommunityPosts({Key? key}) : super(key: key);

  @override
  State<MyCommunityPosts> createState() => _MyCommunityPostsState();
}

class _MyCommunityPostsState extends State<MyCommunityPosts> {
  bool isLoading = true;
  List<CommunityModel> communityData = [];
  List<CommunityModel> data = [];

  int currentPage = 0;

  final RefreshController refreshController = RefreshController();

  var snackBar = const SnackBar(
    content: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Text('No more posts!'),
    ),
    duration: Duration(milliseconds: 1000),
  );

  @override
  void initState() {
    super.initState();
    getMyPosts(true);
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }

  Future<bool> getMyPosts(bool firstTime, {bool isRefresh = false}) async {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;

    if (isRefresh) {
      currentPage = 0;
    }

    try {
      var resultData = await Provider.of<CommunityProvider>(context,
              listen: false)
          .getCommunityPosts(userId, '0',
              'userId=$userId&page=$currentPage&limit=10&isApproved=true&filterByUserId=$userId');
      log('fetched my community posts');
      communityData = resultData;

      if (isRefresh) {
        data = resultData;
        currentPage = 1;
        setState(() {});
        return true;
      }

      if (resultData.length != 10) {
        if (currentPage == 0 && !firstTime) {
          data = resultData;
          refreshController.loadNoData();
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
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
      return false;
    } catch (e) {
      log("Error get community widget $e");
      Fluttertoast.showToast(msg: "Something went wrong");
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'My Community Posts'),
      body: SmartRefresher(
        physics: const BouncingScrollPhysics(),
        controller: refreshController,
        enablePullUp: true,
        footer: footer,
        onRefresh: () async {
          final result = await getMyPosts(false, isRefresh: true);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result = await getMyPosts(false);
          if (result) {
            refreshController.loadComplete();
          } else {
            refreshController.loadFailed();
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : communityData.isEmpty
                      ? Center(
                          child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.45),
                          child: Text(
                            'No Posts Available',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ))
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: communityData.length,
                          itemBuilder: (context, index) {
                            return CommunityPost(
                              communityData: communityData[index],
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
