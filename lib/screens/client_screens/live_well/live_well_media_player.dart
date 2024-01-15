import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../widgets/cards/custom_appbar.dart';

class LiveWellMediaPLayer extends StatefulWidget {
  const LiveWellMediaPLayer(
      {Key? key, required this.url, required this.format, required this.title})
      : super(key: key);
  final String url;
  final String format;
  final String title;

  @override
  State<LiveWellMediaPLayer> createState() => _LiveWellMediaPLayerState();
}

class _LiveWellMediaPLayerState extends State<LiveWellMediaPLayer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  final player = audio.AudioPlayer();
  bool isPlaying = true;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    if (widget.format == "Audio") {
      audioPlayer();
    }

    player.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == audio.PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    player.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  audioPlayer() async {
    await player.play(audio.UrlSource(widget.url));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: widget.title),
      body: widget.format == "Pdf file"
          ? SfPdfViewer.network(
              widget.url,
              key: _pdfViewerKey,
            )
          : widget.format == "Video"
              ? YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: YoutubePlayer.convertUrlToId(widget.url)!,
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
                )
              : widget.format == "Audio"
                  ? Center(
                      child: Column(
                        children: [
                          Slider(
                              min: 0,
                              max: duration.inSeconds.toDouble(),
                              value: position.inSeconds.toDouble(),
                              onChanged: (value) async {
                                final position =
                                    Duration(seconds: value.toInt());
                                await player.seek(position);

                                await player.resume();
                              }),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formatDurationInHhMmSs(position)),
                                Text(formatDurationInHhMmSs(
                                    duration - position)),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (isPlaying) {
                                await player.pause();
                              } else {
                                await player.resume();
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: orange),
                              child: Center(
                                child: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  :

      const SizedBox(),
    );
  }

  String formatDurationInHhMmSs(Duration duration) {
    //final HH = (duration.inHours).toString().padLeft(2, '0');
    final mm = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final ss = (duration.inSeconds % 60).toString().padLeft(2, '0');

    // return '$HH:$mm:$ss';
    return '$mm:$ss';
  }
}
