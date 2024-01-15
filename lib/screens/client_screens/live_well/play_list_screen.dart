import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/live_well/live_well_models.dart';
import 'package:healthonify_mobile/providers/live_well_providers/live_well_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/live_well_media_player.dart';
import 'package:healthonify_mobile/screens/video_screen/video_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class LiveWellPlayListVideos extends StatefulWidget {
  final String playListId;
  final String playListTitle;

  const LiveWellPlayListVideos(
      {required this.playListId, required this.playListTitle, super.key});

  @override
  State<LiveWellPlayListVideos> createState() => _LiveWellPlayListVideosState();
}

class _LiveWellPlayListVideosState extends State<LiveWellPlayListVideos> {
  bool isLoading = true;
  List<ContentModel> categoryContent = [];
  List<ContentModel> audioContent = [];
  List<ContentModel> videoContent = [];
  List<ContentModel> pdfContent = [];

  Future<void> getSubCategories() async {
    try {
      categoryContent =
          await Provider.of<LiveWellProvider>(context, listen: false)
              .fetchPlayList(widget.playListId);

      for(int i =0; i<categoryContent.length; i++){
        if(categoryContent[i].format == "Video"){
          videoContent.add(categoryContent[i]);
        }else if(categoryContent[i].format == "Pdf file"){
          pdfContent.add(categoryContent[i]);
        }else if(categoryContent[i].format == "Audio"){
          audioContent.add(categoryContent[i]);
        }
      }

      log('fetched category videos');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting category videos: $e");
      Fluttertoast.showToast(msg: "Unable to fetch category videos");
    } finally {
      setState(() {

        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSubCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: widget.playListTitle),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          :
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            videoContent.isNotEmpty ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Video",style: Theme.of(context)
                    .textTheme
                    .headlineMedium!),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: videoContent.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return LiveWellMediaPLayer(
                                          title: videoContent[index].title!,
                                          url: videoContent[index].mediaLink!,
                                          format: videoContent[index].format!,
                                        );
                                      }));
                                },
                                child: Card(
                                  elevation: 3,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).drawerTheme.backgroundColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.network(
                                            videoContent[index].thumbnail!,
                                            height: 100,
                                            width: MediaQuery.of(context).size.width,
                                            fit: BoxFit.fill,
                                          ),
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding:
                                                const EdgeInsets.symmetric(horizontal: 5),
                                            child: Text(
                                              videoContent[index].title!,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.symmetric(horizontal: 5),
                                            child: Text(
                                              videoContent[index].description!,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  Theme.of(context).textTheme.labelSmall!,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ) : const SizedBox(),
            audioContent.isNotEmpty ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Audio",style: Theme.of(context)
                    .textTheme
                    .headlineMedium!),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: audioContent.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return LiveWellMediaPLayer(
                                    title: audioContent[index].title!,
                                    url: audioContent[index].mediaLink!,
                                    format: audioContent[index].format!,
                                  );
                                }));
                          },
                          child: Card(
                            elevation: 3,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).drawerTheme.backgroundColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // / Image.asset("assets/images/document.png",height: 50,width: 50,),
                                    Image.network(
                                      audioContent[index].thumbnail!,
                                      height: 100,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        audioContent[index].title!,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        audioContent[index].description!,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                        Theme.of(context).textTheme.labelSmall!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ) : const SizedBox(),
            pdfContent.isNotEmpty ?
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Document",style: Theme.of(context)
                    .textTheme
                    .headlineMedium!),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: pdfContent.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return LiveWellMediaPLayer(
                                    title: pdfContent[index].title!,
                                    url: pdfContent[index].mediaLink!,
                                    format: pdfContent[index].format!,
                                  );
                                }));
                          },
                          child: Card(
                            elevation: 3,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).drawerTheme.backgroundColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // / Image.asset("assets/images/document.png",height: 50,width: 50,),
                                    Image.network(
                                      pdfContent[index].thumbnail!,
                                      height: 100,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        pdfContent[index].title!,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        pdfContent[index].description!,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                        Theme.of(context).textTheme.labelSmall!,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ) : const SizedBox(),
          ],
        ),
      ) ,
    );
  }
}
