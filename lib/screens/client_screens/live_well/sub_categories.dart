import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/live_well/live_well_models.dart';
import 'package:healthonify_mobile/providers/live_well_providers/live_well_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/live_well/category_videos.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:provider/provider.dart';

class SubCategoriesScreen extends StatefulWidget {
  final String screenTitle;
  final String parentCategoryId;

  const SubCategoriesScreen(
      {required this.screenTitle, required this.parentCategoryId, super.key});

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  bool isLoading = true;
  List<LiveWellCategories> subCategories = [];

  Future<void> getSubCategories() async {
    try {
      subCategories = await Provider.of<LiveWellProvider>(context,
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
                    itemCount: subCategories.length,
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
                                return LiveWellCategoryVideos(
                                  categoryTitle: widget.screenTitle,
                                  screenTitle: subCategories[index].name!,
                                  categoryId: subCategories[index].id!,
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
                                      subCategories[index].mediaLink != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.network(
                                                subCategories[index].mediaLink!,
                                                height: 80,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ))
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.asset(
                                                'assets/icons/some.png',
                                                height: 80,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                              // : Image.network(
                                              //     data[index].thumbnail!,
                                              //     height: 65,
                                              //     width: 100,
                                              //     fit: BoxFit.cover,
                                              //   ),
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
                                                subCategories[index].name!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                subCategories[index]
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
