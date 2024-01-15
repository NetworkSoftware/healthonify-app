import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/community/community_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/community_provider/community_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final CommunityModel data;
  const CommentsScreen({required this.data, Key? key}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  bool isLoading = true;
  TextEditingController commentController = TextEditingController();

  String enteredComment = "";
  List<Comments> commentsData = [];

  Future<void> getLikesAndComments() async {
    try {
      commentsData =
          await Provider.of<CommunityProvider>(context, listen: false)
              .getLikesAndComments(widget.data.id!);
      log('comments fetched');
    } on HttpException catch (e) {
      log("Unable to fetch comments$e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error load comments $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
    setState(() {
      isLoading = false;
    });
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
      postId: widget.data.id,
    );
    try {
      setState(() {
        commentsData.add(data);
      });
      FocusManager.instance.primaryFocus?.unfocus();
      commentController.clear();
      await Provider.of<CommunityProvider>(context, listen: false).postComment({
        "commentBy": Provider.of<UserData>(context, listen: false).userData.id,
        "postId": widget.data.id,
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
    // log(enteredComment);
    postComment();
  }

  @override
  void initState() {
    super.initState();
    getLikesAndComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Comments'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const Divider(
                          thickness: 1,
                        ),
                        commentsData.isEmpty
                            ? const Center(
                                child: Text("Add a comment"),
                              )
                            : ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: commentsData.length,
                                itemBuilder: (context, index) {
                                  String firstName = commentsData[index]
                                          .commentBy!["firstName"] ??
                                      "";
                                  String lastName = commentsData[index]
                                          .commentBy!["lastName"] ??
                                      "";

                                  return comments(
                                      "$firstName $lastName",
                                      commentsData[index].comment!,
                                      commentsData[index]
                                          .commentBy!["imageUrl"]);
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  indent: 16,
                                  endIndent: 16,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  height: 95,
                  color: Colors.white.withOpacity(0.1),
                  child: TextFormField(
                    controller: commentController,
                    onChanged: (value) {
                      setState(() {
                        enteredComment = value;
                      });
                    },
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: enteredComment.isEmpty
                            ? () {}
                            : () {
                                onSubmit();
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
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
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
              ],
            ),
    );
  }

  Widget comments(String name, String comment, String? url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 20,
            backgroundImage: url == null || url.isEmpty
                ? const CachedNetworkImageProvider(
                    'https://cdn-icons-png.flaticon.com/512/3177/3177440.png')
                : CachedNetworkImageProvider(url),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(
                  comment,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
