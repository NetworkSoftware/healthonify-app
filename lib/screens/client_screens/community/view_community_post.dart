import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/community/community_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/community_provider/community_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ViewCommunityPost extends StatefulWidget {
  final CommunityModel communityData;
  final Function likeAction;
  final Function dislikeAction;
  final int likeCount;
  final bool isLikedActiveState;

  const ViewCommunityPost(
      {required this.communityData,
      required this.likeAction,
      required this.dislikeAction,
      required this.likeCount,
      required this.isLikedActiveState,
      Key? key})
      : super(key: key);

  @override
  State<ViewCommunityPost> createState() => _ViewCommunityPostState();
}

class _ViewCommunityPostState extends State<ViewCommunityPost> {
  bool isLoading = false;

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

  int likeCount = 0;
  int commentsCount = 0;

  List<Comments> commentsData = [];

  Future<void> getLikesAndComments() async {
    setState(() {
      isLoading = true;
    });

    try {
      commentsData =
          await Provider.of<CommunityProvider>(context, listen: false)
              .getLikesAndComments(widget.communityData.id!);
      log('likes and comments fetched');
    } on HttpException catch (e) {
      log("Unable to fetch comments$e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error load comments $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> postComment() async {
    var userData = Provider.of<UserData>(context, listen: false).userData;
    Comments data = Comments(
      commentBy: {
        "firstName": userData.firstName,
        "lastName": userData.lastName,
        // "name": userData.firstName! + " " + userData.lastName!,
        "imageUrl": userData.imageUrl
      },
      comment: enteredComment,
      postId: widget.communityData.id,
    );
    try {
      setState(() {
        commentsData.add(data);
        log("hey");
      });
      FocusManager.instance.primaryFocus?.unfocus();
      commentsController.clear();

      await Provider.of<CommunityProvider>(context, listen: false).postComment({
        "commentBy": Provider.of<UserData>(context, listen: false).userData.id,
        "postId": widget.communityData.id,
        "comment": enteredComment,
      });
      // Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Comment added successfully');
    } on HttpException catch (e) {
      log("Unable to post comment$e");
      Fluttertoast.showToast(msg: "Unable to add comment");
      setState(() {
        commentsData.remove(data);
      });
    } catch (e) {
      log("Error add comment $e");
      Fluttertoast.showToast(msg: "Unable to add comment");
      setState(() {
        commentsData.remove(data);
      });
    }
  }

  void onSubmit() {
    postComment();
  }

  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    getLikesAndComments();
    isActive = widget.isLikedActiveState;
    likeCount = widget.likeCount;
    commentsCount = int.parse(widget.communityData.commentsCount!);
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
      Uri.parse(widget.communityData.mediaLink!),
    ));
  }

  TextEditingController commentsController = TextEditingController();
  String enteredComment = "";

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: ''),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
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
              widget.communityData.format == "externalLink"
                  ? YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(
                            widget.communityData.mediaLink!)!,
                        flags: const YoutubePlayerFlags(
                          mute: false,
                          autoPlay: true,
                          disableDragSeek: false,
                          loop: false,
                          isLive: false,
                          forceHD: false,
                          enableCaption: true,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.red,
                      progressColors: const ProgressBarColors(
                          playedColor: Colors.red,
                          handleColor: Colors.redAccent),
                    )
                  : widget.communityData.format == "video"
                      ? FlickVideoPlayer(flickManager: flickManager)
                      : widget.communityData.format == "image"
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: double.infinity,
                              child: CachedNetworkImage(
                                imageUrl: widget.communityData.mediaLink!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const SizedBox(),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: !isActive ? unlikedIcon : likedIcon,
                      onPressed: () async {
                        if (isActive == false) {
                          widget.likeAction();
                          setState(() {
                            likeCount += 1;
                          });
                        } else {
                          widget.dislikeAction();
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
                      // '1234',
                      '$likeCount likes',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    // const SizedBox(width: 25),
                    // IconButton(
                    //   icon: const Icon(
                    //     Icons.maps_ugc_rounded,
                    //     size: 30,
                    //   ),
                    //   onPressed: () {
                    //     Navigator.of(context, /*rootnavigator: true*/)
                    //         .push(_createRoute());
                    //   },
                    //   splashRadius: 20,
                    // ),
                    // Text(
                    //   // '1234',
                    //   widget.communityData.commentsCount!,
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.communityData.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 10),
              // const Divider(color: grey, indent: 10, endIndent: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(
                  'Comments',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String firstName =
                            commentsData[index].commentBy!["firstName"] ?? "";
                        String lastName =
                            commentsData[index].commentBy!["lastName"] ?? "";
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: commentsData[index]
                                                .commentBy!["imageUrl"] ==
                                            null ||
                                        commentsData[index]
                                            .commentBy!["imageUrl"]
                                            .isEmpty
                                    ? const CachedNetworkImageProvider(
                                        'https://cdn-icons-png.flaticon.com/512/3177/3177440.png')
                                    : CachedNetworkImageProvider(
                                        commentsData[index]
                                            .commentBy!["imageUrl"],
                                      ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("$firstName $lastName",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                    const SizedBox(height: 4),
                                    Text(
                                      commentsData[index].comment!,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      // separatorBuilder: (context, index) {
                      //   return const Divider();
                      // },
                      itemCount: commentsData.length,
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 95,
          color: Theme.of(context).canvasColor,
          child: TextFormField(
            controller: commentsController,
            onChanged: (value) {
              setState(() {
                enteredComment = value;
              });
            },
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: enteredComment.isEmpty
                    ? () {
                        Fluttertoast.showToast(msg: 'Please enter a comment');
                        return;
                      }
                    : () {
                        onSubmit();
                        log('entered comment -> $enteredComment');
                        // getLikesAndComments();
                      },
                child: Container(
                  width: 70,
                  alignment: Alignment.center,
                  child: Text(
                    "Post",
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: orange),
                  ),
                ),
              ),
              hintText: "Add comment...",
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.teal,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.teal),
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.teal),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

// Route _createRoute() {
//   return PageRouteBuilder(
//     transitionDuration: const Duration(milliseconds: 500),
//     pageBuilder: (context, animation, secondaryAnimation) => CommentsScreen(
//       data: widget.communityData,
//     ),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 1.0);
//       const end = Offset.zero;
//       const curve = Curves.ease;

//       var tween =
//           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }
}
