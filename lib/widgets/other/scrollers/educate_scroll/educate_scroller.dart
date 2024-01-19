import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/constants/placeholder_images.dart';
import 'package:healthonify_mobile/models/adventure.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/widgets/other/scrollers/educate_scroll/educate_scroll_byid.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class EducateScroller extends StatefulWidget {
  final String imgUrl;
  final String cardTitle;
  final String scrollerTitle;

  const EducateScroller({
    required this.cardTitle,
    required this.imgUrl,
    required this.scrollerTitle,
    Key? key,
  }) : super(key: key);

  @override
  State<EducateScroller> createState() => _EducateScrollerState();
}

class _EducateScrollerState extends State<EducateScroller> {
  List<Educate> educateData = [];

  Future<void> getEducateData() async {
    String url = '${ApiUrl.url}get/howTo';
    List<Educate> loadedData = [];
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
            Educate(
              name: element["name"],
              id: element["_id"],
              description: element["description"],
              mediaLink: element["mediaLink"],
              thumbnail: element["thumbnail"],
              format: element["format"],
            ),
          );
        }

        // log(data.toString());
        educateData = loadedData;
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
      future: getEducateData(),
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
                      itemCount: educateData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () async {
                                    Navigator.of(
                                      context,
                                    ).push(
                                        MaterialPageRoute(builder: (context) {
                                      return EducateScrollById(
                                        educate: educateData[index],
                                      );
                                    }));
                                  },
                                  child: Image.network(
                                     educateData[index].thumbnail!,
                                    height: 110,
                                    width: 150,
                                    fit: BoxFit.fill,
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
                                  educateData[index].name!,
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
