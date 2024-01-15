import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/physio/create_package.dart';
import 'package:provider/provider.dart';

class ExpertiseBottomSheet {
  static Future<void> getExpertise(BuildContext context, String? id) async {
    try {
      await Provider.of<ExpertiseData>(context, listen: false)
          .fetchExpertise("6229a980305897106867f787");
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get fetch expertise $e");
      Fluttertoast.showToast(msg: "Unable to fetch expertise");
    }
  }

  static void showExpertiseBottomSheet(
    BuildContext context,
    String? id,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => FutureBuilder(
        future: getExpertise(context, id),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<ExpertiseData>(
                builder: (context, data, child) => DraggableScrollableSheet(
                  initialChildSize: 0.9,
                  builder: (context, scrollController) => Container(
                    color: grey,
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: data.expertise.length,
                      itemBuilder: (cxt, index) => InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => CreatePackage(
                                    expertiseId: data.expertise[index].id,
                                    expertId: id,
                                  )));
                        },
                        child: Column(
                          children: [
                            Card(
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.expertise[index].name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
