import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/adventure.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';

class EducateScrollById extends StatefulWidget {
  const EducateScrollById({Key? key, required this.educate}) : super(key: key);
  final Educate educate;

  @override
  State<EducateScrollById> createState() => _EducateScrollByIdState();
}

class _EducateScrollByIdState extends State<EducateScrollById> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
      Uri.parse(widget.educate.mediaLink!),
    ));
  }

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
              widget.educate.format == "externalLink"
                  ? YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: YoutubePlayer.convertUrlToId(
                            widget.educate.mediaLink!)!,
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
                  : widget.educate.format == "video"
                      ? FlickVideoPlayer(flickManager: flickManager)
                      : const SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.educate.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
