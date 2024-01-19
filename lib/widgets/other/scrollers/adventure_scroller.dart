import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/constants/placeholder_images.dart';
import 'package:healthonify_mobile/models/adventure.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AdventureScroller extends StatefulWidget {
  final String imgUrl;
  final String cardTitle;
  final String scrollerTitle;
  const AdventureScroller({
    required this.cardTitle,
    required this.imgUrl,
    required this.scrollerTitle,
    Key? key,
  }) : super(key: key);

  @override
  State<AdventureScroller> createState() => _AdventureScrollerState();
}

class _AdventureScrollerState extends State<AdventureScroller> {
  List<Adventure> adventureData = [];

  Future<void> getTravelData() async {
    String url = '${ApiUrl.url}get/travelPackage?isSpecial=true';
    List<Adventure> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = responseData['data'] as List<dynamic>;

        for (var element in data) {
          loadedData.add(
            Adventure(
              imageUrl: element["imageUrl"][0]["mediaLink"] == ""
                  ? placeholderImg
                  : element["imageUrl"][0]["mediaLink"],
              packageName: element["packageName"],
              id: element["_id"],
            ),
          );
        }

        // log(data.toString());
        adventureData = loadedData;
        // log(adventureData[0].packageName!);
      } else {
        throw HttpException(responseData["message"]);
      }
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get get top level expertise widget $e");
      // Fluttertoast.showToast(msg: "Unable to fetch water intake data");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTravelData(),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const SizedBox(
              height: 10,
            )
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                    child: Text(
                      widget.scrollerTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  SizedBox(
                    height: 154,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: adventureData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () async {
                                    await launchUrl(
                                      Uri.parse(
                                        'https://healthonify.com/travelonify/Traveldetails/${adventureData[index].id}',
                                      ),
                                    );
                                  },
                                  child: Image.network(
                                    adventureData[index].imageUrl!,
                                    height: 110,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 2),
                                width: 150,
                                child: Text(
                                  adventureData[index].packageName!,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ),
    );
  }
}
