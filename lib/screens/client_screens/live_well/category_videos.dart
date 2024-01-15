import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/live_well/live_well_models.dart';
import 'package:healthonify_mobile/providers/live_well_providers/live_well_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/play_list_screen.dart';
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
              .getPlayList(widget.categoryId);

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
            : GridView.builder(
                itemCount: categoryContent.length,
                physics: const ScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                cacheExtent: 10000,
                addAutomaticKeepAlives: true,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (1.0 / 3.5) / (1.0 / 3),
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return LiveWellPlayListVideos(
                              playListId: categoryContent[index].id!,
                              playListTitle: categoryContent[index].title!,
                            );
                          }));

                    },
                    child
                        : Card(
                      elevation: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).drawerTheme.backgroundColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                categoryContent[index].mediaLink!,
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fill,
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  categoryContent[index].title!,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  categoryContent[index].description!,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.labelSmall!,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}
