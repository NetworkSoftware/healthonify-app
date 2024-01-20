import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/live_well/live_well_models.dart';
import 'package:healthonify_mobile/providers/live_well_providers/live_well_provider.dart';
import 'package:healthonify_mobile/screens/video_screen/video_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class LiveWellCategoryVideos extends StatefulWidget {
  final String screenTitle;
  final String categoryId;
  final String? categoryTitle;
  const LiveWellCategoryVideos(
      {required this.screenTitle,
      required this.categoryId,
      this.categoryTitle,
      super.key});

  @override
  State<LiveWellCategoryVideos> createState() => _LiveWellCategoryVideosState();
}

class _LiveWellCategoryVideosState extends State<LiveWellCategoryVideos> {
  bool isLoading = true;
  List<ContentModel> categoryContent = [];

  Future<void> getSubCategories() async {
    try {
      categoryContent =
          await Provider.of<LiveWellProvider>(context, listen: false)
              .getContent(widget.categoryId);

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
      appBar: CustomAppBar(appBarTitle: widget.screenTitle),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: categoryContent.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return VideoScreen(
                                  videoTitle: categoryContent[index].title!,
                                  description:
                                      categoryContent[index].description!,
                                  videoLink: categoryContent[index].mediaLink!,
                                  videoId: categoryContent[index].id!,
                                  playlistId: widget.categoryId,
                                );
                              }));
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(
                                          categoryContent[index].thumbnail ??
                                              "https://imgs.search.brave.com/tmNeS6hU9sY_YJpxJVyn99TW3WUMxInZ2zW1qf2m0b8/rs:fit:1200:960:1/g:ce/aHR0cHM6Ly9hc3Nl/dHMud2ViaWNvbnNw/bmcuY29tL3VwbG9h/ZHMvMjAxNi8xMi9Q/bGFjZWhvbGRlci1W/ZWN0b3ItQXJ0LUlj/b24ucG5n",
                                          height: 80,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                categoryContent[index].title!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                categoryContent[index]
                                                    .description!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
