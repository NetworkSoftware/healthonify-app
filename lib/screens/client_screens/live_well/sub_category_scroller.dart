import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/live_well/live_well_models.dart';
import 'package:healthonify_mobile/providers/live_well_providers/live_well_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/category_videos.dart';
import 'package:provider/provider.dart';

class SubCategoryScroller extends StatefulWidget {
  final String parentCategoryId;
  const SubCategoryScroller({required this.parentCategoryId, super.key});

  @override
  State<SubCategoryScroller> createState() => _SubCategoryScrollerState();
}

class _SubCategoryScrollerState extends State<SubCategoryScroller> {
  bool isLoading = true;
  List<LiveWellCategories> liveWellSubCategories = [];

  Future<void> getSubCategories() async {
    try {
      liveWellSubCategories = await Provider.of<LiveWellProvider>(context,
              listen: false)
          .getLiveWellCategories("parentCategoryId=${widget.parentCategoryId}");
      log('fetched live well sub categories');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting live well sub categories: $e");
      Fluttertoast.showToast(msg: "Unable to fetch live well sub categories");
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
    return SizedBox(
      height: 184,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: liveWellSubCategories.length,
        itemBuilder: (context, horizontalIndex) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: 150,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LiveWellCategoryVideos(
                            screenTitle:
                                liveWellSubCategories[horizontalIndex].name!,
                            categoryId:
                                liveWellSubCategories[horizontalIndex].id!,
                          );
                        }));
                      },
                      child: liveWellSubCategories[horizontalIndex].mediaLink! != "" ?

                      Image.network(
                        liveWellSubCategories[horizontalIndex].mediaLink!,
                        height: 110,
                        width: 150,
                        fit: BoxFit.cover,
                      ) : Image.network(
                        "https://imgs.search.brave.com/CNgFo39JPnzZ-_gX9zaubIZmQc2ZhkcKE1XwwqY-vUY/rs:fit:1200:960:1/g:ce/aHR0cDovL2ltZy54/Y2l0ZWZ1bi5uZXQv/dXNlcnMvMjAxNC8w/Ny8zNTkwMzkseGNp/dGVmdW4tc3Vuc2V0/LWJlYWNoLTQuanBn",
                        height: 110,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    liveWellSubCategories[horizontalIndex].name!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
