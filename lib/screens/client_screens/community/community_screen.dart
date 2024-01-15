import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/community/community_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/community_provider/community_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/community/add_new_post.dart';
import 'package:healthonify_mobile/screens/client_screens/community/comments_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/community/my_community_posts.dart';
import 'package:healthonify_mobile/screens/client_screens/community/view_community_post.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widgets/buttons/custom_buttons.dart';
import '../../../widgets/cards/custom_appbar.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  int currentPage = 0;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    getData(firstTime: true);
  }

  bool isLoading = false;

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      snackBar,
    );
  }

  void getData({bool firstTime = false}) async {
    setState(() {
      isLoading = true;
    });
    await getCommunityPosts(context, firstTime);
    setState(() {
      isLoading = false;
    });
  }

  var userData;
  List<CommunityModel> data = [];
  var snackBar = const SnackBar(
    content: Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Text('No more community posts!'),
    ),
    duration: Duration(milliseconds: 1000),
  );

  Future<bool> getCommunityPosts(
    BuildContext context,
    bool firstTime, {
    bool isRefresh = false,
  }) async {
    if (isRefresh) {
      currentPage = 0;
    }
    log(currentPage.toString());

    try {
      userData = Provider.of<UserData>(context, listen: false).userData;
      String userId = userData.id;
      var resultData =
          await Provider.of<CommunityProvider>(context, listen: false)
              .getCommunityPosts(userId, currentPage.toString(),
                  'userId=$userId&page=$currentPage&limit=10');

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
          showSnackBar();
          currentPage = currentPage + 1;
          return true;
        } else {
          data.addAll(resultData);
        }
      } else {
        data.addAll(resultData);
      }
      log("outside");
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
        body = const Text("No more community posts");
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
      appBar: AppBar(
        title: Text(
          "Community",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: whiteColor),
        ),
        shadowColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(
                context, /*rootnavigator: true*/
              ).push(MaterialPageRoute(builder: (context) {
                return const AddNewPostScreen();
              }));
            },
            child: Image.asset(
              "assets/images/new-post.webp",
              height: 30,
              width: 30,
              color: whiteColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20,left: 20),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(
                    context, /*rootnavigator: true*/
                  ).push(MaterialPageRoute(builder: (context) {
                    return const MyCommunityPosts();
                  }));
                },
                child: const Icon(
                  Icons.groups_outlined,
                  size: 30,
                  color: whiteColor,
                )),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SmartRefresher(
              physics: const BouncingScrollPhysics(),
              controller: _refreshController,
              enablePullUp: true,
              footer: footer,
              onRefresh: () async {
                final result =
                    await getCommunityPosts(context, false, isRefresh: true);
                if (result) {
                  _refreshController.refreshCompleted();
                } else {
                  _refreshController.refreshFailed();
                }
              },
              onLoading: () async {
                final result = await getCommunityPosts(
                  context,
                  false,
                );
                if (result) {
                  _refreshController.loadComplete();
                } else {
                  _refreshController.loadFailed();
                }
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Expanded(
                      //       child: GestureDetector(
                      //         onTap: () {
                      //           Navigator.of(
                      //             context, /*rootnavigator: true*/
                      //           ).push(MaterialPageRoute(builder: (context) {
                      //             return const AddNewPostScreen();
                      //           }));
                      //         },
                      //         child: Container(
                      //             decoration: BoxDecoration(
                      //               border: Border.all(
                      //                 color: Theme.of(context).canvasColor,
                      //               ),
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             child: Row(
                      //               children: [
                      //                 Icon(
                      //                   Icons.camera_alt_outlined,
                      //                   color: Theme.of(context)
                      //                       .colorScheme
                      //                       .onBackground,
                      //                   size: 26,
                      //                 ),
                      //                 const SizedBox(width: 5),
                      //                 Text(
                      //                   'Create Post',
                      //                   style: Theme.of(context)
                      //                       .textTheme
                      //                       .bodyMedium,
                      //                 ),
                      //               ],
                      //             )
                      //
                      //             //       ListTile(
                      //             //       tileColor: Theme.of(context).canvasColor,
                      //             //   shape: RoundedRectangleBorder(
                      //             //     borderRadius: BorderRadius.circular(10),
                      //             //   ),
                      //             //
                      //             //   leading: Icon(
                      //             //     Icons.camera_alt_outlined,
                      //             //     color: Theme
                      //             //         .of(context)
                      //             //         .colorScheme
                      //             //         .onBackground,
                      //             //     size: 26,
                      //             //   ),
                      //             //   title: Text(
                      //             //     'Create Post',
                      //             //     style: Theme
                      //             //         .of(context)
                      //             //         .textTheme
                      //             //         .bodyMedium,
                      //             //   ),
                      //             // ),
                      //             ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 10),
                      //     Expanded(
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           border: Border.all(
                      //             color: Colors.grey,
                      //           ),
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         child: ListTile(
                      //           tileColor: Theme.of(context).canvasColor,
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           onTap: () {
                      //             Navigator.of(
                      //               context, /*rootnavigator: true*/
                      //             ).push(MaterialPageRoute(builder: (context) {
                      //               return const MyCommunityPosts();
                      //             }));
                      //           },
                      //           leading: Icon(
                      //             Icons.groups_outlined,
                      //             color: Theme.of(context)
                      //                 .colorScheme
                      //                 .onBackground,
                      //             size: 26,
                      //           ),
                      //           title: Text(
                      //             'My Posts',
                      //             style: Theme.of(context).textTheme.bodyMedium,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      data.isNotEmpty
                          ? ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return CommunityPost(
                                  communityData: data[index],
                                );
                              },
                            )
                          : const Text('No Posts Available'),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class CommunityPost extends StatefulWidget {
  final CommunityModel communityData;

  const CommunityPost({required this.communityData, Key? key})
      : super(key: key);

  @override
  State<CommunityPost> createState() => _CommunityPostState();
}

class _CommunityPostState extends State<CommunityPost> {
  bool isActive = false;
  bool isLess = false;
  Icon likedIcon = Icon(
    Icons.favorite_rounded,
    size: 30,
    color: Colors.red[700],
  );
  Icon unlikedIcon = const Icon(
    Icons.favorite_outline_rounded,
    size: 30,
  );
  Color iconColor = whiteColor;

  String descp = "";
  String? initText;
  String? expandedText;
  bool textFlag = true;
  int likeCount = 0;
  int commentsCount = 0;

  @override
  void initState() {
    super.initState();

    isActive = widget.communityData.isLiked!;
    likeCount = int.parse(widget.communityData.likesCount!);
    commentsCount = int.parse(widget.communityData.commentsCount!);
    log("comments$commentsCount");
    descp = widget.communityData.description!;

    if (descp.length > 40) {
      initText = descp.substring(0, 40);
      expandedText = descp.substring(40, descp.length);
    } else {
      initText = descp;
      expandedText = "";
    }
  }

  void showPopup(BuildContext context, String userId) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Do you really want to report the post',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GradientButton(
                        title: 'Yes',
                        func: () async {
                          DateTime now = DateTime.now();
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(now).toString();
                          await report(
                            context,
                            {
                              "postId": widget.communityData.id!,
                              "flaggedBy": userId,
                              "flaggedDate": formattedDate
                            },
                          ).then((value) {
                            Navigator.pop(context);
                          });
                        },
                        gradient: orangeGradient,
                      ),
                      GradientButton(
                        title: 'No',
                        func: () {
                          Navigator.pop(context);
                        },
                        gradient: orangeGradient,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> likeCommunityPost(
      BuildContext context, Map<String, String> data) async {
    log(data.toString());
    try {
      await Provider.of<CommunityProvider>(context, listen: false)
          .likePost(data);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error in getting community  $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> report(BuildContext context, Map<String, String> data) async {
    log(data.toString());
    try {
      await Provider.of<CommunityProvider>(context, listen: false)
          .reportPost(data);
      Fluttertoast.showToast(msg: "Post reported");
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error in getting community  $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Card(
        elevation: 0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    backgroundImage: widget.communityData.userImage == null ||
                            widget.communityData.userImage!.isEmpty
                        ? const CachedNetworkImageProvider(
                            'https://cdn-icons-png.flaticon.com/512/3177/3177440.png')
                        : CachedNetworkImageProvider(
                            widget.communityData.userImage!,
                          ),
                    // NetworkImage(widget.communityData.userImage!),
                    radius: 22,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      '${widget.communityData.userFirstName!} ${widget.communityData.userLastName!}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(
                  context, /*rootnavigator: true*/
                ).push(MaterialPageRoute(builder: (context) {
                  return ViewCommunityPost(
                    isLikedActiveState: isActive,
                    communityData: widget.communityData,
                    likeCount: likeCount,
                    likeAction: () async {
                      likeCommunityPost(
                        context,
                        {
                          "postId": widget.communityData.id!,
                          "likedBy": userId,
                          "action": "like"
                        },
                      );

                      setState(() {
                        likeCount += 1;
                        isActive = !isActive;
                      });
                    },
                    dislikeAction: () async {
                      likeCommunityPost(
                        context,
                        {
                          "postId": widget.communityData.id!,
                          "likedBy": userId,
                          "action": "dislike"
                        },
                      );

                      setState(() {
                        likeCount -= 1;
                        isActive = !isActive;
                      });
                    },
                  );
                }));
              },
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFF030303),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: widget.communityData.mediaLink!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 80.0),
                          child: Image.asset(
                            "assets/images/play.png",
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: !isActive ? unlikedIcon : likedIcon,
                        onPressed: () async {
                          if (isActive == false) {
                            likeCommunityPost(
                              context,
                              {
                                "postId": widget.communityData.id!,
                                "likedBy": userId,
                                "action": "like"
                              },
                            );
                            setState(() {
                              likeCount += 1;
                            });
                          } else {
                            likeCommunityPost(
                              context,
                              {
                                "postId": widget.communityData.id!,
                                "likedBy": userId,
                                "action": "dislike"
                              },
                            );
                            setState(() {
                              likeCount -= 1;
                            });
                          }
                          setState(() {
                            isActive = !isActive;
                          });
                        },
                        splashRadius: 20,
                      ),
                      Text(
                        likeCount.toString(),
                        // widget.communityData.likesCount!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 25),
                      IconButton(
                        icon: const Icon(
                          Icons.maps_ugc_rounded,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.of(
                            context, /*rootnavigator: true*/
                          ).push(
                            _createRoute(),
                          );
                        },
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () async {
                        showPopup(context, userId);
                      },
                      icon: const Icon(
                        Icons.report_problem_outlined,
                        size: 30,
                      ))
                  // Text(
                  //   widget.communityData.commentsCount!,
                  //   style: Theme.of(context).textTheme.bodySmall,
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                textFlag
                                    ? (initText! +
                                        ((initText!.length > 38) ? "..." : ""))
                                    : (initText! + expandedText!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  descp.length > 40
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  textFlag = !textFlag;
                                });
                              },
                              child: Text(
                                textFlag ? "show more" : "show less",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => CommentsScreen(
        data: widget.communityData,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
