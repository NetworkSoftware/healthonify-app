import 'dart:developer';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/challenges_models/challenges_models.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/challenges_providers/challenges_provider.dart';
import 'package:healthonify_mobile/providers/live_well_providers/live_well_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String videoTitle;
  final String videoLink;
  final String description;
  final String videoId;
  final String playlistId;

  const VideoScreen({
    Key? key,
    required this.playlistId,
    required this.videoId,
    required this.videoTitle,
    required this.description,
    required this.videoLink,
  }) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool isLoading = true;
  late BetterPlayerController _betterPlayerController;

  List<JoinedChallenges> joinedChallenges = [];

  Future<void> fetchJoinedChallenges() async {
    try {
      joinedChallenges =
          await Provider.of<ChallengesProvider>(context, listen: false)
              .getJoinedChallenges(userId);

      log('${joinedChallenges[0].name}');
      log('fetched all joined challenges');
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching joined challenges');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> updateMeditationMap = {};
  bool isloading = true;

  Future<void> updateChallengeActivity() async {
    try {
      await Provider.of<LiveWellProvider>(context, listen: false)
          .updateMeditationChallenge(updateMeditationMap);
      // popFunction();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to update challenge activity');
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void popFunction() {
    Navigator.pop(context);
  }

  late String userId;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;

    print("VideoLink : ${widget.videoLink}");
    fetchJoinedChallenges();

    // BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource.network(
    //   widget.videoLink
    // );
    // _betterPlayerController = BetterPlayerController(
    //   const BetterPlayerConfiguration(
    //     aspectRatio: 16 / 9,
    //     autoPlay: true,
    //     autoDetectFullscreenAspectRatio: true,
    //   ),
    //   betterPlayerDataSource: betterPlayerDataSource,
    // );
    // _betterPlayerController.addEventsListener((event) {
    //   if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
    //     log('video finished');
    //     for (var ele in joinedChallenges) {
    //       if (ele.name == 'Meditation challenge') {
    //         updateMeditationMap['userId'] = userId;
    //         updateMeditationMap['fitnessChallengeId'] = ele.fitnessChallengeId;
    //         updateMeditationMap['challengeCategoryId'] =
    //             ele.challengeCategoryId;
    //         updateMeditationMap['meditationActivity'] = {
    //           "playlistId": widget.playlistId,
    //           "contents": {
    //             "contentId": widget.videoId,
    //             "status": "completed",
    //           },
    //         };
    //         // log(updateMeditationMap.toString());
    //         updateChallengeActivity();
    //         break;
    //       }
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BetterPlayer(
                  //   controller: _betterPlayerController,
                  // ),
                  YoutubePlayer(
                    controller: YoutubePlayerController(
                      initialVideoId:
                          YoutubePlayer.convertUrlToId(widget.videoLink)!,
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
                        playedColor: Colors.red, handleColor: Colors.redAccent),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.videoTitle,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
